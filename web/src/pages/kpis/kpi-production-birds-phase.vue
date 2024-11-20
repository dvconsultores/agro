<template>
  <Navbar :title="etapaTitle" :sub-title="etapaSubtitle" class="mb-4" />

  <div :id="idStylePage">
    <aside :id="`${idStylePage}-controls`">
      <v-autocomplete
        v-model="farm"
        :items="farms"
        item-title="name"
        item-value="id"
        variant="solo"
        label="Granja"
        placeholder="Selecione granja"
        persistent-placeholder
        menu-icon="mdi-chevron-down"
        hide-details
        @update:model-value="getLotesByFarmId(farm)"
      ></v-autocomplete>

      <v-autocomplete
        v-model="lote"
        :items="lotes"
        item-title="lote"
        item-value="id"
        variant="solo"
        label="Lote"
        placeholder="Seleccione lote"
        persistent-placeholder
        menu-icon="mdi-chevron-down"
        hide-details
        @update:model-value="getSemanasLote(lote)"
      ></v-autocomplete>

      <v-autocomplete
        v-model="week"
        :items="weeks"
        item-title="week"
        item-value="id"
        variant="solo"
        label="Semana"
        placeholder="Semana"
        persistent-placeholder
        menu-icon="mdi-chevron-down"
        hide-details
        @update:model-value="getKpisLote(lote, week)"
      ></v-autocomplete>
    </aside>

    <v-divider color="#78767A" class="my-5" style="opacity: 1" />

    <kpis-list v-if="farm && week" :data="data" />
  </div>
</template>

<script setup>
import '@/assets/styles/pages/kpis/kpi-production-birds-phase.scss'
import KpisList from '@/components/kpis-list.vue'
import ApiLiderPollo from '@/repository/api-sap-avicola'
import { onBeforeMount, ref, watch } from 'vue';
import { useToast } from "vue-toastification";

const
etapa = ApiLiderPollo.enums.EtapaGranjaEnum.PRODUCCION,
etapaTitle = "Reproductora Etapa Producción",
etapaSubtitle = "Indicadores",
idStylePage = "kpi-production-birds-phase",

toast = useToast(),
farms = ref([]),
farm = ref(),
lotes = ref([]),
lote = ref(),
weeks = ref([]),
week = ref(),
loading = ref(false),
data = ref([])


onBeforeMount(() => {
  getData();
})


async function getData() {
  await ApiLiderPollo.granjas.getGranjas({ status: "ACTIVO" }).then((response) => {
    farms.value = response.map((item) => {return {id: item.id, name: item.name } } );
  }).catch((error) => {
    toast.error(`Error al obtener las granjas: ${error}`);
  });
}


async function getLotesByFarmId(farmId) {
  await ApiLiderPollo.granjas.getLotesRecepcion(farmId, etapa).then((response) => {
    lotes.value = response.map((item) => {return {id: item.id, lote: item.lote } } );
  }).catch((error) => {
    toast.error(`Error al obtener los lotes: ${error}`);
  });
}


async function getSemanasLote(recepcionId) {
  await ApiLiderPollo.granjas.getSemanasLote(recepcionId, etapa).then((response) => {
    weeks.value = response.map((item) => {return {id: item.weekNumber, week: item.weekDes } } );
  }).catch((error) => {
    toast.error(`Error al obtener las semanas: ${error}`);
  });
}

async function getKpisLote(recepcionId, semana) {
  loading.value = true;
  await ApiLiderPollo.granjas.getKpisLote(recepcionId, semana, etapa).then((response) => {

    data.value = response.map((item) => {
      return {
        name: item.nombre,
        value: item.value,
        percentage: item.porcentaje,
        color: item.color
      }
    });
    loading.value = false;

  }).catch((error) => {
    loading.value = false;
    toast.error(`Error al obtener los kpi: ${error}`);
  });
}

</script>
