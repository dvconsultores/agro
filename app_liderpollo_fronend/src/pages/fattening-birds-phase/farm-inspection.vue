<template>
  <Navbar :title="etapaTitle" :sub-title="etapaSubtitle" class="mb-4" />

  <div :id="idPage">
    <h5 class="text-primary w600 mb-6" style="--fs: 22px">Registros</h5>

    <aside class="d-flex mb-4" style="gap: 24px">
      <v-text-field
        v-model="search"
        v-if="showTable"
        variant="solo"
        label="Buscar"
        placeholder="Por usuario y granja"
        persistent-placeholder
        hide-details
        class="search"
        v-debounce:400="() => getInspeccionesGranjas({buscar: search})"
      >
        <template #append-inner>
          <v-divider vertical class="mr-2" inset style="opacity: 1;" />
          <img src="@/assets/sources/icons/search_people.svg" alt="search people icon">
        </template>
      </v-text-field>

      <div class="d-flex" style="gap: 12px;">
        <v-btn
          v-if="showTable"
          variant="outlined"
          min-height="54"
          color="primary"
          elevation="1"
          class="btn"
          :loading="loadingRegister"
          @click="getIbspeccionGranjaById(selectedItem?.id)"
        >
          <img src="@/assets/sources/icons/checkbook.svg" alt="list icon" class="mr-2">
          Ver registro
        </v-btn>
        <v-btn v-else variant="outlined" min-height="54" color="primary" elevation="1" class="btn" @click="showTable = !showTable">
          <img src="@/assets/sources/icons/list_alt.svg" alt="list icon" class="mr-2">
          Ver tabla
        </v-btn>

        <!--<v-btn variant="outlined" min-height="54" color="primary" elevation="1" class="btn">
          Imprimir
        </v-btn>-->
      </div>
    </aside>

    <template v-if="showTable">
      <v-data-table
        :headers="headers"
        :items="inspections"
        :loading="loadingTable"
        hide-default-footer
        item-value="id"
        @click:row="selectItem"
      >
        <template #item="{ item, index }">
          <tr :class="{'selected-row': selectedItem && selectedItem.id === item.id}" @click="selectItem(item)">
            <td>{{ item.id }}</td>
            <td>{{ item.data }}</td>
            <td>{{ item.date }}</td>
            <td>{{ item.farm }}</td>
            <td>{{ item.farmSapId }}</td>
            <td>{{ item.shedCant }}</td>
            <td>{{ item.devices }}</td>
            <td>{{ item.condition }}</td>
            <td>{{ item.temp }}</td>
            <td>{{ item.humidity }}</td>
          </tr>
        </template>

        <template #item.actions="{ item }">
          <v-btn size="25" max-height="25" variant="text" icon elevation="0" class="text-foreground" style="border-radius: 100%;">
            <v-icon icon="mdi-square-edit-outline" size="20" />
          </v-btn>
          <v-btn size="25" max-height="25" variant="text" icon elevation="0" class="text-foreground" style="border-radius: 100%;">
            <v-icon icon="mdi-trash-can-outline" size="20" />
          </v-btn>
        </template>
      </v-data-table>

      <v-pagination
        v-model="page"
        :length="pageCount"
        total-visible="5"
        class="ml-auto mt-6"
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
    </template>

    <v-card v-else class="px-4 py-6">
      <h6 class="text-primary w600 mb-6">Datos del registro</h6>

      <section class="d-flex flex-wrap" style="column-gap: 8px; row-gap: 0;">
        <div class="d-flex" style="flex-basis: 1590px; gap: 8px;">
          <v-text-field
            v-model="inspectionDetails.id"
            variant="solo-filled"
            label="Id registro"
            readonly
            style="max-width: 200px; min-width: 150px"
          ></v-text-field>

          <v-text-field
            v-model="inspectionDetails.user"
            variant="solo-filled"
            label="Usuario"
            readonly
            style="flex-basis: 251px;"
          ></v-text-field>

          <v-text-field
            v-model="inspectionDetails.date"
            variant="solo-filled"
            label="Fecha ingreso registro"
            readonly
            style="flex-basis: 251px;"
          ></v-text-field>
        </div>
      </section>


      <section class="d-flex flex-wrap" style="column-gap: 8px; row-gap: 0;">
        <v-text-field
          v-model="inspectionDetails.farm"
          variant="solo-filled"
          label="Granja"
          readonly
          style="flex-basis: 890px;"
        ></v-text-field>

        <v-text-field
          v-model="inspectionDetails.bedCondition"
          variant="solo-filled"
          label="Condición Cama Concha de Arroz"
          readonly
          style="flex-basis: 100%;"
        ></v-text-field>

        <div class="d-flex" style="flex-basis: 1590px; gap: 8px;">
          <v-text-field
            v-model="inspectionDetails.temp"
            variant="solo-filled"
            label="Temperatura"
            readonly
            style="flex-basis: 100%;"
          ></v-text-field>

          <v-text-field
            v-model="inspectionDetails.humidity"
            variant="solo-filled"
            label="Humedad"
            readonly
            style="flex-basis: 100%;"
          ></v-text-field>
        </div>

        <h6 class="text-primary w600 mb-6">Detalle galpones</h6>

        <v-text-field
            v-model="inspectionDetails.sheds.length"
            variant="solo-filled"
            label="Nº de Galpones disponibles"
            readonly
            style="flex-basis: 100%;"
          ></v-text-field>

        <aside class="d-flex flex-wrap mb-7" style="flex-basis: 100%; column-gap: 8px;">
          <v-card
            v-for="(item, i) in inspectionDetails.sheds" :key="i"
            :for="item"
            color="#f6f6f6"
            elevation="0"
            class="d-flex flex-wrap flex-grow-1 px-3 pt-8 pb-0"
            style="border: 1px solid rgb(var(--v-theme-label)); column-gap: 8px;"
          >
            <v-text-field
              v-model="item.shed"
              variant="solo-filled"
              label="Galpón"
              readonly
              style="flex-basis: 250px;"
            ></v-text-field>

            <v-text-field
              v-model="item.capacity"
              variant="solo-filled"
              label="Capacidad"
              readonly
              style="flex-basis: 250px;"
            ></v-text-field>

            <v-text-field
              v-model="item.birds"
              variant="solo-filled"
              label="Cantidad de Aves alojadas"
              readonly
              style="flex-basis: 250px;"
            ></v-text-field>
          </v-card>
        </aside>



        <h6 class="text-primary w600 mb-6">Detalle Equipos</h6>

        <v-text-field
          v-model="inspectionDetails.devices.length"
          variant="solo-filled"
          label="Cantidad de equipos"
          readonly
          style="flex-basis: 100%;"
        ></v-text-field>

        <aside class="d-flex flex-wrap mb-7" style="flex-basis: 100%; column-gap: 8px;">
          <v-card
            v-for="(item, i) in inspectionDetails.devices" :key="i"
            :for="item"
            color="#f6f6f6"
            elevation="0"
            class="d-flex flex-wrap flex-grow-1 px-3 pt-8 pb-0"
            style="border: 1px solid rgb(var(--v-theme-label)); column-gap: 8px;"
          >
            <v-text-field
              v-model="item.device"
              variant="solo-filled"
              label="Equipo"
              readonly
              style="flex-basis: 250px;"
            ></v-text-field>

            <v-text-field
              v-model="item.capacity"
              variant="solo-filled"
              label="Capacidad"
              readonly
              style="flex-basis: 250px;"
            ></v-text-field>
          </v-card>
        </aside>

      </section>
    </v-card>
  </div>
</template>

<script setup>
import '@/assets/styles/pages/reproduction-breeding-phase/farm-inspection.scss'
import ApiLiderPollo from '@/repository/api-sap-avicola'
import { onBeforeMount, ref, watch } from 'vue';
import { useToast } from "vue-toastification";
import { EtapaGranjaEnum } from '../../repository/api-sap-avicola/enums';

const
idPage = "farm-inspection",
etapa = ApiLiderPollo.enums.EtapaGranjaEnum.ENGORDE,
etapaTitle = "Reproductora Etapa Engorde",
etapaSubtitle = "Inspección de Granjas",
toast = useToast(),
currentTab = ref(0),
showTable = ref(true),
loadingRegister = ref(false),
headers = [
  { title: "Id Registro", key: "id", align: "center" },
  { title: "Usuario Creación", key: "data", align: "center" },
  { title: "Fecha registro", key: "date", align: "center" },
  { title: "Granja", key: "farm", align: "center" },
  { title: "Id sap granja", key: "farmSapId", align: "center" },
  { title: "Cant. Galpones inspeccionados", key: "shedCant", align: "center" },
  { title: "Cant. de Equipos", key: "devices", align: "center" },
  { title: "Condición cama Concha", key: "condition", align: "center" },
  { title: "Temperatura", key: "temp", align: "center" },
  { title: "Humedad", key: "humidity", align: "center" },
  //{ title: "Acciones", key: "actions", align: "center", sortable: false },
],
inspections = ref([]),
search = ref(null),
pageCount = ref(0),
itemsPerPage = ref(15),
page = ref(1),
loadingTable = ref(false),
selectedItem = ref(null),
inspectionDetails = ref({
  id: 0,
  user: "",
  date: "",
  farm: "",
  bedCondition: "",
  temp: 0,
  humidity: 0,
  sheds: [],
  devices: []
});


onBeforeMount(() => {
  getInspeccionesGranjas();
  // getIbspeccionGranjaById(2);
})

watch(page, (newVal, oldVal) => {
  const indexPage = (newVal - 1) * Number(itemsPerPage.value);
  getInspeccionesGranjas({index: indexPage, buscar: search.value});
});

function selectItem(item) {
  selectedItem.value = item;
}

async function getIbspeccionGranjaById(id) {
  try {
    if(!selectedItem.value?.id) {
      toast.warning('Seleccione un registro para ver los detalles');
      return
    };

    loadingRegister.value = true;

    const response = await ApiLiderPollo.granjas.getinspeccionGranja(id)

    /*const response = {
        id: 2,
        galpones_disponibles: 2,
        temperatura: 12,
        humedad: 67,
        condicion_cama: "bien",
        etapa: "CRIA",
        creation_date: "2024-10-29T15:58:40.519Z",
        user_creation: {
            id: 3,
            user_name: "hrpm",
            nombre: "Hector",
            apellido: "Palencia"
        },
        granja_id: {
            id: 7,
            id_sap: "2501",
            name: "AVÍCOLA LA PAREDEÑA"
        },
        galpon_inspecciones: [
            {
                capacidad: 500,
                cant_aves: 500,
                galpon_id: {
                    id: 16252,
                    galpon: "Galpón 1"
                }
            },
            {
                capacidad: 200,
                cant_aves: 200,
                galpon_id: {
                    id: 8901,
                    galpon: "Galpón 1"
                }
            }
        ],
        equipo_inspecciones: [
            {
                id: 2,
                cantidad: 11,
                equipo_id: {
                    nombre: "Pala",
                    descripcion: "Pala de construcción",
                    status: "ACTIVO"
                }
            }
        ]
    }*/


    inspectionDetails.value = {
      id: response.id,
      user: `${response.user_creation.user_name} - ${response.user_creation.nombre} ${response.user_creation.apellido}`,
      date: new Date(response.creation_date).toLocaleDateString(),
      farm: `${response.granja_id.name} - ${response.granja_id.id_sap}`,
      bedCondition: response.condicion_cama,
      temp: response.temperatura,
      humidity: response.humedad,
      sheds: response?.galpon_inspecciones ? response.galpon_inspecciones.map((items) => ({
        shed: items.galpon_id.galpon,
        capacity: items.capacidad,
        birds: items.cant_aves,
      })) : [],
      devices: response?.equipo_inspecciones ? response.equipo_inspecciones.map((device) => ({
        device: device.equipo_id.nombre,
        capacity: device.cantidad,
      })) : [],
    };


    showTable.value = !showTable.value;

    loadingRegister.value = false;

  } catch(error) {
    loadingRegister.value = false;
    toast.error(`Error api granjas.getinspeccionGranja etapa '${etapa}': ${error}`);
    console.log(error)
  };
}

async function getInspeccionesGranjas(data = {
    index: undefined,
    buscar: undefined
  }) {

  try {
    data.etapa = etapa;
    data.limit = itemsPerPage.value;
    data.buscar = data?.buscar == '' ? undefined : data?.buscar;
    console.log(data)
    loadingTable.value = true;

    const response = await ApiLiderPollo.granjas.getInspeccionesGranjas(data)

    pageCount.value = Math.ceil(Number(response[1]) / Number(itemsPerPage.value));

    inspections.value = response[0].map(item => ({
      id: item.inspeccion_id,
      data: item.user_user_name,
      date: new Date(item.inspeccion_creation_date).toLocaleDateString(),
      farm: item.granja_name,
      farmSapId: item.granja_id_sap,
      shedCant: item.galpones_inspeccionados,
      condition: item.inspeccion_condicion_cama,
      devices: item.cantidad_equipos || 0,
      humidity: item.inspeccion_humedad,
      temp: item.inspeccion_temperatura,
    }));

    loadingTable.value = false;

  } catch(error) {
    loadingTable.value = false;
    toast.error(`Error api granjas.getInspeccionesGranjas etapa '${etapa}': ${error}`);
    console.log(error)
  };
}

</script>

<style scoped>
.selected-row {
  background-color: #e0f7fa !important; /* Color azul claro */
}
</style>
