<template>
  <Navbar title="Usuarios" sub-title="Editar usuario" class="mb-4" />

  <custom-modal
    ref="modalSuccess"
    title="¡Guardado exitoso!"
    title-class="text-primary w600"
    title-center
    hide-actions
    @close="router.back()"
  />

  <custom-modal
    ref="modalConfirm"
    title-class="text-primary w600"
    title-center
    cancel-button-text="No, Cancelar"
    confirm-button-text="Si, Guardar"
    :disabled="!validForm"
    :loading="isLoading"
    @confirm="handleIntegration"
  >
    <template #title>
      ¿Deseas guardar<br>el usuario?
    </template>
  </custom-modal>

  <div id="create-user">
    <h5 class="text-primary w600 mb-6" style="--fs: 22px">Editar usuario</h5>

    <v-card class="px-4 py-6">
      <h6 class="text-primary w600 mb-6">Modificación de usuario</h6>
      <v-form v-model="validForm">
        <section class="d-flex flex-wrap" style="column-gap: 8px; row-gap: 0;">
          <v-text-field
            v-model="data.userName"
            variant="solo"
            label="Usuario / Apodo"
            placeholder="pedroacastillo"
            persistent-placeholder
            style="flex-basis: 890px;"
            maxlength="20"
            disabled
          ></v-text-field>

          <div class="d-flex" style="flex-basis: 1590px; gap: 8px;">
            <v-text-field
              v-model="data.nombre"
              variant="solo"
              label="Nombre"
              placeholder="Pedro Alberto"
              persistent-placeholder
              style="flex-basis: 890px;"
              maxlength="20"
              :rules="[globalRules.required]"
            ></v-text-field>

            <v-text-field
              v-model="data.apellido"
              variant="solo"
              label="Apellido"
              placeholder="Castillo Toro"
              persistent-placeholder
              style="flex-basis: 890px;"
              maxlength="20"
              :rules="[globalRules.required]"
            ></v-text-field>
          </div>

          <div class="d-flex" style="flex-basis: 1590px; gap: 8px;">
            <v-select
              v-model="data.typeCedula"
              variant="solo"
              :items="['V', 'E']"
              item-title="nombre"
              item-value="id"
              menu-icon="mdi-chevron-down"
              style="flex-basis: 100px;"
              :rules="[globalRules.required]"
            ></v-select>

            <v-text-field
              v-model="data.cedulaNumber"
              variant="solo"
              label="Cedula"
              placeholder="12345678"
              persistent-placeholder
              maxlength="9"
              style="flex-basis: 1050px;"
              :rules="[globalRules.required]"
              @input="filterNumbers"
            ></v-text-field>
          </div>

          <div class="d-flex" style="flex-basis: 1590px; gap: 8px;">
            <v-text-field
              v-model="data.email"
              variant="solo"
              label="Correo"
              placeholder="alcl@gmail.com"
              persistent-placeholder
              style="flex-basis: 890px;"
              maxlength="50"
              :rules="[globalRules.required, globalRules.email]"
            ></v-text-field>

            <v-text-field
              v-model="data.telefono"
              variant="solo"
              label="Número de teléfono"
              placeholder="0426-1234569"
              persistent-placeholder
              style="flex-basis: 890px;"
              :rules="[globalRules.required]"
              type="tel"
              maxlength="14"
              @input="filterPhoneNumbers"
            ></v-text-field>
          </div>

          <div class="d-flex" style="flex-basis: 1590px; gap: 8px;">
            <v-text-field
              v-model="data.password"
              variant="solo"
              label="Contraseña"
              placeholder="************"
              :type="showPassword ? 'text' : 'password'"
              :append-inner-icon="showPassword ? 'mdi-eye-off-outline' : 'mdi-eye-outline'"
              @click:appendInner="showPassword = !showPassword"
              persistent-placeholder
              style="flex-basis: 890px;"
              maxlength="30"
              :rules="[globalRules.required, globalRules.password]"
            ></v-text-field>

            <v-text-field
              v-model="data.passwordRepit"
              variant="solo"
              label="Repetir contraseña"
              placeholder="************"
              :type="showRepitPassword ? 'text' : 'password'"
              :append-inner-icon="showRepitPassword ? 'mdi-eye-off-outline' : 'mdi-eye-outline'"
              @click:appendInner="showRepitPassword = !showRepitPassword"
              persistent-placeholder
              style="flex-basis: 890px;"
              maxlength="30"
              :rules="[globalRules.required, globalRules.repeatPassword(data.password, data.passwordRepit)]"
            ></v-text-field>
          </div>

          <!--<v-text-field
            variant="solo"
            label="IMEI - 1"
            placeholder="12345678987654321"
            persistent-placeholder
            style="flex-basis: 217px;"
          ></v-text-field>

          <v-text-field
            variant="solo"
            label="IMEI - 2"
            placeholder="12345678987654321"
            persistent-placeholder
            style="flex-basis: 217px;"
          ></v-text-field>

          <v-select
            variant="solo"
            label="Estado teléfono"
            placeholder="Activo"
            persistent-placeholder
            :items="[phoneState.active, phoneState.inactive]"
            item-title="text"
            item-value="value"
            menu-icon="mdi-chevron-down"
            style="flex-basis: 217px;"
          ></v-select>

          <v-select
            v-model="data.isAdmin"
            variant="solo"
            label="Administrador"
            placeholder="Bloqueado"
            persistent-placeholder
            :items="userState"
            item-title="desc"
            item-value="state"
            menu-icon="mdi-chevron-down"
            style="flex-basis: 217px;"
          ></v-select>-->

          <v-switch v-model="data.isAdmin" label="Administrador"></v-switch>

        </section>

        <h6 class="text-primary w600 mb-6">Granjas Asignacion</h6>

        <section class="d-flex flex-wrap" style="column-gap: 8px; row-gap: 0;">
          <v-autocomplete
            v-model="data.granjasIds"
            variant="solo"
            label="Granjas para asignar"
            placeholder="Granjas"
            persistent-placeholder
            :items="farms"
            item-title="name"
            item-value="id"
            menu-icon="mdi-chevron-down"
            style="flex-basis: 890px;"
            multiple
            max-chips="2"
            :rules="[globalRules.listRequired]"
            @update:model-value="console.log(validForm)"
          >
            <template v-slot:selection="{ item, index }">
              <v-chip v-if="index < 2">
                <span>{{ item.title }}</span>
              </v-chip>
              <span
                v-if="index === 2"
                class="text-grey text-caption align-self-center"
              >
                (+{{ data?.granjasIds.length - 2 }} otros)
              </span>
            </template>
          </v-autocomplete>
        </section>

        <h6 class="text-primary w600 mb-6">Rol asignado</h6>

        <section class="d-flex flex-wrap" style="column-gap: 8px; row-gap: 0;">
          <v-select
            v-model="data.rolId"
            variant="solo"
            label="Rol para asignar"
            placeholder="Roles"
            persistent-placeholder
            :items="roles"
            item-title="nombre"
            item-value="id"
            menu-icon="mdi-chevron-down"
            style="flex-basis: 890px;"
            :rules="[globalRules.required]"
          ></v-select>
        </section>
      </v-form>

      <v-btn
        width="170"
        class="btn ml-auto"
        :disabled="!validForm"
        :loading="isLoading"
        @click="modalConfirm.showModal()"
      >Guardar</v-btn>
    </v-card>
  </div>
</template>

<script setup>
import '@/assets/styles/pages/create-user.scss'
import { phoneState } from '@/models/phone-state-model';
import { userState } from '@/models/user-state-model';
import ApiLiderPollo from '@/repository/api-sap-avicola/';
import { onBeforeMount, ref, watch } from 'vue';
import variables from '@/mixins/variables';
import { useToast } from "vue-toastification";
import { useRoute, useRouter } from 'vue-router';

const
route = useRoute(),
router = useRouter(),
userId = route.query?.userId,
toast = useToast(),
{ globalRules } = variables,
validForm = ref(false),
isLoading = ref(false),
modalSuccess = ref(),
modalConfirm = ref(),
showPassword = ref(false),
showRepitPassword = ref(false),
/*userStates = ref([
  { state: true, desc: userState.active },
  { state: false, desc: userState.blocked }
]),*/
roles = ref([]),
farms = ref([]),
data = ref({
  id: undefined,
  userName: undefined,
  password: undefined,
  passwordRepit: undefined,
  nombre: undefined,
  apellido: undefined,
  telefono: undefined,
  cedula: undefined,
  cedulaNumber: undefined,
  typeCedula: "V",
  email: undefined,
  rolId: null,
  isAdmin: false,
  granjasIds: []
});

onBeforeMount(() => {
  if (!userId) {
    router.back();
  }
  getData();
})


// Función para eliminar espacios en blanco de la entrada del usuario
const removeSpaces = (event) => {
  data.value.userName = event.target.value.replace(/\s+/g, '');
};

// Función para eliminar caracteres no numéricos de la entrada cedula
const filterNumbers = (event) => {
  data.value.cedulaNumber = event.target.value.replace(/\D/g, ''); // Eliminar caracteres no numéricos
};

// Función para eliminar caracteres no numéricos de la entrada telefono y colocar formato telefonico
const filterPhoneNumbers = (event) => {
  let value = event.target.value.replace(/\D/g, ''); // Eliminar caracteres no numéricos

  if (value.length > 1) {
    value = value.slice(0, 0) + '(' + value.slice(0);
  }

  if (value.length > 4) {
    value = value.slice(0, 5) + ')' + value.slice(5);
    value = value.slice(0, 6) + '-' + value.slice(6); // Insertar guion después de los primeros 4 dígitos
  }
  data.value.telefono = value;
};


async function getData() {
  await ApiLiderPollo.users.getRoles({ isActive: true }).then((response) => {
    roles.value = response.map((item) => ({
      id: item.id,
      nombre: `${item.nombre} - ${item.descripcion}`
    }));
  }).catch((error) => {
    console.log(error)
    toast.error(error);
  });

  await ApiLiderPollo.granjas.getGranjas({ all: true, status: "ACTIVO" }).then((response) => {
    farms.value = response.map((item) => ({ id: item.id, name: `${item.id} - ${item.name}` }));
  }).catch((error) => {
    console.log(error)
    toast.error(error);
  });

  await ApiLiderPollo.users.getUserById(userId).then((response) => {
    data.value = {
      id: response.id,
      userName: response.user_name,
      password: response.password,
      passwordRepit: response.password,
      nombre: response.nombre,
      apellido: response.apellido,
      telefono: response.telefono,
      cedula: response.cedula,
      cedulaNumber: response.cedula.split('-').length > 1 ? response.cedula.split('-')[1] : response.cedula,
      typeCedula: response.cedula.split('-').length > 1 ? response.cedula.split('-')[0] : null,
      email: response.email,
      rolId: response.user_role_id?.id || null,
      isAdmin: response.is_admin,
      granjasIds: response?.granjas_asignacion ? response.granjas_asignacion.map((item) => item.granja_id.id) : []
    };


  }).catch((error) => {
    console.log(error)
    toast.error(error);
  });

}


async function handleIntegration() {
  if (isLoading.value || !validForm.value) {
    modalConfirm.value.closeModal();
    return
  }

  //combinando typeCedula y cedulaNumber para formar la cedula
  data.value.cedula = `${data.value.typeCedula}-${data.value.cedulaNumber}`;

  isLoading.value = true;

  try {
    await ApiLiderPollo.users.updateUser(data.value);

    modalConfirm.value.closeModal();
    modalSuccess.value.showModal();
  } catch (error) {
    console.log(error)
    toast.error(error)
    modalConfirm.value.closeModal();
  }

  isLoading.value = false;
}
</script>
