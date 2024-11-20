<template>
  <nav id="navbar" class="flex-center">
    <div id="navbar__wrapper">
      <v-btn size="30" max-height="30" variant="text" icon elevation="0" style="border-radius: 100%" @click="router.back">
        <v-icon icon="mdi-chevron-left" />
      </v-btn>

      <div class="d-flex flex-column justify-center align-start text-foreground-2 ml-2">
        <h6 class="mb-0 w700">{{ title }}</h6>
        <span>{{ subTitle }}</span>
      </div>

      <div class="d-flex align-center ml-auto">
        <v-btn v-if="!mobile" size="30" max-height="30" variant="text" icon elevation="0" style="border-radius: 100%">
          <v-icon icon="mdi-bell-badge-outline" />
        </v-btn>

        <v-btn v-else size="30" max-height="30" variant="text" icon elevation="0" style="border-radius: 100%" @click="store.commit('setDrawer', true)">
          <v-icon icon="mdi-menu" />
        </v-btn>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { useRouter } from 'vue-router';
import { useDisplay } from 'vuetify/lib/framework.mjs';
import { useStore } from 'vuex';

const
  store = useStore(),
  router = useRouter(),
  { mobile } = useDisplay(),
  props = defineProps({
    title: String,
    subTitle: String,
  })
</script>

<style lang="scss">
@use '@/assets/styles/main.scss' as *;

#navbar {
  animation: movedown .5s $ease-return;
  transition: transform 0.4s ease-in-out;
  @extend .margin-global;
  height: var(--h-navbar);
  position: relative;

  &::after {
    content: "";
    position: absolute;
    bottom: 0;
    left: var(--margin-global);
    right: var(--margin-global);
    height: .25px;
    background-color: #9A8D95;
  }

  &__wrapper {
    @extend .parent;
    display: flex;
    align-items: center;
  }
}
</style>
