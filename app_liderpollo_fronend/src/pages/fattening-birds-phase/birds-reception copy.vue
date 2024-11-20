<template>
  <Navbar title="Reproductora Etapa Cría" sub-title="Recepción y Distribución de Aves" class="mb-4" />

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

  <div id="birds-reception">
    <h5 class="text-primary w600 mb-6" style="--fs: 22px">Registros</h5>

    <aside class="d-flex mb-4" style="gap: 24px">
      <v-text-field
        variant="solo"
        label="Buscar"
        placeholder="Por usuario, granja, id del registro, hora o fecha"
        persistent-placeholder
        hide-details
        class="search"
      >
        <template #append-inner>
          <v-divider vertical class="mr-2" inset style="opacity: 1;" />
          <img src="@/assets/sources/icons/search_people.svg" alt="search people icon">
        </template>
      </v-text-field>

      <v-btn variant="outlined" min-height="54" color="primary" elevation="1" class="btn">
        Imprimir
      </v-btn>
    </aside>

    <v-card class="px-4 py-6">
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
import '@/assets/styles/pages/reproduction-breeding-phase/birds-reception.scss'
import { filteringInputformatter } from '@/plugins/functions';
import moment from 'moment';
import { ref } from 'vue'

const
menuDatePicker = ref(false),
datePickerValue = ref(null),
menuDatePicker2 = ref(false),
datePickerValue2 = ref(null),
shedAmount = ref(null),
modalSuccess = ref(),
modalConfirm = ref()


function handleIntegration() {
  modalConfirm.value.closeModal()
  modalSuccess.value.showModal()
}
</script>
