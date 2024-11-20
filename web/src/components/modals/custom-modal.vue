<template>
  <v-dialog
    v-model="model"
    :max-width="maxWidth"
    :activator="activator"
    :content-class="['custom-modal', contentClass]"
    :persistent="persistent"
    :fullscreen="fullscreen"
  >
    <v-card :loading="loading" class="pa-9">
      <v-btn size="25" variant="text" class="close-button text-foreground ml-auto" @click="model = false">
        <v-icon icon="mdi-close" size="16" />
      </v-btn>

      <v-card-title :class="[titleClass, titleCenter ? 'text-center' : '' ]" style="white-space: initial; line-height: 1.1;">
        <slot name="title" :parameter="modelParameter">{{ title }}</slot>
      </v-card-title>

      <v-divider v-if="showDivider"></v-divider>

      <v-card-text :class="['pt-0 pb-4', textClass, textCenter ? 'text-center' : '' ]">
        <slot :parameter="modelParameter">
          <p v-html="text" class="mb-0" />
        </slot>
      </v-card-text>

      <slot name="actions" :parameter="modelParameter">
        <div v-if="!hideActions" :class="['flex-center', actionsClass]" style="gap: 20px;">
          <v-btn
            width="143"
            height="44"
            variant="outlined"
            class="btn"
            @click="hasCancelEmit ? emit('cancel', modelParameter) : model = false"
          >{{ cancelButtonText }}</v-btn>

          <v-btn
            width="143"
            height="44"
            class="btn bg-primary text-white"
            :disabled="disabled || loading"
            @click="emit('confirm', modelParameter)"
          >{{ confirmButtonText }}</v-btn>
        </div>
      </slot>
    </v-card>
  </v-dialog>
</template>

<script setup>
import { ref, watch, getCurrentInstance } from 'vue'

defineProps({
  fullscreen: Boolean,
  activator: String,
  persistent: Boolean,
  title: String,
  textCenter: Boolean,
  text: String,
  confirmButtonText: {
    type: String,
    default: 'Aceptar'
  },
  cancelButtonText: {
    type: String,
    default: 'Cancelar'
  },
  contentClass: String,
  titleClass: String,
  textClass: String,
  actionsClass: String,
  loading: Boolean,
  disabled: Boolean,
  showDivider: Boolean,
  titleCenter: Boolean,
  maxWidth: {
    type: String,
    default: "461"
  },
  hideActions: Boolean,
})

const
  emit = defineEmits(['open', 'confirm', 'close', 'cancel']),
  instance = getCurrentInstance(),

model = ref(false),
modelParameter = ref(null),
hasCancelEmit = !!instance?.vnode.props?.onCancel

function showModal(parameter) {
  modelParameter.value = parameter
  model.value = true
}

function closeModal() {
  model.value = false
}

defineExpose({ model, showModal, closeModal })


watch(model, (value) => {
  if (value) emit('open', modelParameter.value)
  else emit('close', modelParameter.value)
})
</script>

<style lang="scss">
@use "@/assets/styles/utils/variables.scss" as vars;

.custom-modal {
  > .v-card {
    position: relative;
    border: 1px solid vars.$primary;
    box-shadow: 0px 0px 5px 2px rgba(0, 0, 0, 0.25) !important;
  }

  .close-button {
    position: absolute;
    top: 3px;
    right: 3px;
  }
}
</style>
