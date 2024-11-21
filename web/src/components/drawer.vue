<template>
  <v-navigation-drawer
    id="drawer"
    v-model="store.state.drawer"
    :permanent="!mobile"
    :touchless="!mobile"
    width="250"
    class="pt-8 pb-12 px-3"
  >
    <aside>
      <div v-if="mobile" class="flex-jend mb-2" style="gap: 10px">
        <v-btn variant="text" icon elevation="0" size="30" max-height="30" class="text-white" style="border-radius: 100%;">
          <v-icon size="20" icon="mdi-bell-badge-outline" />
        </v-btn>
      </div>


      <div class="flex-acenter mb-8 px-3 py-2 text-white relative" style="height: 40px;">
        <v-avatar image="@/assets/sources/logos/sap_avicola_variant.png" alt="logo" style="position: absolute;" />

        <h6 class="mb-0 flex-grow-1 text-center" style="--fs: 14px;">{{ APP_NAMES.capitalize }}</h6>
      </div>

      <!--<v-text-field
        variant="solo"
        placeholder="Buscar"
        class="search"
      >
        <template #append-inner>
          <v-divider vertical class="text-white mr-2" inset style="opacity: 1;" />
          <v-icon class="text-white" icon="mdi-magnify" />
        </template>
      </v-text-field>-->
    </aside>

    <section class="content">
      <v-list
        nav
        v-for="(child, i) in data.filter((item) => item.isActive)" :key="i"
        :height="child.height"
        class="px-0 py-3"
      >

        <template v-for="(item, i2) in child.children.filter((item) => item.isActive)" :key="i2">
          <v-list-item
            v-if="!item.children"
            min-height="36"
            class="text-white px-4"
            :class="{ 'bg-primary': route.name.includes(item.to) }"
            @click="item.onClick ? item.onClick() : router.push({ name: item.to })"
          >
            <img :src="item.icon" :alt="`${item.name} icon`" class="mr-2" style="width: 20px;" >
            {{ item.name }}
          </v-list-item>

          <v-expansion-panels
            v-else
            bg-color="transparent"
            elevation="0"
          >
            <v-expansion-panel class="pa-0 text-white">
              <template #title>
                <img :src="item.icon" :alt="`${item.name} icon`" class="mr-2" style="width: 20px;" >
                {{ item.name }}
              </template>

              <template #text>
                <v-list-item
                  v-for="(children, i2) in item.children.filter((item) => item.isActive)" :key="i2"
                  min-height="36"
                  class="text-white px-1 mr-1"
                  :class="{ 'bg-primary': route.name.includes(children.to) }"
                  @click="children.onClick ? children.onClick() : router.push({ name: children.to })"
                >
                  <img :src="children.icon" :alt="`${children.name} icon`" class="mr-2" style="width: 20px;" >
                  {{ children.name }}
                </v-list-item>
              </template>
            </v-expansion-panel>
          </v-expansion-panels>
        </template>

      </v-list>
    </section>

    <v-divider thickness="2" class="text-white mt-auto mb-6" />
    <v-card class="d-flex align-center bg-primary-variant px-3 py-2" style="gap: 10px;">
      <v-img-load
        :src="avatar"
        sizes="36"
        rounded="200"
        class="flex-grow-0"
      />

      <div>
        <h6 class="mb-0 w700" style="--fs: 14px;">{{ userName }}</h6>
        <span style="font-size: 14px;">Administrador</span>
      </div>
    </v-card>
  </v-navigation-drawer>
</template>

<script setup>
import { useStore } from 'vuex';
import { useRoute, useRouter } from 'vue-router'
import { useDisplay } from 'vuetify/lib/framework.mjs'
import avatar from '@/assets/sources/images/avatar.png'
import AuthApi from '@/repository/auth_api'
import { onBeforeMount, ref, watch  } from 'vue';
import contractIcon from '@/assets/sources/drawer/contract.svg'
import editDocumentIcon from '@/assets/sources/drawer/edit_document.svg'
import homeIcon from '@/assets/sources/drawer/home.svg'
import listAltIcon from '@/assets/sources/drawer/list_alt.svg'
import manufacturingIcon from '@/assets/sources/drawer/manufacturing.svg'
import supervisorAccountIcon from '@/assets/sources/drawer/supervisor_account.svg'
import logoutIcon from '@/assets/sources/drawer/logout.svg'
import henIcon from '@/assets/sources/drawer/hen.svg'
import houseSidingIcon from '@/assets/sources/drawer/house_siding.svg'
import localShippingIcon from '@/assets/sources/drawer/local_shipping.svg'
import palletIcon from '@/assets/sources/drawer/pallet.svg'
import syringeIcon from '@/assets/sources/drawer/syringe.svg'
import agricultureIcon from '@/assets/sources/drawer/agriculture.svg'
import eggIcon from '@/assets/sources/drawer/egg.svg'
import eggsIcon from '@/assets/sources/drawer/eggs.svg'
import incubatorEggIcon from '@/assets/sources/drawer/incubator_egg.svg'
import editSquareIcon from '@/assets/sources/drawer/edit_square.svg'
import babyChickIcon from '@/assets/sources/drawer/baby_chick.svg'
import { useStorage } from 'vue3-storage-secure';
import ApiLiderPollo from '@/repository/api-lider-pollo';
import { useToast } from "vue-toastification";
import { APP_NAMES } from "@/plugins/dictionary.js";

const
  router = useRouter(),
  route = useRoute(),
  toast = useToast(),
  storage = useStorage(),
  store = useStore(),
  { mobile } = useDisplay(),
  userName = ref(''),

data = ref([]);

onBeforeMount(() => {
  const dataToken = AuthApi.dataToken();
  userName.value = dataToken.nombre;
  getRolUser();
})

/*watch(route, async () => {
  const dataToken = AuthApi.dataToken();
  userName.value = dataToken.nombre;
  getRolUser();
});*/

async function getRolUser() {
  try {
    const menu = [
      {
        height: null,
        isActive: true,
        children: [
          {
            icon: homeIcon,
            name: "Panel Principal",
            to: "Home",
            isActive: true,
          },
        ],
      },
      {
        height: null,
        isActive: false,
        children: [
          {
            icon: listAltIcon,
            name: "Etapa Cría",
            isActive: false,
            children: [
              {
                icon: houseSidingIcon,
                name: "Inspección de Granja",
                to: "FarmInspectionBreeding",
                isActive: false,
              },
              {
                icon: localShippingIcon,
                name: "Distribución de Aves",
                to: "BreedingReception",
                isActive: false,
              },
              {
                icon: syringeIcon,
                name: "Proceso de Cría",
                to: "ProcessBreedingBirds",
                isActive: false,
              },
              {
                icon: henIcon,
                name: "Salida de Aves",
                to: "ExitBreedingBirds",
                isActive: false,
              },
              {
                icon: palletIcon,
                name: "Insp. de Transporte",
                to: "InspectionTransportBreeding",
                isActive: false,
              },
            ]
          },
          {
            icon: listAltIcon,
            name: "Etapa Producción",
            isActive: false,
            children: [
              {
                icon: houseSidingIcon,
                name: "Inspección de Granja",
                to: "FarmInspectionProduction",
                isActive: false,
              },
              {
                icon: localShippingIcon,
                name: "Distribución de Aves",
                to: "ProductionReception",
                isActive: false,
              },
              {
                icon: syringeIcon,
                name: "Proceso Producción",
                to: "ProcessProductionBirds",
                isActive: false,
              },
              {
                icon: henIcon,
                name: "Salidas de Aves",
                to: "ExitProductionBirds",
                isActive: false,
              },
              {
                icon: palletIcon,
                name: "Insp. de Transporte",
                to: "InspectionTransportProduction",
                isActive: false,
              },
              {
                icon: eggIcon,
                name: "Salidas de huevos",
                to: "ExitProductionEggs",
                isActive: false,
              },
              {
                icon: palletIcon,
                name: "Insp. Transporte huevos",
                to: "InspectionTransportProductionEggs",
                isActive: false,
              },
            ]
          },
          {
            icon: listAltIcon,
            name: "Incubadora",
            isActive: false,
            children: [
            {
                icon: houseSidingIcon,
                name: "Inspecciones incubadora",
                to: "IncubatorInspection",
                isActive: false,
              },
              {
                icon: localShippingIcon,
                name: "Recepciones huevos",
                to: "EggsReception",
                isActive: false,
              },
              {
                icon: eggsIcon,
                name: "Clasificaciones huevos",
                to: "EggsClassification",
                isActive: false,
              },
              {
                icon: incubatorEggIcon,
                name: "Incubaciones",
                to: "EggsIncubation",
                isActive: false,
              },
              {
                icon: editSquareIcon,
                name: "Registros de nacimientos",
                to: "BirthRegistration",
                isActive: false,
              },
              {
                icon: babyChickIcon,
                name: "Salidas de pollitos BB",
                to: "ChicksExit",
                isActive: false,
              },
            ]
          },
          {
            icon: listAltIcon,
            name: "Etapa Engorde",
            children: [
              {
                icon: houseSidingIcon,
                name: "Inspección de Granja",
                to: "FarmInspectionFattening",
                isActive: false,
              },
              {
                icon: localShippingIcon,
                name: "Distribución de Aves",
                to: "FatteningReception",
                isActive: false,
              },
              {
                icon: syringeIcon,
                name: "Proceso Producción",
                to: "ProcessFatteningBirds",
                isActive: false,
              },
              {
                icon: henIcon,
                name: "Salida de Aves",
                to: "ExitFatteningBirds",
                isActive: false,
              },
              {
                icon: palletIcon,
                name: "Insp. de Transporte",
                to: "InspectionTransportFattening",
                isActive: false,
              },
            ]
          },
          {
            icon: listAltIcon,
            name: "KPI - Indicadores",
            isActive: false,
            children: [
              {
                icon: syringeIcon,
                name: "Reproductora Etapa de Cría",
                to: "KpiBreedingBirdsPhase",
                isActive: false,
              },
              {
                icon: agricultureIcon,
                name: "Reproductora Etapa Producción",
                to: "KpiProductionBirdsPhase",
                isActive: false,
              },
              {
                icon: eggIcon,
                name: "Incubadora",
                to: "KpiIncubator",
                isActive: false,
              },
              {
                icon: henIcon,
                name: "Proceso de Engorde",
                to: "KpiFatteningBirdsPhase",
                isActive: false,
              },
            ]
          },
        ],
      },
      {
        height: "207px",
        isActive: false,
        children: [
          /*{
            icon: contractIcon,
            name: "Visualizar",
            to: "Visualize",
          },*/
          {
            icon: editDocumentIcon,
            name: "Maestros",
            to: "Maestros",
            isActive: false,
          },
          {
            icon: supervisorAccountIcon,
            name: "Usuarios",
            to: "Users",
            isActive: false,
          },
          {
            icon: manufacturingIcon,
            name: "Roles",
            to: "CreateRoles",
            isActive: false,
          },
          /*{
            icon: manufacturingIcon,
            name: "Configuración",
          },*/
        ],
      },
      {
        height: "150px",
        isActive: true,
        children: [
          {
            icon: logoutIcon,
            name: "Cerrar Sesión",
            onClick: AuthApi.logOut,
            isActive: true,
          },
        ]
      },
    ]


    // habilitando opciones menu
    for (const item of AuthApi.getRoles()) {
      switch (item.modulo) {
        case 'cria': {
          menu[1].isActive = true;
          menu[1].children[0].isActive = true;
          for(const child of item.subModulos) {
            switch (child) {
              case 'inspeccion_granjas_cria': menu[1].children[0].children[0].isActive = true;
              break;
              case 'distribucion_aves_cria': menu[1].children[0].children[1].isActive = true;
              break;
              case 'registro_alimento_cria': menu[1].children[0].children[2].isActive = true;
              break;
              case 'registro_pesaje_cria': menu[1].children[0].children[2].isActive = true;
              break;
              case 'registro_mortalidad_cria': menu[1].children[0].children[2].isActive = true;
              break;
              case 'registro_vacunas_cria': menu[1].children[0].children[2].isActive = true;
              break;
              case 'salida_aves_cria': menu[1].children[0].children[3].isActive = true;
              break;
              case 'inspeccion_transporte_aves_cria': menu[1].children[0].children[4].isActive = true;
              break;
            }
          }
        }
          break;
        case 'produccion': {
          menu[1].isActive = true;
          menu[1].children[1].isActive = true;
          for(const child of item.subModulos) {
            switch (child) {
              case 'inspeccion_granjas_produccion': menu[1].children[1].children[0].isActive = true;
              break;
              case 'distribucion_aves_produccion': menu[1].children[1].children[1].isActive = true;
              break;
              case 'registro_alimento_produccion': menu[1].children[1].children[2].isActive = true;
              break;
              case 'registro_pesaje_produccion': menu[1].children[1].children[2].isActive = true;
              break;
              case 'registro_mortalidad_produccion': menu[1].children[1].children[2].isActive = true;
              break;
              case 'registro_vacunas_produccion': menu[1].children[1].children[2].isActive = true;
              break;
              case 'registro_recoleccion_huevos_produccion': menu[1].children[1].children[2].isActive = true;
              break;
              case 'salida_aves_produccion': menu[1].children[1].children[3].isActive = true;
              break;
              case 'inspeccion_transporte_aves_produccion': menu[1].children[1].children[4].isActive = true;
              break;
              case 'salida_huevos_produccion': menu[1].children[1].children[5].isActive = true;
              break;
              case 'inspeccion_transporte_huevos_produccion': menu[1].children[1].children[6].isActive = true;
              break;
            }
          }
        }
          break;
        case 'incubadora': {
          menu[1].isActive = true;
          menu[1].children[2].isActive = true;
          for(const child of item.subModulos) {
            switch (child) {
              case 'inspeccion_incubadora': menu[1].children[2].children[0].isActive = true;
              break;
              case 'recepcion_huevos_incubadora': menu[1].children[2].children[1].isActive = true;
              break;
              case 'clasificacion_huevos_incubadora': menu[1].children[2].children[2].isActive = true;
              break;
              case 'incubacion_huevos_incubadora': menu[1].children[2].children[3].isActive = true;
              break;
              case 'registro_nacimiento_incubadora': menu[1].children[2].children[4].isActive = true;
              break;
              case 'salida_pollitos_incubadora': menu[1].children[2].children[5].isActive = true;
              break;
            }
          }
        }
          break;
        case 'engorde': {
          menu[1].isActive = true;
          menu[1].children[3].isActive = true;
          for(const child of item.subModulos) {
            switch (child) {
              case 'inspeccion_granjas_engorde': menu[1].children[3].children[0].isActive = true;
              break;
              case 'distribucion_aves_engorde': menu[1].children[3].children[1].isActive = true;
              break;
              case 'registro_alimento_engorde': menu[1].children[3].children[2].isActive = true;
              break;
              case 'registro_pesaje_engorde': menu[1].children[3].children[2].isActive = true;
              break;
              case 'registro_mortalidad_engorde': menu[1].children[3].children[2].isActive = true;
              break;
              case 'registro_vacunas_engorde': menu[1].children[3].children[2].isActive = true;
              break;
              case 'salida_aves_engorde': menu[1].children[3].children[3].isActive = true;
              break;
              case 'inspeccion_transporte_aves_engorde': menu[1].children[3].children[4].isActive = true;
              break;
            }
          }
        }
          break;
        case 'configuracion': {
          menu[2].isActive = true;
          menu[2].children[0].isActive = true;
          menu[2].children[2].isActive = true;
        }
          break;
        case 'usuarios': {
          menu[2].isActive = true;
          menu[2].children[1].isActive = true;
        }
          break;
        case 'kpis': {
          menu[1].isActive = true;
          menu[1].children[4].isActive = true;

          for(const child of item.subModulos) {
            switch (child) {
              case 'kpis_cria': menu[1].children[4].children[0].isActive = true;
              break;
              case 'kpis_produccion': menu[1].children[4].children[1].isActive = true;
              break;
              case 'kpis_engorde': menu[1].children[4].children[3].isActive = true;;
              break;
              case 'kpis_incubadora': menu[1].children[4].children[2].isActive = true;
              break;
            }
          }
        }
          break;
      }
    }


    data.value = menu;

  } catch(error) {
    console.log(`Error al cargar el rol del usuario: ${error}`)
    toast.error(error)
  }
}
</script>

<style lang="scss">
@use "@/assets/styles/utils/variables.scss" as vars;

#drawer {
  background: vars.$primary-lighten !important;

  .v-navigation-drawer__content {
    display: flex;
    flex-direction: column;
    overflow: hidden;
  }

  .search {
    .v-field {
      background-color: transparent;
      box-shadow: none;
      border: 1px solid #fff;
    }
    .v-field__field {
      height: 38px;
    }

    input {
      color: #fff;
      min-height: 100%;
      caret-color: #fff;
    }
  }

  .content { overflow: auto !important }

  .v-list {
    position: relative;

    &:not(:last-child)::after {
      content: "";
      height: 1px;
      width: 100%;
      background-color: #fff;
      position: absolute;
      bottom: 0;
    }

    &-item__content {
      display: flex;
      align-items: center;
      font-size: 15px;
    }

    .v-expansion-panel {
      &-title {
        padding: 4px 16px;
        height: 36px;
        font-size: 15px;
      }

      &-text__wrapper { padding: 0 }

      &-text {
        --margin: 20px;
        --left: 12px;
        --circle-size: 8px;

        padding-left: calc(var(--left) * 2);
        margin-bottom: 8px;
        position: relative;

        &::after {
          content: "";
          position: absolute;
          top: var(--margin);
          bottom: var(--margin);
          left: var(--left);
          width: 1px;
          background-color: #fff;
        }

        &__wrapper {
          &::before {
            content: "";
            position: absolute;
            top: var(--margin);
            bottom: var(--margin);
            left: calc(var(--left) / 2 + var(--circle-size) / 2 - 1px);
            width: var(--circle-size);
            height: var(--circle-size);
            border-radius: 100%;
            background-color: #fff;
          }

          &::after {
            content: "";
            position: absolute;
            bottom: var(--margin);
            bottom: var(--margin);
            left: calc(var(--left) / 2 + var(--circle-size) / 2 - 1px);
            width: var(--circle-size);
            height: var(--circle-size);
            border-radius: 100%;
            background-color: #fff;
          }
        }
      }
    }
  }
}
</style>
