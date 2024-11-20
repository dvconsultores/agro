<template>
  <section id="login">
    <img src="@/assets/sources/logos/sap_avicola.png" class="mb-8" style="width: 165px">

    <h1 class="text-title-dark text-center">Sistema de gestión  avicola</h1>

    <h6 class="text-center text-title-dark mb-16">Ingresa tus credenciales para poder ingresar</h6>

    <v-form v-model="validForm">
      <v-text-field
        v-model="dataLogin.userName"
        variant="solo"
        label="Usuario"
        placeholder="Nombre de usuario"
        class="mb-1"
        persistent-placeholder
        :rules="[globalRules.required]"
        @keydown="e => {
          if (e.key !== 'Enter') return
          passwordInput.focus()
        }"
      ></v-text-field>

      <v-text-field
        ref="passwordInput"
        v-model="dataLogin.password" solo
        variant="solo"
        label="Clave"
        placeholder="************"
        class="mb-1"
        persistent-placeholder
        :type="showPassword ? 'text' : 'password'"
        :append-inner-icon="showPassword ? 'mdi-eye-off-outline' : 'mdi-eye-outline'"
        :rules="[globalRules.required]"
        @click:appendInner="showPassword = !showPassword"
        @keydown="e => {
          if (e.key !== 'Enter') return
          handleLogin()
        }"
      ></v-text-field>

      <div class="d-flex flex-space-center mb-13">
        <v-checkbox
          v-model="rememberMe"
          label="Recuérdame"
          density="compact"
          hide-details
          color="rgb(var(--v-theme-primary))"
          class="flex-grow-0"
        ></v-checkbox>

        <a
          class="text-end link"
          @click="() => router.push({ name: 'ForgotPassword' })"
        >¿Olvidaste tu contraseña?</a>
      </div>

      <v-btn
        class="btn mb-2"
        :disabled="!validForm"
        :loading="isLoading"
        @click="handleLogin()"
      >Iniciar Sesión</v-btn>
    </v-form>
  </section>
</template>

<script setup>
import '@/assets/styles/pages/login.scss'
import variables from '@/mixins/variables';
import { storageSecureCollection } from '@/plugins/vue3-storage-secure';
import AuthApi from '@/repository/auth_api';
import { onBeforeMount, ref } from 'vue';
import { useRouter } from 'vue-router';
import { useToast } from "vue-toastification";
import { useStorage } from 'vue3-storage-secure';
const
  toast = useToast(),
  storage = useStorage(),
  router = useRouter(),
  { globalRules } = variables,

validForm = ref(false),
isLoading = ref(false),
rememberMe = ref(false),
showPassword = ref(false),
dataLogin = ref({
  userName: undefined,
  password: undefined,
  type: "web"
}),
passwordInput = ref(null)


onBeforeMount(() => {
  if (storage?.getSecureStorageSync(storageSecureCollection.tokenAuth))
    storage.removeStorageSync(storageSecureCollection.tokenAuth)

  const rmUserName = storage?.getSecureStorageSync(storageSecureCollection.remembeUserName)
  if (rmUserName) {
    dataLogin.value.userName = rmUserName
    rememberMe.value = true
  }
})


async function handleLogin() {
  if (isLoading.value || !validForm.value) return
  isLoading.value = true

  try {
    await AuthApi.signIn(dataLogin.value)

    if (!rememberMe.value) storage?.removeStorageSync(storageSecureCollection.remembeUserName)
    else storage?.setSecureStorageSync(storageSecureCollection.remembeUserName, dataLogin.value.userName)

    toast.success('Sign in successful!')
    router.push({ name: 'Home' })
  } catch (error) {
    isLoading.value = false
    toast.error(error)
  }
}
</script>

<style scoped>
.link {
  cursor: pointer;
  color: blue; /* Puedes personalizar el color del enlace */
  text-decoration: underline; /* Puedes personalizar la decoración del enlace */
}
</style>
