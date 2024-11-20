<template>
  <div class="kpis-list">
    <v-card v-for="(item, i) in data" :key="i" class="d-flex" :style="item.basis ? `--basis: ${item.basis}px` : null" style="gap: 10px;">
      <div class="d-flex flex-column justify-center align-start flex-grow-1">
        <h6 class="mb-1">{{ item.name }}</h6>
        <span>{{ item.value }}</span>
      </div>

      <div v-if="item?.percentage == null" style="height: 2%;" ></div>

      <v-progress-circular
        v-else
        :model-value="item.percentage"
        :color="item.color"
        bg-color="transparent"
        width="7"
        :style="item.percentage ? `--percentage: '${item.percentage}%'` : null"
      />
    </v-card>
  </div>
</template>

<script setup lang="ts">
export interface KpiCardModel {
  name: string,
  value: string|number,
  percentage: number,
  color: string,
  basis?: number,
}

defineProps({
  data: Array<KpiCardModel>,
})
</script>

<style lang="scss">
.kpis-list {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;

  > * { flex: 1 1 300px }

  @media (max-width: 880px) {
    > * { flex: 1 1 var(--basis, 168px) }
  }

  .v-card {
    padding: 8px 12px;

    h6 {
      font-family: var(--font-1);
      font-size: clamp(12px, 1vw, 16px) !important;
      font-weight: 700 !important;
      letter-spacing: 0.4000000059604645px !important;
      color: #46464F !important;

      & + span {
        font-family: var(--font-1);
        font-size: clamp(12px, 1vw, 16px) !important;
        font-weight: 500 !important;
        letter-spacing: 0.5px !important;
        color: #46464F !important;
      }
    }

    .v-progress-circular {
      border-radius: 50%;
      box-shadow: 0px 1px 2px 0px #00000040;
      min-width: clamp(48px, 7vw, 60px);
      height: clamp(48px, 7vw, 60px);

      &::after {
        content: var(--percentage, "0%");
        font-weight: 500 !important;
        font-size: clamp(11px, 1vw, 20px);
        color: #46464F;
      }
    }
  }
}
</style>
