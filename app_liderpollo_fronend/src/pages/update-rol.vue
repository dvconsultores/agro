<template>
  <Navbar title="Roles" sub-title="Editar Rol" class="mb-4" />

  <custom-modal
    ref="modalSuccess"
    title="¡Guardado exitoso!"
    title-class="text-primary w600"
    title-center
    hide-actions
    @close="handleClose"
  />

  <custom-modal
    ref="modalConfirm"
    title-class="text-primary w600"
    title-center
    cancel-button-text="No, Cancelar"
    confirm-button-text="Si, Editar"
    :disabled="!validForm"
    :loading="isLoading"
    @click="handleSave"
  >
    <template #title>
      ¿Deseas editar<br>el rol?
    </template>
  </custom-modal>

  <div id="create-roles">
    <h5 class="text-primary w600 mb-6" style="--fs: 22px">Editar Rol</h5>

    <v-card class="px-4 py-6" elevation="0">
      <h6 class="text-primary w600 mb-6">Registro</h6>

      <v-form v-model="validForm">
        <section class="d-flex flex-wrap" style="column-gap: 8px; row-gap: 0;">
          <div class="d-flex" style="flex-basis: 1590px; gap: 8px;">
            <v-text-field
              v-model="data.nombre"
              variant="solo"
              label="Nombre del Rol"
              placeholder="Administrador"
              persistent-placeholder
              style="flex-basis: 253px;"
              :rules="[globalRules.required]"
            ></v-text-field>

            <v-text-field
              v-model="data.descripcion"
              variant="solo"
              label="Descripción"
              placeholder="Super usuario del sistema tiene todos los permisos"
              persistent-placeholder
              style="flex-basis: 253px;"
              :rules="[globalRules.required]"
            ></v-text-field>
          </div>

          <div class="d-flex" style="flex-basis: 1590px; gap: 8px;">
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

            <v-autocomplete
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
                  v-if="index == 1"
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
            </v-autocomplete>
          </div>





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
import ApiLiderPollo from '@/repository/api-sap-avicola';
import variables from '@/mixins/variables';
import { useToast } from "vue-toastification";
import { useRoute, useRouter } from 'vue-router';
import AuthApi from '@/repository/auth_api';

const
route = useRoute(),
router = useRouter(),
rolId = route.query?.rolId,
toast = useToast(),
{ globalRules } = variables,
modalSuccess = ref(),
modalConfirm = ref(),
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
data = ref({
    id: undefined,
    nombre: undefined,
    descripcion: undefined,
    leer: false,
    insertar: false,
    editar: false,
    eliminar: false,
    modulos: undefined,
  });


onBeforeMount(() => {
  if (!rolId) {
    router.back();
  }
  getData();

})

watch(modulos, onModulosChange);

async function getData() {
  await ApiLiderPollo.users.getModulos().then(response => {
    modulosItems.value = response
  }).catch(error => {
    console.log(error)
  });

  await ApiLiderPollo.users.getRol(rolId).then(response => {
    //cargando modulos
    modulos.value = response.modulos.map((item) => item.id);

    //cargando submodulos
    subModulos.value = response.subModulos.map((item) => { return { id: item.id, nombre: item.nombre, idModulo: item.moduloId} });

    //cargando permisos
    data.value.leer = response.permisos.includes("leer");
    data.value.insertar = response.permisos.includes("insertar");
    data.value.editar = response.permisos.includes("editar");
    data.value.eliminar = response.permisos.includes("eliminar");

    //cargando nombre y descripcion
    data.value.id = response.id;
    data.value.nombre = response.nombre;
    data.value.descripcion = response.descripcion;


  }).catch(error => {
    console.log(error)
  });


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
  });
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
    await ApiLiderPollo.users.updateRol(data.value);
    await AuthApi.loadRoles();

    modalConfirm.value.closeModal();
    modalSuccess.value.showModal();

  } catch (error) {
    console.log(error)
    toast.error(error)
    modalConfirm.value.closeModal();
  }

  isLoading.value = false;
}

function handleClose() {
  router.back();
  window.location.reload();
}
</script>

<!--<style scoped>
.v-select .v-select__selections {
  max-height: 100px !important; /* Ajusta la altura máxima del contenedor de chips */
  overflow-y: auto !important; /* Agrega un scroll vertical si los chips se desbordan */
}
</style> -->
