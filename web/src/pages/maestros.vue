<template>
  <Navbar title="Maestros" sub-title="Administración de maestros" class="mb-4" />

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
    @confirm="handleIntegration"
  >
    <template #title>
      ¿Deseas guardar?
    </template>
  </custom-modal>

  <div id="maestros">

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

    <v-card v-if="currentTab == 0" class="px-4 py-6" elevation="0">
      <h5 class="text-primary w600 mb-6" style="--fs: 22px">Registro de lotes</h5>

      <v-card class="px-4 py-6">
        <v-form v-model="validFormLotes">
          <h6 class="text-primary w600 mb-6">Registro</h6>

          <section class="d-flex flex-wrap" style="column-gap: 8px; row-gap: 0;">
            <v-text-field
              v-model="dataLotes.lote"
              variant="solo"
              label="Lote"
              placeholder=""
              persistent-placeholder
              style="flex-basis: 328px;"
              :rules="[globalRules.required]"
            ></v-text-field>

            <v-text-field
              v-model="dataLotes.idSap"
              variant="solo"
              label="Id SAP"
              placeholder=""
              persistent-placeholder
              style="flex-basis: 328px;"
              :rules="[globalRules.required]"
            ></v-text-field>
          </section>

          <v-btn
            width="170"
            class="btn mt-auto ml-auto"
            :disabled="!validFormLotes"
            :loading="isLoading"
            @click="() => { validForm = validFormLotes; modalConfirm.showModal();}"
          >Guardar</v-btn>
        </v-form>
      </v-card>

      <v-divider class="my-4" />

      <v-card class="px-4 py-6">
        <h5 class="text-primary w600 mb-6" style="--fs: 22px">Buscar</h5>

        <aside class="d-flex mb-4" style="gap: 24px">
          <v-text-field
            v-model="searchLotes"
            variant="solo"
            label="Buscar"
            placeholder="Por lote, id SAP"
            persistent-placeholder
            hide-details
            clearable
            class="search"
            v-debounce:400="() => callSearchLotes(searchLotes)"
          >
            <template #append-inner>
              <v-divider vertical class="mr-2" inset style="opacity: 1;" />
              <img src="@/assets/sources/icons/search_people.svg" alt="search people icon">
            </template>
          </v-text-field>
        </aside>

        <v-data-table
          :headers="headersLotes"
          :items="lotes"
          :loading="loadingTable"
          hide-default-footer
        >
          <!--<template #item.status="{ item }">
            <div class="w-100 d-flex flex-center">
              <v-switch
                v-model:model-value="item.status"
                width="52"
                hide-details
              /> activo
            </div>
          </template>-->

          <!--<template #item.actions="{ item }">
            <v-btn size="25" max-height="25" variant="text" icon elevation="0" class="text-foreground" style="border-radius: 100%;" :to="{ name: 'UpdateRol', query: { loteId: item.id }}">
              <v-icon icon="mdi-square-edit-outline" size="20" />
            </v-btn>
          </template>-->

          <template #bottom="{  }">
            <div class="d-flex flex-center px-3 py-4">
              Desplegando {{ pageLotes }}-{{ itemsPerPageLotes }} de {{ pageCountLotes }} resultados

              <v-pagination
                v-model="pageLotes"
                :length="pageCountLotes"
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
      </v-card>

    </v-card>

    <v-card v-if="currentTab == 1" class="px-4 py-6" elevation="0">
      <h5 class="text-primary w600 mb-6" style="--fs: 22px">Registro de lotes</h5>

      <v-card class="px-4 py-6">
        <v-form v-model="validFormLotesEngorde">
          <h6 class="text-primary w600 mb-6">Registro</h6>

          <section class="d-flex flex-wrap" style="column-gap: 8px; row-gap: 0;">
            <v-text-field
              v-model="dataLotesEngorde.lote"
              variant="solo"
              label="Lote"
              placeholder=""
              persistent-placeholder
              style="flex-basis: 328px;"
              :rules="[globalRules.required]"
            ></v-text-field>

            <v-text-field
              v-model="dataLotesEngorde.idSap"
              variant="solo"
              label="Id SAP"
              placeholder=""
              persistent-placeholder
              style="flex-basis: 328px;"
              :rules="[globalRules.required]"
            ></v-text-field>
          </section>

          <v-btn
            width="170"
            class="btn mt-auto ml-auto"
            :disabled="!validFormLotesEngorde"
            :loading="isLoading"
            @click="() => { validForm = validFormLotesEngorde; modalConfirm.showModal();}"
          >Guardar</v-btn>
        </v-form>
      </v-card>

      <v-divider class="my-4" />

      <v-card class="px-4 py-6">
        <h5 class="text-primary w600 mb-6" style="--fs: 22px">Buscar</h5>

        <aside class="d-flex mb-4" style="gap: 24px">
          <v-text-field
            v-model="searchLotesEngorde"
            variant="solo"
            label="Buscar"
            placeholder="Por lote, id SAP"
            persistent-placeholder
            hide-details
            clearable
            class="search"
            v-debounce:400="() => callSearchLotesEngorde(searchLotesEngorde)"
          >
            <template #append-inner>
              <v-divider vertical class="mr-2" inset style="opacity: 1;" />
              <img src="@/assets/sources/icons/search_people.svg" alt="search people icon">
            </template>
          </v-text-field>
        </aside>

        <v-data-table
          :headers="headersLotes"
          :items="lotesEngorde"
          :loading="loadingTableEngorde"
          hide-default-footer
        >
          <!--<template #item.status="{ item }">
            <div class="w-100 d-flex flex-center">
              <v-switch
                v-model:model-value="item.status"
                width="52"
                hide-details
              /> activo
            </div>
          </template>-->

          <!--<template #item.actions="{ item }">
            <v-btn size="25" max-height="25" variant="text" icon elevation="0" class="text-foreground" style="border-radius: 100%;" :to="{ name: 'UpdateRol', query: { loteId: item.id }}">
              <v-icon icon="mdi-square-edit-outline" size="20" />
            </v-btn>
          </template>-->

          <template #bottom="{  }">
            <div class="d-flex flex-center px-3 py-4">
              Desplegando {{ pageLotesEngorde }}-{{ itemsPerPageLotesEngorde }} de {{ pageCountLotesEngorde }} resultados

              <v-pagination
                v-model="pageLotesEngorde"
                :length="pageCountLotesEngorde"
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
      </v-card>

    </v-card>
  </div>
</template>

<script setup>
import '@/assets/styles/pages/maestros.scss'
import { onBeforeMount, ref, watch } from 'vue';
import { useToast } from "vue-toastification";
import ApiLiderPollo from '@/repository/api-lider-pollo'
import variables from '@/mixins/variables';


const
toast = useToast(),
{ globalRules } = variables,
modalSuccess = ref(),
modalConfirm = ref(),
currentTab = ref(0),
isLoading = ref(false),
validForm = ref(false),
tabs = ['Lotes cria', 'lotes engorde'],
headersLotes = [
  { title: "Lote", key: "lote", align: "center" },
  { title: "Id SAP", key: "idSap", align: "center" },
  { title: "Estatus", key: "status", align: "center" },
  // { title: "Acciones", key: "actions", align: "center", sortable: false },
],
lotes = ref([]),
loadingTable = ref(false),
searchLotes = ref(null),
pageCountLotes = ref(10),
itemsPerPageLotes = ref(5),
pageLotes = ref(1),
validFormLotes = ref(false),
dataLotes = ref({
  lote: undefined,
  idSap: undefined,
}),
lotesEngorde = ref([]),
loadingTableEngorde = ref(false),
searchLotesEngorde = ref(null),
pageCountLotesEngorde = ref(10),
itemsPerPageLotesEngorde = ref(5),
pageLotesEngorde = ref(1),
validFormLotesEngorde = ref(false),
dataLotesEngorde = ref({
  lote: undefined,
  idSap: undefined,
});


onBeforeMount(() => {
  getMaestroLotes();
  getMaestroLotesEngorde();
})

watch(pageLotes, (newVal, oldVal) => {
  const indexPage = (newVal - 1) * Number(itemsPerPageLotes.value);
  getMaestroLotes(undefined, indexPage, searchLotes.value);
});

watch(pageLotesEngorde, (newVal, oldVal) => {
  const indexPage = (newVal - 1) * Number(itemsPerPageLotesEngorde.value);
  getMaestroLotesEngorde(undefined, indexPage, searchLotesEngorde.value);
});

async function callSearchLotes(val) {
  await getMaestroLotes(undefined, 0, val);
}

async function getMaestroLotes(limit = itemsPerPageLotes.value, index = 0, search = "") {
  try {
    loadingTable.value = true;
    const response = await ApiLiderPollo.crias.getMaestroLotes({ limit, index, search });
    pageCountLotes.value = Math.ceil(Number(response[1]) / Number(itemsPerPageLotes.value));

    lotes.value =  response[0].map((item) => ({
      id: item.id,
      lote: item.lote,
      idSap: item.id_sap,
      status: item.status,

    }))
    loadingTable.value = false;
  } catch (error) {
    loadingTable.value = false;
    console.log(error)
  }
}


async function callSearchLotesEngorde(val) {
  await getMaestroLotesEngorde(undefined, 0, val);
}

async function getMaestroLotesEngorde(limit = itemsPerPageLotes.value, index = 0, search = "") {
  try {
    loadingTableEngorde.value = true;
    const response = await ApiLiderPollo.engorde.getMaestroLotes({ limit, index, search });
    pageCountLotesEngorde.value = Math.ceil(Number(response[1]) / Number(itemsPerPageLotesEngorde.value));

    lotesEngorde.value =  response[0].map((item) => ({
      id: item.id,
      lote: item.lote,
      idSap: item.id_sap,
      status: item.status,

    }))
    loadingTableEngorde.value = false;
  } catch (error) {
    loadingTableEngorde.value = false;
    console.log(error)
  }
}

function handleIntegration(){
  switch (currentTab.value) {
    case 0: saveLote();
      break;
    case 1: saveLoteEngorde();
      break;

    default: return;

  }
}


async function saveLote() {
  if (isLoading.value || !validFormLotes.value) {
    modalConfirm.value.closeModal();
    return
  }

  isLoading.value = true;

  try {
    await ApiLiderPollo.crias.setMaestroLote(dataLotes.value);

    // blaqueando las variables
    dataLotes.value = {
      lote: undefined,
      idSap: undefined,
    };

    validForm.value = false;

    modalConfirm.value.closeModal();
    modalSuccess.value.showModal();

    await getMaestroLotes();
  } catch (error) {
    console.log(error)
    toast.error(error)
    modalConfirm.value.closeModal();
  }

  isLoading.value = false;
}

async function saveLoteEngorde() {
  if (isLoading.value || !validFormLotesEngorde.value) {
    modalConfirm.value.closeModal();
    return
  }

  isLoading.value = true;

  try {
    await ApiLiderPollo.engorde.setMaestroLote(dataLotesEngorde.value);

    // blaqueando las variables
    dataLotesEngorde.value = {
      lote: undefined,
      idSap: undefined,
    };

    validForm.value = false;

    modalConfirm.value.closeModal();
    modalSuccess.value.showModal();

    await getMaestroLotesEngorde();
  } catch (error) {
    console.log(error)
    toast.error(error)
    modalConfirm.value.closeModal();
  }

  isLoading.value = false;
}
</script>
