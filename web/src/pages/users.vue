<template>
  <Navbar title="Usuarios" sub-title="Crea, elimina, bloquea y cambia la contraseña" class="mb-4" />

  <div id="users">
    <h5 class="text-primary w600 mb-6" style="--fs: 22px">Buscar</h5>

    <aside class="d-flex mb-4" style="gap: 24px">
      <v-text-field
        v-model="searchUsers"
        variant="solo"
        label="Buscar"
        placeholder="Por usuario, nombre, apellido, cedula o correo"
        persistent-placeholder
        hide-details
        clearable
        class="search"
        v-debounce:400="() => callSearchUsers(searchUsers)"
      >
        <template #append-inner>
          <v-divider vertical class="mr-2" inset style="opacity: 1;" />
          <img src="@/assets/sources/icons/search_people.svg" alt="search people icon">
        </template>
      </v-text-field>

      <v-btn variant="outlined" min-height="54" color="primary" elevation="1" class="btn" to="/create-user">
        <v-icon icon="mdi-plus" />
        Crear usuario
      </v-btn>
    </aside>

    <v-data-table
      :headers="headers"
      :items="users"
      :loading="loadingUsers"
    >
      <template #item.phoneState="{ item }">
        <v-chip density="compact" class="text-white" rounded :style="`background: ${item.phoneState.color}`">
          {{ item.phoneState.text }}
        </v-chip>
      </template>

      <template #item.block="{ item }">
        <div class="w-100 d-flex flex-center">
          <v-switch
            v-model:model-value="item.block"
            width="52"
            hide-details
            @change="changeStatusUser(item.nickname, item.id, item.block)"
          />
        </div>
      </template>

      <template #item.actions="{ item }">
        <v-btn tag="Editar usuario" size="25" max-height="25" variant="text" icon elevation="0" class="text-foreground" style="border-radius: 100%;" :to="{ name: 'EditarUser', query: { userId: item.id }}" >
          <v-icon icon="mdi-square-edit-outline" size="20" />
        </v-btn>

        <v-tooltip bottom>
          <template #activator="{ on, attrs }">
            <v-btn size="25" max-height="25" variant="text" icon elevation="0" class="text-foreground" style="border-radius: 100%;" @click="clearMac(item.nickname, item.id)">
              <v-icon size="20">
                <svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><path fill="currentColor" d="m19.36 2.72l1.42 1.42l-5.72 5.71c1.07 1.54 1.22 3.39.32 4.59L9.06 8.12c1.2-.9 3.05-.75 4.59.32zM5.93 17.57c-2.01-2.01-3.24-4.41-3.58-6.65l4.88-2.09l7.44 7.44l-2.09 4.88c-2.24-.34-4.64-1.57-6.65-3.58"/></svg>
              </v-icon>
            </v-btn>
          </template>
          <span>Limpiar MAC</span>
        </v-tooltip>
      </template>

      <template #bottom="{  }">
        <div class="d-flex flex-center px-3 py-4">
          Desplegando {{ page }}-{{ itemsPerPage }} de {{ pageCount }} resultados

          <v-pagination
            v-model="page"
            :length="pageCount"
            total-visible="5"
            class="ml-auto"
          >
            <template #prev="{ onClick, disabled }">
              <v-btn variant="text" class="my-auto" elevation="0" :disabled="disabled" @click="onClick">
                Anterior
              </v-btn>
            </template>

            <template #next="{ onClick, disabled }">
              <v-btn variant="text" class="my-auto" elevation="0" :disabled="disabled" @click="onClick">
                Siguiente registro
              </v-btn>
            </template>
          </v-pagination>
        </div>
      </template>
    </v-data-table>
  </div>
</template>

<script setup>
import '@/assets/styles/pages/users.scss'
import { phoneState } from '@/models/phone-state-model';
import ApiLiderPollo from '@/repository/api-sap-avicola';
import { onBeforeMount, ref, watch } from 'vue';
import { useToast } from "vue-toastification";

const
toast = useToast(),
headers = [
  { title: "Acciones", key: "actions", align: "center", sortable: false },
  { title: "Nombre", key: "name", align: "center" },
  { title: "Apellido", key: "lastname", align: "center" },
  { title: "Correo", key: "email", align: "center" },
  { title: "Usuario", key: "nickname", align: "center" },
  //{ title: "Contrasña", key: "password", align: "center" },
  { title: "Numero telf.", key: "phone", align: "center" },
  { title: "MAC", key: "mac", align: "center" },
  // { title: "Estado telf.", key: "phoneState", align: "center" },
  { title: "Rol", key: "role", align: "center" },
  { title: "Activo", key: "block", align: "center" },
],
loadingUsers = ref(false),
users = ref([]),
searchUsers = ref(null),
pageCount = ref(0),
itemsPerPage = ref(5),
page = ref(1);

onBeforeMount(() => {
  usersList();
})

async function callSearchUsers(val) {
  await usersList(undefined, 0, val);
}

watch(page, (newVal, oldVal) => {
  const indexPage = (newVal - 1) * Number(itemsPerPage.value);
  usersList(undefined, indexPage, searchUsers.value);
});

async function changeStatusUser(userName, id, isActive) {
  try {
    await ApiLiderPollo.users.updateUser({id, isActive});
    toast.success(`Se cambio con exito el estatus del usuario "${userName}" a "${isActive ? "Activo" : "Inactivo"}"`);
  } catch (error) {
    console.log(error)
    toast.error(error)
  }
}

async function clearMac(userName, userId) {
  try {
    await ApiLiderPollo.users.clearMac(userId);
    toast.success(`Se limpio con exito la mac del usuario "${userName}"`);
  } catch (error) {
    console.log(error)
    toast.error(error)
  }
}


async function usersList(limit = itemsPerPage.value, index = 0, search = "") {
  try {
    loadingUsers.value = true;
    const response = await ApiLiderPollo.users.getUsers({ limit, index, search });
    pageCount.value = Math.ceil(Number(response[1]) / Number(itemsPerPage.value));
    
    users.value =  response[0].map((item) => ({
      id: item.id,
      name: item.nombre,
      lastname: item.apellido,
      email: item.email,
      nickname: item.user_name,
      role: item?.user_role_id?.nombre || "",
      block: item.is_active,
      phone: item?.telefono || "",
      mac: item.mac
    }))
    loadingUsers.value = false;
  } catch (error) {
    loadingUsers.value = false;
    console.log(error)
  }
}


</script>
