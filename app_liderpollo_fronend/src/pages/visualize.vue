<template>
  <Navbar title="Visualizar" sub-title="Granjas" class="mb-4" />

  <div id="visualize">
    <h5 class="text-primary w600 mb-6" style="--fs: 22px">Datos de la granja</h5>

    <aside class="d-flex flex-wrap mb-6" style="gap: 8px">
      <v-text-field
        variant="solo"
        label="Código"
        placeholder="123456789"
        persistent-placeholder
        hide-details
        class="search"
        style="flex-basis: 430px;"
      >
        <template #append-inner>
          <v-divider vertical class="mr-2" inset style="opacity: 1;" />
          <img src="@/assets/sources/icons/search_people.svg" alt="search people icon">
        </template>
      </v-text-field>

      <v-text-field
        variant="solo"
        label="Descripción"
        placeholder="Descripción"
        persistent-placeholder
        hide-details
        class="mr-3"
        style="flex-basis: 430px;"
      ></v-text-field>

      <v-btn width="250" variant="outlined" min-height="54" color="primary" elevation="1" class="btn">
        Imprimir
      </v-btn>
    </aside>

    <v-data-table
      :headers="headers"
      :items="users"
      hide-default-footer
    ></v-data-table>

    <v-pagination
      :length="22"
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
  </div>
</template>

<script setup>
import '@/assets/styles/pages/visualize.scss'

const
headers = [
  { title: "Id Registro", key: "id", align: "center" },
  { title: "Datos ingreso Usuario", key: "data", align: "center" },
  { title: "Fecha registro", key: "date", align: "center" },
  { title: "Hora registro", key: "time", align: "center" },
  { title: "Granja", key: "farm", align: "center" },
  { title: "Galpón", key: "shed", align: "center" },
  { title: "Capacidad", key: "capacity", align: "center" },
  { title: "Cant. Aves alojadas", key: "birds", align: "center" },
  { title: "Condición cama Concha", key: "condition", align: "center" },
  { title: "Cantidad de Equipos", key: "devices", align: "center" },
],
users = [
  {
    id: "12345678",
    data: "mcy78",
    date: "17/08/24",
    time: "11:03 am",
    farm: "Granja 8",
    shed: "6",
    capacity: "850",
    birds: "850",
    condition: "Lorem ipsum",
    devices: "1"
  },
  {
    id: "12345678",
    data: "mcy78",
    date: "17/08/24",
    time: "11:03 am",
    farm: "Granja 8",
    shed: "6",
    capacity: "850",
    birds: "850",
    condition: "Lorem ipsum",
    devices: "1"
  },
  {
    id: "12345678",
    data: "mcy78",
    date: "17/08/24",
    time: "11:03 am",
    farm: "Granja 8",
    shed: "6",
    capacity: "850",
    birds: "850",
    condition: "Lorem ipsum",
    devices: "1"
  },
]
</script>
