<template>
  <v-app id="layout">
    <v-main>
      <Drawer></Drawer>
      <router-view />
    </v-main>
  </v-app>
</template>

<script setup>
import '@/assets/styles/layouts/default-layout.scss'
import Drawer from '@/components/drawer.vue'
</script>
