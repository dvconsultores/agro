<template>
  <v-progress-circular
    :model-value="value"
    :size="size"
    :width="width"
    :color="color"
    bg-color="transparent"
    class="simple-pie-chart custom-elevation-1"
  >
    <span class="text-foreground-2">{{ value }}%</span>
  </v-progress-circular>
</template>

<script setup>
defineProps({
  value: [Number, String],
  size: {
    type: [Number, String],
    default: 48,
  },
  width: {
    type: [Number, String],
    default: 8,
  },
  color: String,
})
</script>

<style lang="scss">
.simple-pie-chart {
  border-radius: 100%;

  span {
    font-size: 11px;
    font-weight: 500;
    line-height: 16px;
    letter-spacing: 0.5px;
    text-align: center;
  }
}
</style>
