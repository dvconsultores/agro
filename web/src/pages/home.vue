<template>
  <Navbar title="Panel Principal" sub-title="Inicio" class="mb-4" />

  <div id="home">
    <h1 class="w400 mb-6" style="--fs: 2.25em">Bienvenido {{ userName }}</h1>
    <h5 class="text-primary w600" style="--fs: 1.375em">Indicadores</h5>

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

    <section v-if="currentTab == 0" class="d-flex py-1 px-1 mx-n1 mt-2" style="overflow: auto; gap: 16px;">
      <v-card
        v-for="(item, i) in indicatorsCrias" :key="i"
        width="158"
        class="py-2 px-3 d-flex flex-column text-foreground-2 flex-shrink-0"
      >
        <simple-pie-chart v-if="!item?.icon && item?.percent >= 0" :value="item.percent" :color="item.color" class="mb-2" />
        <img v-if="item?.icon" :src="item.icon" alt="ref icon" style="height: 57px !important; width: 57px !important;">
        <div v-if="!item?.icon && item?.percent < 0 " style="margin-bottom: 50px;"></div>

        <h6 class="mb-1 w700" style="--fs: 12px">{{ item.name }}</h6>
        <span class="w500" style="font-size: 12px;">{{ item.value }}</span>
      </v-card>
    </section>

    <section v-if="currentTab == 1" class="d-flex py-1 px-1 mx-n1 mt-2" style="overflow: auto; gap: 16px;">
      <v-card
        v-for="(item, i) in indicatorsProduccion" :key="i"
        width="158"
        class="py-2 px-3 d-flex flex-column text-foreground-2 flex-shrink-0"
      >
        <simple-pie-chart v-if="!item?.icon && item?.percent >= 0" :value="item.percent" :color="item.color" class="mb-2" />
        <img v-if="item?.icon" :src="item.icon" alt="ref icon" style="height: 57px !important; width: 57px !important;">
        <div v-if="!item?.icon && item?.percent < 0 " style="margin-bottom: 50px;"></div>

        <h6 class="mb-1 w700" style="--fs: 12px">{{ item.name }}</h6>
        <span class="w500" style="font-size: 12px;">{{ item.value }}</span>
      </v-card>
    </section>

    <section v-if="currentTab == 2" class="d-flex py-1 px-1 mx-n1 mt-2" style="overflow: auto; gap: 16px;">
      <v-card
        v-for="(item, i) in indicatorsEngorde" :key="i"
        width="158"
        class="py-2 px-3 d-flex flex-column text-foreground-2 flex-shrink-0"
      >
        <simple-pie-chart v-if="!item?.icon && item?.percent >= 0" :value="item.percent" :color="item.color" class="mb-2" />
        <img v-if="item?.icon" :src="item.icon" alt="ref icon" style="height: 57px !important; width: 57px !important;">
        <div v-if="!item?.icon && item?.percent < 0 " style="margin-bottom: 50px;"></div>

        <h6 class="mb-1 w700" style="--fs: 12px">{{ item.name }}</h6>
        <span class="w500" style="font-size: 12px;">{{ item.value }}</span>
      </v-card>
    </section>

    <v-divider class="my-4" />

    <h5 class="text-primary w600" style="--fs: 1.375em">Accesos rapidos</h5>

    <aside class="d-flex flex-column flex-md-row mb-7" style="gap: 16px;">
      <section class="d-flex py-1 px-1 mx-n1" style="overflow: auto; gap: 16px;">
        <v-card
          v-for="(item, i) in quickAccess" :key="i"
          width="189"
          height="71"
          class="d-flex align-center px-3 py-2 flex-shrink-0"
          :style="`border-top: 8px solid ${item.color}; gap: 10px;`"
          @click="item.action"
        >
          <img :src="item.icon" alt="ref icon">

          <h6 class="mb-0 w700 text-center" style="--fs: 12px">{{ item.name }}</h6>
        </v-card>
      </section>

      <div class="d-flex align-center ml-auto" style="gap: 16px;">
        <v-divider vertical length="50" class="my-auto" style="opacity: 1;" />

        <!--<v-card
          width="11.8125em"
          height="71"
          class="d-flex flex-center px-3 py-2 flex-shrink-0"
        >
          <h6 class="mb-0 w700 text-center" style="--fs: 12px">Ver roles</h6>
        </v-card>-->

        <v-card
          width="11.8125em"
          height="71"
          class="d-flex flex-center px-3 py-2 flex-shrink-0"
          to="/create-roles"
        >
          <h6 class="mb-0 w700 text-center" style="--fs: 12px">Ver roles</h6>
        </v-card>
      </div>
    </aside>

    <v-data-table
      :headers="headers"
      :items="users"
      :loading="loadingUsers"
      hide-default-footer
      class="py-3 px-4"
    >
      <template #top>
        <h6 class="text-primary w600 mb-6" style="--fs: 15px">Usuarios activos</h6>

        <aside class="d-flex mb-4" style="gap: 30px">
          <v-text-field
            v-model="searchUsers"
            variant="solo"
            label="Buscar"
            placeholder="Por usuario, nombre, apellido, cedula o correo"
            persistent-placeholder
            hide-details
            clearable="true"
            clear-icon="mdi-close-circle"
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
        <v-btn size="25" max-height="25" variant="text" icon elevation="0" class="text-foreground" style="border-radius: 100%;" :to="{ name: 'EditarUser', query: { userId: item.id }}">
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
    </v-data-table>
  </div>
</template>

<script setup>
import '@/assets/styles/pages/home.scss'
import agricultureIcon from '@/assets/sources/icons/agriculture.svg'
import eggIcon from '@/assets/sources/icons/egg.svg'
import henIcon from '@/assets/sources/icons/hen.svg'
import syringeIcon from '@/assets/sources/icons/syringe.svg'
import assetsIcons from '@/assets/sources/icons/';
import Iconss from '@/assets/sources/icons/'
import ApiLiderPollo from '@/repository/api-lider-pollo'
import { onBeforeMount, ref } from 'vue';
import { useToast } from "vue-toastification";
import AuthApi from '@/repository/auth_api'
import router from '@/router'

const
toast = useToast(),
currentTab = ref(0),
userName = ref(""),
tabs = [ 'Cria', 'Producción', 'Engorde'],
indicatorsCrias = ref([]),
indicatorsProduccion = ref([]),
indicatorsEngorde = ref([]),
/*indicators = [
  {
    name: "Mortalidad Lote",
    percent: null,
    value: 125,
    color: "secondary-lighten"
  },
  {
    name: "Mortalidad Lote",
    percent: 80,
    value: 125,
    color: "tertiary-darken"
  },
  {
    name: "Mortalidad Lote",
    percent: 80,
    value: 125,
    color: "primary-darken"
  },
  {
    name: "Mortalidad Lote",
    percent: 80,
    value: 125,
    color: "tertiary"
  },
  {
    name: "Mortalidad Lote",
    percent: 80,
    value: 125,
    color: "primary"
  },
  {
    name: "Mortalidad Lote",
    percent: 80,
    value: 125,
    color: "secondary"
  },
],*/
quickAccess = [
  {
    icon: syringeIcon,
    name: "KPI - Reproductora Etapa Cría",
    color: "rgb(var(--v-theme-tertiary))",
    action: () => router.push({ name: "KpiBreedingBirdsPhase" }),
  },
  {
    icon: agricultureIcon,
    name: "KPI -Reproductora Etapa Producción",
    color: "rgb(var(--v-theme-tertiary-darken))",
    action: () => router.push({ name: "KpiProductionBirdsPhase" }),
  },
  {
    icon: eggIcon,
    name: "KPI - Incubadora",
    color: "rgb(var(--v-theme-secondary-lighten))",
    action: () => router.push({ name: "KpiIncubator" }),
  },
  {
    icon: henIcon,
    name: "KPI - Pollo de Engorde",
    color: "rgb(var(--v-theme-primary))",
    action: () => router.push({ name: "KpiFatteningBirdsPhase" }),
  },
],
headers = [
  { title: "Nombre", key: "name", align: "center" },
  { title: "Apellido", key: "lastname", align: "center" },
  { title: "Correo", key: "email", align: "center" },
  { title: "Usuario", key: "nickname", align: "center" },
  { title: "Rol", key: "role", align: "center" },
  { title: "Activo", key: "block", align: "center" },
  { title: "Acciones", key: "actions", align: "center", sortable: false },
],
loadingUsers = ref(false),
users = ref([]),
searchUsers = ref(null),
limitItemsPerPage = 10;

onBeforeMount(() => {
  const dataToken = AuthApi.dataToken();
  userName.value = dataToken.nombre;

  getData();
  usersList();
})

async function getData() {
  function mapIndicators(response) {
    const indicators = [];
    response.indicadores.forEach((item) => {
      indicators.push({
        name: item.desc,
        value: item.value,
        percent: null,
        color: null,
        icon: assetsIcons[item.icon]
      })
    })

    response.graficos.forEach((item) => {
      indicators.push({
        name: item.desc,
        value: item.porcentaje,
        percent: Number(item.porcentaje),
        color: item.color
      })
    })

    return indicators;
  }

  await ApiLiderPollo.granjas.getKpiHome(ApiLiderPollo.enums.EtapaGranjaEnum.CRIA).then(response => {
    const indicators = mapIndicators(response);
    indicatorsCrias.value = indicators;
  }).catch(error => {
    toast.error(`Error api granjas.getKpiHome etapa 'CRIA': ${error}`);
    console.log(error)
  });

  await ApiLiderPollo.granjas.getKpiHome(ApiLiderPollo.enums.EtapaGranjaEnum.PRODUCCION).then(response => {
    const indicators = mapIndicators(response);
    indicatorsProduccion.value = indicators;
  }).catch(error => {
    toast.error(`Error api granjas.getKpiHome etapa 'PRODUCCION': ${error}`);
    console.log(error)
  });

  await ApiLiderPollo.granjas.getKpiHome(ApiLiderPollo.enums.EtapaGranjaEnum.ENGORDE).then(response => {
    const indicators = mapIndicators(response);
    indicatorsEngorde.value = indicators;
  }).catch(error => {
    toast.error(`Error api granjas.getKpiHome etapa 'ENGORDE': ${error}`);
    console.log(error)
  });
}



async function callSearchUsers(val) {
  await usersList(0, val);
}

async function changeStatusUser(userName, id, isActive) {
  try {
    await ApiLiderPollo.users.updateUser({id, isActive});
    toast.success(`Se cambio con exito el estatus del usuario "${userName}" a "${isActive ? "Activo" : "Inactivo"}"`);
  } catch (error) {
    console.log(error)
    toast.error(`Error api users.updateUsers: ${error}`);
  }
}

async function clearMac(userName, userId) {
  try {
    await ApiLiderPollo.users.clearMac(userId);
    toast.success(`Se limpio con exito la mac del usuario "${userName}"`);
  } catch (error) {
    console.log(error)
    toast.error(`Error api users.clearMac: ${error}`);
  }
}

async function usersList(index = 0, search = "") {
  try {
    const limit = limitItemsPerPage;

    loadingUsers.value = true;
    const response = await ApiLiderPollo.users.getUsers({ limit, index, search });

    users.value =  response[0].map((item) => ({
      id: item.id,
      name: item.nombre,
      lastname: item.apellido,
      email: item.email,
      nickname: item.user_name,
      role: item?.user_role_id?.nombre || "",
      block: item.is_active
    }))
    loadingUsers.value = false;
  } catch (error) {
    loadingUsers.value = false;
    toast.error(`Error api users.getUsers: ${error}`);
    console.log(error)
  }
}
</script>
