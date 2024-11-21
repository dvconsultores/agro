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
        placeholder="Por usuario, granja"
        persistent-placeholder
        hide-details
        class="search"
        v-debounce:400="() => getItemsTabla({buscar: search})"
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
          @click="getItemById(selectedItem?.id)"
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
        :items="tablaItems"
        :loading="loadingTable"
        hide-default-footer
        item-value="id"
        @click:row="selectItem"
      >
        <template #item="{ item, index }">
          <tr :class="{'selected-row': selectedItem && selectedItem.id === item.id}" @click="selectItem(item)">
            <td v-for="(head, i) in headers" :key="i">
              <template v-if="head?.key != 'actions' ">
                {{ item[head.key] }}
              </template>
              <template v-else>
                <v-btn size="25" max-height="25" variant="text" icon elevation="0" class="text-foreground" style="border-radius: 100%;">
                  <v-icon icon="mdi-square-edit-outline" size="20" />
                </v-btn>
                <v-btn size="25" max-height="25" variant="text" icon elevation="0" class="text-foreground" style="border-radius: 100%;">
                  <v-icon icon="mdi-trash-can-outline" size="20" />
                </v-btn>
              </template>
            </td>
          </tr>
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

      <v-text-field
        v-model="itemDetails.estatus"
        variant="solo-filled"
        label="Estatus"
        readonly
        style="max-width: 200px; min-width: 150px"
      ></v-text-field>

      <section class="d-flex flex-wrap" style="column-gap: 8px; row-gap: 0;">
        <div class="d-flex" style="flex-basis: 1590px; gap: 8px;">
          <v-text-field
            v-model="itemDetails.id"
            variant="solo-filled"
            label="Id registro"
            readonly
            style="max-width: 200px; min-width: 150px"
          ></v-text-field>

          <v-text-field
            v-model="itemDetails.user"
            variant="solo-filled"
            label="Usuario"
            readonly
            style="flex-basis: 251px;"
          ></v-text-field>

          <v-text-field
            v-model="itemDetails.fechaRecepcion"
            variant="solo-filled"
            label="Fecha recepcion"
            readonly
            style="flex-basis: 251px;"
          ></v-text-field>

          <v-text-field
            v-model="itemDetails.fechaDespacho"
            variant="solo-filled"
            label="Fecha despacho"
            readonly
            style="flex-basis: 251px;"
          ></v-text-field>
        </div>
      </section>


      <section class="d-flex flex-wrap" style="column-gap: 8px; row-gap: 0;">
        <div class="d-flex" style="flex-basis: 1590px; gap: 8px;">
          <v-text-field
            v-model="itemDetails.ordenCompra"
            variant="solo-filled"
            label="Orden compra"
            readonly
            style="max-width: 200px; min-width: 150px"
          ></v-text-field>

          <v-text-field
            v-model="itemDetails.proveedor"
            variant="solo-filled"
            label="Proveedor"
            readonly
            style="flex-basis: 251px;"
          ></v-text-field>

          <v-text-field
            v-model="itemDetails.raza"
            variant="solo-filled"
            label="Raza Ave"
            readonly
            style="flex-basis: 251px;"
          ></v-text-field>
        </div>
      </section>


      <section class="d-flex flex-wrap" style="column-gap: 8px; row-gap: 0;">
        <v-text-field
          v-model="itemDetails.granja"
          variant="solo-filled"
          label="Granja"
          readonly
          style="flex-basis: 890px;"
        ></v-text-field>


        <div class="d-flex" style="flex-basis: 1590px; gap: 8px;">
          <v-text-field
            v-model="itemDetails.cantHembras"
            variant="solo-filled"
            label="Cant. Hembras"
            readonly
            style="flex-basis: 251px;"
          ></v-text-field>

          <v-text-field
            v-model="itemDetails.cantMachos"
            variant="solo-filled"
            label="Cant. Macos"
            readonly
            style="flex-basis: 251px;"
          ></v-text-field>
        </div>


        <div class="d-flex" style="flex-basis: 1590px; gap: 8px;">
          <v-text-field
            v-model="itemDetails.pesoReportado"
            variant="solo-filled"
            label="Peso Prom. Reportado"
            readonly
            style="flex-basis: 251px;"
          ></v-text-field>

          <v-text-field
            v-model="itemDetails.pesoRecepcion"
            variant="solo-filled"
            label="Peso Prom. Recepción"
            readonly
            style="flex-basis: 251px;"
          ></v-text-field>
        </div>



        <div class="d-flex" style="flex-basis: 1590px; gap: 8px;">
          <v-text-field
            v-model="itemDetails.disponibles"
            variant="solo-filled"
            label="Aves disponibles"
            readonly
            style="flex-basis: 251px;"
          ></v-text-field>

          <v-text-field
            v-model="itemDetails.mortalidad"
            variant="solo-filled"
            label="Moratlidad"
            readonly
            style="flex-basis: 251px;"
          ></v-text-field>
        </div>



        <h6 class="text-primary w600 mb-6">Detalle galpones</h6>

        <v-text-field
            v-model="itemDetails.sheds.length"
            variant="solo-filled"
            label="Nº de Galpones ocupados"
            readonly
            style="flex-basis: 100%;"
          ></v-text-field>

        <aside class="d-flex flex-wrap mb-7" style="flex-basis: 100%; column-gap: 8px;">
          <v-card
            v-for="(item, i) in itemDetails.sheds" :key="i"
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
              v-model="item.cantHembras"
              variant="solo-filled"
              label="Cant. Hembras"
              readonly
              style="flex-basis: 250px;"
            ></v-text-field>

            <v-text-field
              v-model="item.cantMachos"
              variant="solo-filled"
              label="Cant. Machos"
              readonly
              style="flex-basis: 250px;"
            ></v-text-field>

            <v-text-field
              v-model="item.disponibles"
              variant="solo-filled"
              label="Aves disponibles"
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
import '@/assets/styles/pages/reproduction-breeding-phase/birds-reception.scss'
import ApiLiderPollo from '@/repository/api-lider-pollo'
import { onBeforeMount, ref, watch } from 'vue';
import { useToast } from "vue-toastification";
import { EtapaGranjaEnum } from '../../repository/api-sap-avicola/enums';
import { filteringInputformatter } from '@/plugins/functions';


const
idPage = "birds-reception",
etapa = ApiLiderPollo.enums.EtapaGranjaEnum.CRIA,
etapaTitle = "Reproductora Etapa Cría",
etapaSubtitle = "Recepción y Distribución de Aves",
toast = useToast(),
currentTab = ref(0),
showTable = ref(true),
loadingRegister = ref(false),
headers = [
  { title: "Id Recepcion", key: "id", align: "center" },
  { title: "Lote", key: "lote", align: "center" },
  { title: "Id Orden", key: "idOrden", align: "center" },
  { title: "Orden compra", key: "ordenCompra", align: "center" },
  { title: "Proveedor", key: "proveedor", align: "center" },
  { title: "Estatus", key: "estatus", align: "center" },
  { title: "Usuario Creación", key: "user", align: "center" },
  { title: "Fecha recepcion", key: "fechaRecepcion", align: "center" },
  { title: "Fecha despacho", key: "fechaDespacho", align: "center" },
  { title: "Granja", key: "farm", align: "center" },
  { title: "Raza aves", key: "raza", align: "center" },
  { title: "Cant. Galpones ocupados", key: "shedCant", align: "center" },
  { title: "Cant. Hembras", key: "cantHembras", align: "center" },
  { title: "Cant. Machos", key: "cantMachos", align: "center" },
  { title: "Peso reportado", key: "pesoReportado", align: "center" },
  { title: "Peso recepcion", key: "pesoRecepcion", align: "center" },
  { title: "Aves disponibles", key: "disponibles", align: "center" },
  { title: "Mortalidad", key: "mortalidad", align: "center" },
  //{ title: "Acciones", key: "actions", align: "center", sortable: false },
],
tablaItems = ref([]),
search = ref(null),
pageCount = ref(0),
itemsPerPage = ref(15),
page = ref(1),
loadingTable = ref(false),
selectedItem = ref(null),
itemDetails = ref({
  id: 0,
  user: "",
  fechaRecepcion: "",
  fechaDespacho: "",
  ordenCompra: "",
  proveedor: "",
  raza: "",
  cantHembras: "",
  cantMachos: "",
  pesoReportado: "",
  pesoRecepcion: "",
  disponibles: "",
  mortalidad: "",
  granja: "",
  estatus: "",
  sheds: [],
});


onBeforeMount(() => {
  getItemsTabla();
  // getItemById(2);
})

watch(page, (newVal, oldVal) => {
  const indexPage = (newVal - 1) * Number(itemsPerPage.value);
  getItemsTabla({index: indexPage, buscar: search.value});
});

function selectItem(item) {
  selectedItem.value = item;
}

async function getItemById(id) {
  try {
    if(!selectedItem.value?.id) {
      toast.warning('Seleccione un registro para ver los detalles');
      return
    };

    loadingRegister.value = true;

    const response = await ApiLiderPollo.crias.getRecepcionById(id)

    itemDetails.value = {
      id: response.id,
      user: `${response.user_creacion.user_name} - ${response.user_creacion.nombre} ${response.user_creacion.apellido}`,
      fechaRecepcion: new Date(response.fecha_recepcion).toLocaleDateString(),
      fechaDespacho: new Date(response.fecha_despacho).toLocaleDateString(),
      ordenCompra: response.orden_id.orden_compra,
      proveedor: `${response.proveedor_id.id_sap} - ${response.proveedor_id.name}`,
      raza: `${response.raza_ave_id.id_sap} - ${response.raza_ave_id.name}`,
      cantHembras: response.cant_hembras,
      cantMachos: response.cant_machos,
      pesoReportado: response.peso_reportado,
      pesoRecepcion: response.peso_promedio_granja,
      disponibles: response.disponibles,
      mortalidad: response.mortalidad,
      granja: `${response.granja_id.id_sap} - ${response.granja_id.name}`,
      estatus: response.status,
      sheds: response.distribucion.map((item) => ({
        shed: item.galpon_id.galpon,
        cantHembras: item.cant_hembras,
        cantMachos: item.cant_machos,
        disponibles: item.disponibles
      }))
    }

    showTable.value = !showTable.value;

    loadingRegister.value = false;

  } catch(error) {
    loadingRegister.value = false;
    toast.error(`Error api granjas.getRecepcionById etapa '${etapa}': ${error}`);
    console.log(error)
  };
}

async function getItemsTabla(data = {
    index: undefined,
    buscar: undefined
  }) {

  try {
    data.limit = itemsPerPage.value;
    data.buscar = data?.buscar == '' ? undefined : data?.buscar;

    loadingTable.value = true;

    const response = await ApiLiderPollo.crias.getRecepciones(data)

    pageCount.value = Math.ceil(Number(response[1]) / Number(itemsPerPage.value));
    
    tablaItems.value = response[0].map((item) => ({
      id: item.recepcion_id,
      lote: item.recepcion_lote,
      idOrden: item.orden_id,
      ordenCompra: item.orden_orden_compra,
      proveedor: `${item.proveedor_id_sap} - ${item.proveedor_name}`,
      estatus: item.recepcion_status,
      user: `${item.user_user_name} - ${item.user_nombre} ${item.user_apellido}`,
      fechaRecepcion: new Date(item.recepcion_fecha_recepcion).toLocaleDateString(),
      fechaDespacho: new Date(item.recepcion_fecha_despacho).toLocaleDateString(),
      farm: `${item.granja_id_sap} - ${item.granja_name}`,
      raza: `${item.razaAve_id_sap} - ${item.razaAve_name}`,
      shedCant: item.cant_galpones,
      cantHembras: item.recepcion_cant_hembras,
      cantMachos: item.recepcion_cant_machos,
      pesoReportado: item.recepcion_peso_reportado,
      pesoRecepcion: item.recepcion_peso_promedio_granja,
      disponibles: item.recepcion_disponibles,
      mortalidad: item.recepcion_mortalidad,
    }));

    loadingTable.value = false;

  } catch(error) {
    loadingTable.value = false;
    toast.error(`Error api granjas.getItemsTabla etapa '${etapa}': ${error}`);
    console.log(error)
  };
}

</script>

<style scoped>
.selected-row {
  background-color: #e0f7fa !important; /* Color azul claro */
}
</style>
