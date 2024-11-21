<template>
  <Navbar title="Roles" sub-title="Crear/ver Roles" class="mb-4" />

  <custom-modal
    ref="modalSuccess"
    title="¡Guardado exitoso!"
    title-class="text-primary w600"
    title-center
    hide-actions
  />

  <custom-modal
    ref="modalConfirm"
    title-class="text-primary w600"
    title-center
    cancel-button-text="No, Cancelar"
    confirm-button-text="Si, Guardar"
    :disabled="!validForm"
    :loading="isLoading"
    @click="handleSave"
  >
    <template #title>
      ¿Deseas guardar<br>el rol?
    </template>
  </custom-modal>

  <div id="create-roles">
    <h5 class="text-primary w600 mb-6" style="--fs: 22px">Nuevo Rol</h5>

    <v-tabs v-model="currentTab" hide-slider height="38">
      <v-tab
        v-for="(item, i) in tabs" :key="i"
        base-color="title-variant"
        color="primary"
        elevation="3"
        class="w700 mt-1"
        :style="`border-radius: 8px 8px 0 0 !important; background-color: ${currentTab == i ? '#fff' : '#E4E5E9'};`"
      >{{ item }}</v-tab>
    </v-tabs>

    <v-data-table
      v-if="currentTab == 0"
      :headers="headers"
      :items="roles"
      hide-default-footer
      :loading="loadingTable"
    >
      <template #item.permissions="{ item }">
        <span class="text-error">{{ item.permissions }}</span>
      </template>

      <template #item.deactivate="{ item }">
        <div class="w-100 d-flex flex-center">
          <v-switch
            v-model:model-value="item.deactivate"
            width="52"
            hide-details
            @change="changeStatusRol(item.name, item.id, item.deactivate)"
          />
        </div>
      </template>

      <template #item.actions="{ item }">
        <v-btn size="25" max-height="25" variant="text" icon elevation="0" class="text-foreground" style="border-radius: 100%;" :to="{ name: 'UpdateRol', query: { rolId: item.id }}">
          <v-icon icon="mdi-square-edit-outline" size="20" />
        </v-btn>
      </template>
    </v-data-table>

    <v-card v-if="currentTab == 1" class="px-4 py-6" elevation="0">
      <h6 class="text-primary w600 mb-6">Registro</h6>

      <v-form v-model="validForm">
        <section class="d-flex flex-wrap" style="column-gap: 8px; row-gap: 0;">
          <v-text-field
          v-model="data.nombre"
            variant="solo"
            label="Nombre del Rol"
            placeholder="Administrador"
            persistent-placeholder
            style="flex-basis: 253px;"
            :rules="[globalRules.required]"
          ></v-text-field>

          <v-select
            v-model="modulos"
            variant="solo"
            label="Módulo"
            placeholder="Todos"
            persistent-placeholder
            :items="modulosItems"
            item-title="nombre"
            item-value="id"
            menu-icon="mdi-chevron-down"
            style="flex-basis: 253px;"
            chips
            multiple
            :rules="[globalRules.listRequired]"
          ></v-select>

          <v-select
          v-model="subModulos"
            variant="solo"
            label="Sub Móodulo"
            placeholder="Todos"
            persistent-placeholder
            :items="subModulosItems"
            item-title="nombre"
            item-value="id"
            return-object="true"
            menu-icon="mdi-chevron-down"
            style="flex-basis: 253px;"
            multiple
            max-chips="6"
            :rules="[globalRules.listRequired]"
          >
            <template v-slot:selection="{ item, index }">
              <v-chip v-if="index < 1">
                <span>{{ item.title }}</span>
              </v-chip>
              <span
                v-if="index === 1"
                class="text-grey text-caption align-self-center"
              >
                (+{{ subModulos.length - 1 }} otros)
              </span>
            </template>
            <template v-slot:item="{ index, item, props }">
              <v-list-item v-if="!subModulosItems[index]?.header" v-bind="props">
                <v-list-item-content class="d-flex align-center">
                  <v-list-item-title>
                      {{ item.nombre }}
                  </v-list-item-title>
                </v-list-item-content>
              </v-list-item>

              <v-divider v-else></v-divider>
              <v-list-item v-if="subModulosItems[index]?.header" v-bind="props" disabled>
                <v-list-item-content>
                  <v-list-item-title>{{ item?.nombre }}</v-list-item-title>
                </v-list-item-content>
              </v-list-item>
            </template>
          </v-select>

          <v-text-field
            v-model="data.descripcion"
            variant="solo"
            label="Descripción"
            placeholder="Super usuario del sistema tiene todos los permisos"
            persistent-placeholder
            style="flex-basis: 253px;"
            :rules="[globalRules.required]"
          ></v-text-field>
        </section>

        <h6 class="text-primary w600 mb-6">Permisos</h6>

        <section class="d-flex flex-wrap mb-6" style="gap: 8px">
          <label
            v-for="(item, i) in accesos" :key="i"
            :for="item"
            class="flex-grow-1"
            style="max-width: 273"
          >
            <v-card class="d-flex flex-column-center py-1 px-2 text-title-variant pointer">
              <span style="font-size: 14px;">{{ item.nombre }}</span>
              <v-checkbox
                v-model="data[item.id]"
                :id="item.id"
                density="compact"
                color="primary"
                class="mx-auto"
                hide-details
              />
            </v-card>
          </label>
        </section>

        <v-btn
          width="170"
          class="btn ml-auto"
          :disabled="!validForm"
          :loading="isLoading"
          @click="modalConfirm.showModal()"
        >Guardar</v-btn>
      </v-form>
    </v-card>



  </div>
</template>

<script setup>
import '@/assets/styles/pages/create-roles.scss'
import { phoneState } from '@/models/phone-state-model';
import { userState } from '@/models/user-state-model';
import { ref, onBeforeMount, watch } from 'vue'
import ApiLiderPollo from '@/repository/api-lider-pollo';
import variables from '@/mixins/variables';
import { useToast } from "vue-toastification";

const
toast = useToast(),
{ globalRules } = variables,
modalSuccess = ref(),
modalConfirm = ref(),
currentTab = ref(0),
tabs = ['Ver roles', 'Crear roles'],
validForm = ref(false),
isLoading = ref(false),
modulos = ref([]),
modulosItems = ref([]),
subModulos = ref([]),
subModulosItems = ref([]),
accesos = [
  {id: 'leer', nombre: 'Leer' },
  {id: 'insertar', nombre: 'Crear' },
  {id: 'editar', nombre: 'Editar' },
  {id: 'eliminar', nombre: 'Eliminar' },
],
headers = [
  { title: "Nombre", key: "name", align: "center" },
  { title: "Módulo", key: "module", align: "center" },
  { title: "Sub Módulo", key: "subModule", align: "center" },
  { title: "Descripción", key: "description", align: "center" },
  { title: "N° de Usuarios con el rol", key: "usersRole", align: "center" },
  { title: "Permisos", key: "permissions", align: "center" },
  { title: "Desactivar", key: "deactivate", align: "center" },
  { title: "Acciones", key: "actions", align: "center", sortable: false },
],
roles = ref([]),
loadingTable = ref(false),
data = ref({
    nombre: undefined,
    descripcion: undefined,
    leer: false,
    insertar: false,
    editar: false,
    eliminar: false,
    modulos: undefined,
  });


onBeforeMount(() => {
  getModulos();
  getRoles();
})

watch(modulos, onModulosChange);

function getModulos() {
  ApiLiderPollo.users.getModulos().then(response => {
    modulosItems.value = response
  }).catch(error => {
    console.log(error)
    toast.error(`Error api users.getModulos: ${error}`);
  });
}

async function getRoles() {
  try {
    loadingTable.value = true;

    const response = await ApiLiderPollo.users.getRoles()

    roles.value = response.map((item) => ({
      id: item.id,
      name: item.nombre,
      module: item.modulos.map((item) => item.nombre).join(', '),
      subModule: item.subModulos.map((item) => item.nombre).join(', '),
      description: item.descripcion,
      usersRole: item.catnUserRol,
      permissions: item.permisos.join(', '),
      deactivate: item.isActive
    }))
    loadingTable.value = false;
  } catch (error) {
    loadingTable.value = false;
    console.log(error)
    toast.error(`Error api users.getRoles: ${error}`);
  }
}

function onModulosChange(newVal, oldVal) {
  ApiLiderPollo.users.getSubModulos(newVal)
    .then(response => {
      const subModulosMap = [];
      /*
      ejemplo:
      [
        { id: 1, nombre: 'Todos' },
        { id: 2, nombre: 'Usuarios' },
        { id: 2, nombre: 'titulo 1', header: true },
        { id: 3, nombre: 'Roles' },
        { id: 4, nombre: 'Permisos' },
      ]
      */

      response.forEach((item) => {
        subModulosMap.push({ id: item.id, nombre: item.nombre, header: true });
        item.user_sub_modulos.forEach((subModulo) => {
          subModulosMap.push({ id: subModulo.id, nombre: subModulo.nombre, idModulo: item.id});
        });
      });

      subModulosItems.value = subModulosMap;
    }).catch(error => {
      console.log(error)
      toast.error(`Error api users.getSubModulos: ${error}`);
    });
}

async function changeStatusRol(rolName, rolId, isActive) {
  try {
    await ApiLiderPollo.users.changeStatusRol({rolId, status: isActive});
    toast.success(`Se cambio con exito el estatus del rol "${rolName}" a "${isActive ? "Activo" : "Inactivo"}"`);
  } catch (error) {
    console.log(error)
    toast.error(`Error api users.changeStatusRol: ${error}`);
  }
}


async function handleSave() {
  if (isLoading.value || !validForm.value) {
    modalConfirm.value.closeModal();
    return
  }
  isLoading.value = true;

  //armando informacion de modulos y submodulos
  const modulosData = [];

  subModulos.value.forEach((item) => {
    const subModuloData = modulosData.find((element) => element.moduloId == item.idModulo)

    if (subModuloData) {
      subModuloData.subModulos.push(item.id)
    } else {
      modulosData.push({
        moduloId: item.idModulo,
        subModulos: [item.id]
      })
    }

  })

  // cargando la informacion de modulos y submodulos en data
  data.value.modulos = modulosData

  try {
    await ApiLiderPollo.users.createRol(data.value);

    // blaqueando las variables
    data.value = {
      nombre: undefined,
      descripcion: undefined,
      leer: false,
      insertar: false,
      editar: false,
      eliminar: false,
      modulos: undefined,
    };
    modulos.value = [];
    subModulos.value = [];

    modalConfirm.value.closeModal();
    modalSuccess.value.showModal();

    getRoles();
  } catch (error) {
    console.log(error)
    toast.error(error)
    modalConfirm.value.closeModal();
  }

  isLoading.value = false;
}
</script>
