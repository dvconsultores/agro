<template>
  <Navbar :title="pageTitle" :sub-title="pageSubtitle" class="mb-4" />
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

    <food-records v-if="currentTab == 0" :etapa="etapa" />
    <weight-records v-if="currentTab == 1" :etapa="etapa" />
    <mortality-records v-if="currentTab == 2" :etapa="etapa" />
    <vaccination-records v-if="currentTab == 3" :etapa="etapa" />

  </div>
</template>

<script setup>
import '@/assets/styles/pages/process-birds/process-birds.scss'
import { filteringInputformatter } from '@/plugins/functions';
import moment from 'moment';
import ApiLiderPollo from '@/repository/api-lider-pollo'
import { onBeforeMount, ref, watch } from 'vue';
import { useToast } from "vue-toastification";
import { EtapaGranjaEnum } from '@/repository/api-lider-pollo/enums';
import FoodRecords from '@/components/process-birds/food-records.vue';
import WeightRecords from '@/components/process-birds/weight-records.vue';
import MortalityRecords from '@/components/process-birds/mortality-records.vue';
import VaccinationRecords from '@/components/process-birds/vaccination-records.vue';


const
etapa = ApiLiderPollo.enums.EtapaGranjaEnum.CRIA,
idStylePage = "process-birds",
pageTitle = "Proceso Cría",
pageSubtitle = "Proceso aves de cría",
toast = useToast(),
currentTab = ref(0),
tabs = ["Alimento", "Pesaje", "Mortalidad", "Vacunación"]

function handleIntegration() {
  // Implementa la lógica de integración aquí
}
</script>
