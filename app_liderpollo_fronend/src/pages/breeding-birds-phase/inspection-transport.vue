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


    <inspection-transport :etapa="etapa" />

  </div>
</template>

<script setup>
import '@/assets/styles/pages/reproduction-breeding-phase/inspection-transport.scss'
import { filteringInputformatter } from '@/plugins/functions';
import moment from 'moment';
import ApiLiderPollo from '@/repository/api-sap-avicola'
import { onBeforeMount, ref, watch } from 'vue';
import { useToast } from "vue-toastification";
import { EtapaGranjaEnum } from '@/repository/api-sap-avicola/enums';
import InspectionTransport from '@/components/birds-exit/inspection-transport.vue';


const
etapa = ApiLiderPollo.enums.EtapaGranjaEnum.CRIA,
idStylePage = "inspection-transport",
pageTitle = "Inspección transporte",
pageSubtitle = "Inspección transporte cría",
toast = useToast()

function handleIntegration() {
  // Implementa la lógica de integración aquí
}
</script>
