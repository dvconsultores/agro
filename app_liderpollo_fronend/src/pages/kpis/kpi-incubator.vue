<template>
  <Navbar :title="etapaTitle" :sub-title="etapaSubtitle" class="mb-4" />

  <div :id="idStylePage">
    <aside :id="`${idStylePage}-controls`">
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
        @update:model-value="getKpisLote(week)"
      ></v-autocomplete>
    </aside>

    <v-divider color="#78767A" class="my-5" style="opacity: 1" />

    <kpis-list v-if="week" :data="data" />
  </div>
</template>

<script setup>
import '@/assets/styles/pages/kpis/kpi-incubator.scss'
import KpisList from '@/components/kpis-list.vue'
import ApiLiderPollo from '@/repository/api-sap-avicola'
import { onBeforeMount, ref, watch } from 'vue';
import { useToast } from "vue-toastification";

const
etapaTitle = "Incubadora",
etapaSubtitle = "Indicadores",
idStylePage = "kpi-incubator",

weeks = ref([]),
week = ref(),
loading = ref(false),
data = ref([
  /*{
    name: 'Tasa Eclosión',
    value: 'Bueno',
    percentage: 80,
    color: '#FF8B65'
  },
  {
    name: 'Tasa Fecundidad',
    value: 'Regular',
    percentage: 31,
    color: '#EFB8C8'
  },
  {
    name: 'Tasa Pollitos Sanos ',
    value: "Bueno",
    percentage: 39,
    color: '#99A5FF'
  },
  {
    name: 'Índice Rotura de Huevos',
    value: "Excelente",
    percentage: 100,
    color: '#F9E37D'
  },
  {
    name: 'Peso Promedio Pollitos',
    value: "98 gr",
    percentage: 31,
    color: '#F9E37D'
  },
  {
    name: 'Tasa Mortalidad en Incubadora',
    value: "Excelente",
    percentage: 2.6,
    color: '#99A5FF'
  },*/
])


onBeforeMount(() => {
  getData();
})


async function getData() {
  await ApiLiderPollo.incubadora.getSemanasIncubadora().then((response) => {
    weeks.value = response.map((item) => {return {id: item.weekNumber, week: item.weekDes } } );
  }).catch((error) => {
    toast.error(`Error al obtener las granjas: ${error}`);
  });
}


async function getKpisLote(semana) {
  loading.value = true;
  await ApiLiderPollo.incubadora.getKpisIncubadora(semana).then((response) => {
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
    toast.error(`Error al obtener los lotes: ${error}`);
  });
}

</script>
