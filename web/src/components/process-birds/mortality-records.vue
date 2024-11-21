<template>
  <custom-modal
    ref="modalSuccess"
    title="¡Exito en la Integración!"
    title-class="text-primary w600"
    title-center
    text="La integración con SAP ha sido exitosa"
    text-center
    hide-actions
  />

  <custom-modal
    ref="modalConfirm"
    title-class="text-primary w600"
    title-center
    cancel-button-text="No, Cancelar"
    confirm-button-text="Si, Integrar"
    @confirm="handleIntegration"
  >
    <template #title>
      ¿Deseas realizar la<br>Integración?
    </template>
  </custom-modal>

  <div :id="idStylePage">
    <h5 class="text-primary w600 mb-6 mt-3" style="--fs: 22px">Registros Mortalidad</h5>

    <aside class="d-flex mb-4" style="gap: 24px">
      <v-text-field
        v-if="showTable"
        v-model="search"
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

      <!--<div class="d-flex" style="gap: 12px;">
        <v-btn
          v-if="showTable"
          variant="outlined"
          min-height="54"
          color="primary"
          elevation="1"
          class="btn"
          :loading="loadingRegister"
          @click="getDetails(selectedItem?.id)"
        >
          <img src="@/assets/sources/icons/checkbook.svg" alt="list icon" class="mr-2">
          Ver registro
        </v-btn>
        <v-btn v-else variant="outlined" min-height="54" color="primary" elevation="1" class="btn" @click="showTable = !showTable">
          <img src="@/assets/sources/icons/list_alt.svg" alt="list icon" class="mr-2">
          Ver tabla
        </v-btn>

        <--<v-btn variant="outlined" min-height="54" color="primary" elevation="1" class="btn">
          Imprimir
        </v-btn>->
      </div>-->
    </aside>

    <template v-if="showTable">
      <v-data-table
        :headers="headers"
        :items="itemsTable"
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
      <h6 class="text-primary w600 mb-6">Registro</h6>

      <section class="d-flex flex-wrap" style="column-gap: 8px; row-gap: 0;">
        <v-text-field
          variant="solo"
          label="Orden de compra"
          placeholder="Lorem 123456"
          persistent-placeholder
          style="flex-basis: 214px;"
        ></v-text-field>

        <v-select
          variant="solo"
          label="Proveedor"
          placeholder="Selecciona"
          persistent-placeholder
          :items="['Proveedor 1', 'Proveedor 2', 'Proveedor 3']"
          menu-icon="mdi-chevron-down"
          style="flex-basis: 294px;"
        ></v-select>

        <v-select
          variant="solo"
          label="Raza del Ave"
          placeholder="Raza del Ave 4"
          persistent-placeholder
          :items="['Raza del Ave 1', 'Raza del Ave 2', 'Raza del Ave 3', 'Raza del Ave 4']"
          menu-icon="mdi-chevron-down"
          style="flex-basis: 294px;"
        ></v-select>

        <v-text-field
          variant="solo"
          label="Cant. Aves Hembras"
          placeholder="450"
          persistent-placeholder
          style="flex-basis: 148px;"
        ></v-text-field>

        <v-text-field
          variant="solo"
          label="Cant. Aves Macho"
          placeholder="450"
          persistent-placeholder
          style="flex-basis: 148px;"
        ></v-text-field>

        <v-text-field
          variant="solo"
          label="Peso reportado del proveedor al entregar"
          placeholder="380"
          persistent-placeholder
          style="flex-basis: 285px;"
        ></v-text-field>

        <v-text-field
          variant="solo"
          label="Peso promedio Ave al llegar a Granja"
          placeholder="2.5"
          persistent-placeholder
          style="flex-basis: 409px;"
        ></v-text-field>

        <v-menu
          v-model="menuDatePicker"
          :close-on-content-click="false"
          content-class="limit-overlay"
          location="top center"
        >
          <v-date-picker
            @click:cancel="menuDatePicker = false"
            @update:model-value="(value) => {
              datePickerValue = moment(value).format('DD/MM/YYYY')
              menuDatePicker = false
            }"
            locale="es"
          ></v-date-picker>

          <template #activator="{ props }">
            <v-text-field
              v-model="datePickerValue"
              variant="solo"
              label="Fecha Despacho del Ave"
              placeholder="17/07/2024"
              persistent-placeholder
              style="flex-basis: 200px;"
              v-bind="props"
            >
              <template #append-inner>
                <v-divider vertical class="mr-1" inset style="opacity: 1;" />
                <v-sheet color="#F4F4F4" class="d-flex flex-center pa-1" style="border-radius: 100%;">
                  <img src="@/assets/sources/icons/calendar-today.svg" alt="calendar-today icon">
                </v-sheet>
              </template>
            </v-text-field>
          </template>
        </v-menu>

        <v-menu
          v-model="menuDatePicker2"
          :close-on-content-click="false"
          content-class="limit-overlay"
          location="top center"
        >
          <v-date-picker
            @click:cancel="menuDatePicker2 = false"
            @update:model-value="(value) => {
              datePickerValue2 = moment(value).format('DD/MM/YYYY')
              menuDatePicker2 = false
            }"
            locale="es"
          ></v-date-picker>

          <template #activator="{ props }">
            <v-text-field
              v-model="datePickerValue2"
              variant="solo"
              label="Fecha Recepción del Ave"
              placeholder="17/07/2024"
              persistent-placeholder
              style="flex-basis: 200px;"
              v-bind="props"
            >
              <template #append-inner>
                <v-divider vertical class="mr-1" inset style="opacity: 1;" />
                <v-sheet color="#F4F4F4" class="d-flex flex-center pa-1" style="border-radius: 100%;">
                  <img src="@/assets/sources/icons/calendar-today.svg" alt="calendar-today icon">
                </v-sheet>
              </template>
            </v-text-field>
          </template>
        </v-menu>

        <v-text-field
          variant="solo"
          label="Asignación codigo de Lote"
          placeholder="Lorem 456"
          persistent-placeholder
          style="flex-basis: 100%;"
        ></v-text-field>
      </section>

      <h6 class="text-primary w600 mb-6">Distribución por Galpón</h6>

      <v-text-field
        v-model="shedAmount"
        variant="solo"
        label="Cant. de Galpones"
        placeholder="2"
        persistent-placeholder
        style="flex-basis: 100%"
        @input="(event) => shedAmount = filteringInputformatter(event, /^\d+$/)"
      ></v-text-field>

      <aside class="d-flex flex-wrap mb-7" style="flex-basis: 100%; gap: 8px;">
        <v-card
          v-for="(_, i) in Array.from({ length: shedAmount })" :key="i"
          color="#f6f6f6"
          elevation="0"
          class="d-flex flex-wrap flex-grow-1 px-3 pt-8 pb-0"
          style="border: 1px solid rgb(var(--v-theme-label)); column-gap: 8px;"
        >
          <v-select
            variant="solo-filled"
            label="Galpón"
            placeholder="Selecciona"
            persistent-placeholder
            :items="['Galpón 1', 'Galpón 2', 'Galpón 3']"
            menu-icon="mdi-chevron-down"
            style="flex-basis: 205px;"
          ></v-select>

          <v-text-field
            variant="solo-filled"
            label="Cant. Machos"
            placeholder="485"
            persistent-placeholder
            style="flex-basis: 205px;"
          ></v-text-field>

          <v-text-field
            variant="solo-filled"
            label="Cant. Hembras"
            placeholder="325"
            persistent-placeholder
            style="flex-basis: 205px;"
          ></v-text-field>
        </v-card>
      </aside>
    </v-card>

    <v-btn
      class="btn mt-auto ml-auto"
      @click="modalConfirm.showModal()"
    >Integración SAP</v-btn>
  </div>
</template>

<script setup>
import '@/assets/styles/pages/process-birds/mortality-records.scss'
import { filteringInputformatter } from '@/plugins/functions';
import moment from 'moment';
import ApiLiderPollo from '@/repository/api-lider-pollo'
import { defineProps, onBeforeMount, ref, watch } from 'vue';
import { useToast } from "vue-toastification";
import { EtapaGranjaEnum } from '@/repository/api-sap-avicola/enums';

const props = defineProps({
  etapa: {
    type: String,
    required: true
  }
});
const idStylePage = "mortality-records",
//pageTitle = "Reproductora Etapa Cría",
//pageSubtitle = "Recepción y Distribución de Aves",
toast = useToast(),
currentTab = ref(0),
showTable = ref(true),
menuDatePicker = ref(false),
datePickerValue = ref(null),
menuDatePicker2 = ref(false),
datePickerValue2 = ref(null),
shedAmount = ref(null),
modalSuccess = ref(),
modalConfirm = ref(),
loadingRegister = ref(false),
headers = props.etapa == "ENGORDE" ? [
{ title: "Id Registro", key: "id", align: "center" },
  { title: "Lote", key: "lote", align: "center" },
  { title: "Id recepción", key: "idRecepcion", align: "center" },
  { title: "Granja", key: "granja", align: "center" },
  { title: "Galpon", key: "galpon", align: "center" },
  { title: "Cantidad aves", key: "cantidad", align: "center" },
  { title: "Fecha", key: "fecha", align: "center" },
  { title: "Fecha registro", key: "fechaRegistro", align: "center" },
  { title: "User creación", key: "user", align: "center" },
  //{ title: "Acciones", key: "actions", align: "center", sortable: false },
] : [
  { title: "Id Registro", key: "id", align: "center" },
  { title: "Lote", key: "lote", align: "center" },
  { title: "Id recepción", key: "idRecepcion", align: "center" },
  { title: "Granja", key: "granja", align: "center" },
  { title: "Galpon", key: "galpon", align: "center" },
  { title: "Total aves", key: "cantidad", align: "center" },
  { title: "Cant. hembras", key: "cantHembras", align: "center" },
  { title: "Cant. machos", key: "cantMachos", align: "center" },
  { title: "Fecha", key: "fecha", align: "center" },
  { title: "Fecha registro", key: "fechaRegistro", align: "center" },
  { title: "User creación", key: "user", align: "center" },
  //{ title: "Acciones", key: "actions", align: "center", sortable: false },
],
itemsTable = ref([]),
search = ref(null),
pageCount = ref(0),
itemsPerPage = ref(30),
page = ref(1),
loadingTable = ref(false),
selectedItem = ref(null)


onBeforeMount(() => {
  getItemsTabla();
})

watch(page, (newVal, oldVal) => {
  const indexPage = (newVal - 1) * Number(itemsPerPage.value);
  getItemsTabla({index: indexPage, buscar: search.value});
});

function selectItem(item) {
  selectedItem.value = item;
}

async function getDetails(id) {
  try {
    if(!selectedItem.value?.id) {
      toast.warning('Seleccione un registro para ver los detalles');
      return
    };

    loadingRegister.value = true;

    //const response = await ApiLiderPollo.granjas.getinspeccionGranja(id)


    showTable.value = !showTable.value;

    loadingRegister.value = false;

  } catch(error) {
    loadingRegister.value = false;
    toast.error(`Error api granjas.getinspeccionGranja etapa '${props?.etapa}': ${error}`);
    console.log(error)
  };
}

async function getItemsTabla(data = {
    index: undefined,
    buscar: undefined
  }) {

  try {
    data.etapa = props?.etapa;
    data.limit = itemsPerPage.value;
    data.buscar = data?.buscar == '' ? undefined : data?.buscar;

    loadingTable.value = true;

    const response = await ApiLiderPollo.granjas.getResgistrosMortalidad(data)

    pageCount.value = Math.ceil(Number(response[1]) / Number(itemsPerPage.value));

    itemsTable.value = response[0].map((item) => ({
      id: item.id,
      lote: item.lote,
      idRecepcion: item.recepcion_id?.id,
      granja: item.granja_id?.name,
      galpon: item.galpon_distribucion_id?.galpon_id?.galpon,
      cantidad: item.cantidad_muertas,
      cantHembras: item?.cant_hembras,
      cantMachos: item?.cant_machos,
      fecha: moment(item.fecha).format('DD/MM/YYYY'),
      fechaRegistro: moment(item.creation_date).format('DD/MM/YYYY HH:mm'),
      user: `${item.user_creacion?.user_name}`
    }));

    loadingTable.value = false;

  } catch(error) {
    loadingTable.value = false;
    toast.error(`Error el ejecutar getItemsTabla etapa '${props?.etapa}': ${error}`);
    console.log(error)
  };
}

function handleIntegration() {
  modalConfirm.value.closeModal()
  modalSuccess.value.showModal()
}
</script>

<style scoped>
.selected-row {
  background-color: #e0f7fa !important; /* Color azul claro */
}
</style>
