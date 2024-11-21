<template>
  <section id="forgot-password">
    <img src="@/assets/sources/logos/sap_avicola.png" class="mb-8" style="width: 165px">

    <h1 class="text-title-dark text-center">Sistema de gestión  avicola</h1>

    <h6 class="text-center text-title-dark mb-8">Recuperación de contraseña</h6>


    <v-form v-if="currentTab == 0" v-model="validFormUsername">
      <v-text-field
        v-model="userName"
        variant="solo"
        label="Usuario"
        placeholder="Nombre de usuario"
        class="mb-1"
        persistent-placeholder
        :rules="[globalRules.required]"
        @keydown="e => {
          if (e.key !== 'Enter') return
          sendCode(userName)
        }"
      ></v-text-field>

      <div class="d-flex flex-space-center mb-13">
        <span
          class="text-end"
        >
          En codigo llegara al correo electronico asociado a su usuario
        </span>
      </div>


      <v-btn
        class="btn mb-2"
        :disabled="!validFormUsername"
        :loading="isLoading"
        @click="sendCode(userName)"
      >Enviar codigo</v-btn>

    </v-form>

    <div v-if="currentTab == 1">
      <h6 class="text-center text-title-dark mb-5">Le llegara el codigo de recuperacion a su correo</h6>
      <div class="otp-container">
        <v-otp-input
          v-model="otpInput"
          input-classes="otp-input"
          :conditionalClass="['one', 'two', 'three', 'four']"
          separator="-"
          inputType="letter-numeric"
          :num-inputs="4"
          :should-auto-focus="true"
          :should-focus-order="true"
          :desabled="isLoading"
          @on-complete="handleOnComplete"
        />
      </div>
      <div class="d-flex flex-space-center mb-13">
        <a
          class="text-end link"
          @click="sendCode(userName)"
        >Reenviar correo</a>
      </div>

    </div>

    <v-form v-show="currentTab == 2" v-model="validForm">
      <v-text-field
        ref="passwordInput"
        v-model="password" solo
        variant="solo"
        label="Contraseña"
        placeholder="************"
        class="mb-1"
        persistent-placeholder
        :type="showPassword ? 'text' : 'password'"
        :append-inner-icon="showPassword ? 'mdi-eye-off-outline' : 'mdi-eye-outline'"
        :rules="[globalRules.required, globalRules.password]"
        @click:appendInner="showPassword = !showPassword"
        @keydown="e => {
          if (e.key !== 'Enter') return
          repitpasswordInput.focus()
        }"
      ></v-text-field>

      <v-text-field
        ref="repitpasswordInput"
        v-model="repitPassword" solo
        variant="solo"
        label="Repetir contraseña"
        placeholder="************"
        class="mb-1"
        persistent-placeholder
        :type="showPassword ? 'text' : 'password'"
        :append-inner-icon="showPassword ? 'mdi-eye-off-outline' : 'mdi-eye-outline'"
        :rules="[globalRules.required, globalRules.repeatPassword(password, repitPassword)]"
        @click:appendInner="showPassword = !showPassword"
        @keydown="e => {
          if (e.key !== 'Enter') return
          handleChangePassword()
        }"
      ></v-text-field>


      <v-btn
        class="btn mb-2"
        :disabled="!validForm"
        :loading="isLoading"
        @click="handleChangePassword()"
      >Cambiar contraseña</v-btn>

    </v-form>
  </section>
</template>

<script setup>
import '@/assets/styles/pages/forgot-password.scss'
import variables from '@/mixins/variables';
import { storageSecureCollection } from '@/plugins/vue3-storage-secure';
import AuthApi from '@/repository/auth_api';
import { onBeforeMount, ref } from 'vue';
import { useRouter } from 'vue-router';
import { useToast } from "vue-toastification";
import { useStorage } from 'vue3-storage-secure';
import VOtpInput from "vue3-otp-input";
import ApiLiderPollo from '@/repository/api-lider-pollo/';

const
otpInput = ref(''),
toast = useToast(),
storage = useStorage(),
router = useRouter(),
{ globalRules } = variables,

currentTab = ref(0),
validFormUsername = ref(false),
userName = ref(''),
validForm = ref(false),
isLoading = ref(false),
showPassword = ref(false),
password = ref(''),
repitPassword = ref(''),
repitpasswordInput = ref(null)


/*onBeforeMount(() => {

})*/


async function sendCode(userName) {
  if (isLoading.value || !validFormUsername.value) return
  isLoading.value = true

  try {
    await ApiLiderPollo.cambioClave.sendCode({userName});

    currentTab.value = 1

    toast.success('Codigo enviado con exito!')
  } catch (error) {
    toast.error(error)
  }

  isLoading.value = false
}

async function handleOnComplete(code) {
  if (isLoading.value) return
  isLoading.value = true

  try {
    await ApiLiderPollo.cambioClave.verifyCode({userName: userName.value, code});

    currentTab.value = 2

    toast.success('Codigo verificado con exito!')
  } catch (error) {
    toast.error(error)
  }

  isLoading.value = false
}


async function handleChangePassword() {
  if (isLoading.value || !validForm.value) return
  isLoading.value = true

  try {
    await ApiLiderPollo.cambioClave.changeClave({userName: userName.value, clave: password.value});

    toast.success('Cambio de clave realizado con exito!')
    router.push({ name: 'Login' })
  } catch (error) {
    isLoading.value = false
    toast.error(error)
  }
}
</script>
