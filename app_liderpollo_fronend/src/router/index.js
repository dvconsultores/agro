// Composables
import { createRouter, createWebHistory } from 'vue-router'
import { useStorage } from "vue3-storage-secure";
import { nextTick } from 'vue'
import { APP_NAMES } from '@/plugins/dictionary';
import { storageSecureCollection } from '@/plugins/vue3-storage-secure';

const DEFAULT_TITLE = APP_NAMES.capitalize;

const routes = [
  // ? Default routes
  {
    path: '/',
    component: () => import('@/layouts/default-layout.vue'),
    meta: { requiresAuth: true },
    children: [
      {
        path: '',
        name: 'Home',
        component: () => import('@/pages/home.vue'),
        meta: { head: `Home - ${DEFAULT_TITLE}` }
      },
      {
        path: 'process-breeding-birds',
        name: 'ProcessBreedingBirds',
        component: () => import('@/pages/breeding-birds-phase/process-birds.vue'),
        meta: { head: `Procesos aves cría - ${DEFAULT_TITLE}` }
      },
      {
        path: 'process-production-birds',
        name: 'ProcessProductionBirds',
        component: () => import('@/pages/production-birds-phase/process-birds.vue'),
        meta: { head: `Procesos aves producción - ${DEFAULT_TITLE}` }
      },
      {
        path: 'process-fattening-birds',
        name: 'ProcessFatteningBirds',
        component: () => import('@/pages/fattening-birds-phase/process-birds.vue'),
        meta: { head: `Procesos aves engorde - ${DEFAULT_TITLE}` }
      },

      {
        path: 'exit-breeding-birds',
        name: 'ExitBreedingBirds',
        component: () => import('@/pages/breeding-birds-phase/birds-exit.vue'),
        meta: { head: `Salida aves cría - ${DEFAULT_TITLE}` }
      },
      {
        path: 'exit-production-birds',
        name: 'ExitProductionBirds',
        component: () => import('@/pages/production-birds-phase/birds-exit.vue'),
        meta: { head: `Salida aves producción - ${DEFAULT_TITLE}` }
      },
      {
        path: 'exit-production-eggs',
        name: 'ExitProductionEggs',
        component: () => import('@/pages/production-birds-phase/eggs-exit.vue'),
        meta: { head: `Salida huevos producción - ${DEFAULT_TITLE}` }
      },
      {
        path: 'exit-fattening-birds',
        name: 'ExitFatteningBirds',
        component: () => import('@/pages/fattening-birds-phase/birds-exit.vue'),
        meta: { head: `Salida aves engorde - ${DEFAULT_TITLE}` }
      },


      {
        path: 'inspection-transport-breeding',
        name: 'InspectionTransportBreeding',
        component: () => import('@/pages/breeding-birds-phase/inspection-transport.vue'),
        meta: { head: `Inspección transporte cría - ${DEFAULT_TITLE}` }
      },
      {
        path: 'inspection-transport-production',
        name: 'InspectionTransportProduction',
        component: () => import('@/pages/production-birds-phase/inspection-transport.vue'),
        meta: { head: `Inspección transporte producción - ${DEFAULT_TITLE}` }
      },
      {
        path: 'inspection-transport-production-eggs',
        name: 'InspectionTransportProductionEggs',
        component: () => import('@/pages/production-birds-phase/inspection-transport-eggs.vue'),
        meta: { head: `Inspección transporte huevos producción - ${DEFAULT_TITLE}` }
      },
      {
        path: 'inspection-transport-fattening',
        name: 'InspectionTransportFattening',
        component: () => import('@/pages/fattening-birds-phase/inspection-transport.vue'),
        meta: { head: `Inspección transporte engorde - ${DEFAULT_TITLE}` }
      },



      {
        path: 'farm-inspection-breeding',
        name: 'FarmInspectionBreeding',
        component: () => import('@/pages/breeding-birds-phase/farm-inspection.vue'),
        meta: { head: `Granja inspección cría - ${DEFAULT_TITLE}` }
      },
      {
        path: 'farm-inspection-production',
        name: 'FarmInspectionProduction',
        component: () => import('@/pages/production-birds-phase/farm-inspection.vue'),
        meta: { head: `Granja inspección producción - ${DEFAULT_TITLE}` }
      },
      {
        path: 'farm-inspection-fattening',
        name: 'FarmInspectionFattening',
        component: () => import('@/pages/fattening-birds-phase/farm-inspection.vue'),
        meta: { head: `Granja inspección engorde - ${DEFAULT_TITLE}` }
      },


      {
        path: 'breeding-reception',
        name: 'BreedingReception',
        component: () => import('@/pages/breeding-birds-phase/birds-reception.vue'),
        meta: { head: `Recepción aves cía - ${DEFAULT_TITLE}` }
      },
      {
        path: 'production-reception',
        name: 'ProductionReception',
        component: () => import('@/pages/production-birds-phase/birds-reception.vue'),
        meta: { head: `Recepción aves producción - ${DEFAULT_TITLE}` }
      },
      {
        path: 'fattening-reception',
        name: 'FatteningReception',
        component: () => import('@/pages/fattening-birds-phase/birds-reception.vue'),
        meta: { head: `Recepción aves engorde - ${DEFAULT_TITLE}` }
      },



      {
        path: 'incubator-inspection',
        name: 'IncubatorInspection',
        component: () => import('@/pages/incubator/incubator-inspection.vue'),
        meta: { head: `Incubadora inspecciones - ${DEFAULT_TITLE}` }
      },
      {
        path: 'eggs-reception',
        name: 'EggsReception',
        component: () => import('@/pages/incubator/eggs-reception.vue'),
        meta: { head: `Recepciones de huevos - ${DEFAULT_TITLE}` }
      },
      {
        path: 'eggs-classification',
        name: 'EggsClassification',
        component: () => import('@/pages/incubator/eggs-classification.vue'),
        meta: { head: `Clasificaciones de huevos - ${DEFAULT_TITLE}` }
      },
      {
        path: 'eggs-incubation',
        name: 'EggsIncubation',
        component: () => import('@/pages/incubator/eggs-incubation.vue'),
        meta: { head: `Incubaciones de huevos - ${DEFAULT_TITLE}` }
      },
      {
        path: 'birth-registration',
        name: 'BirthRegistration',
        component: () => import('@/pages/incubator/birth-registration.vue'),
        meta: { head: `Registros de nacimientos - ${DEFAULT_TITLE}` }
      },
      {
        path: 'chicks-exit',
        name: 'ChicksExit',
        component: () => import('@/pages/incubator/chicks-exit.vue'),
        meta: { head: `Salidas pollitos BB - ${DEFAULT_TITLE}` }
      },




      {
        path: 'maestros',
        name: 'Maestros',
        component: () => import('@/pages/maestros.vue'),
        meta: { head: `Maestros - ${DEFAULT_TITLE}` }
      },
      {
        path: 'users',
        name: 'Users',
        component: () => import('@/pages/users.vue'),
        meta: { head: `Users - ${DEFAULT_TITLE}` }
      },
      {
        path: 'create-user',
        name: 'CreateUser',
        component: () => import('@/pages/create-user.vue'),
        meta: { head: `Create user - ${DEFAULT_TITLE}` }
      },
      {
        path: 'editar-user',
        name: 'EditarUser',
        component: () => import('@/pages/editar-user.vue'),
        meta: { head: `Editar user - ${DEFAULT_TITLE}` }
      },
      {
        path: 'create-roles',
        name: 'CreateRoles',
        component: () => import('@/pages/create-roles.vue'),
        meta: { head: `Create roles - ${DEFAULT_TITLE}` }
      },
      {
        path: 'update-rol',
        name: 'UpdateRol',
        component: () => import('@/pages/update-rol.vue'),
        meta: { head: `Update rol - ${DEFAULT_TITLE}` }
      },
      {
        path: 'visualize',
        name: 'Visualize',
        component: () => import('@/pages/visualize.vue'),
        meta: { head: `Visualize - ${DEFAULT_TITLE}` }
      },
      {
        path: 'kpi-breeding-birds-phase',
        name: 'KpiBreedingBirdsPhase',
        component: () => import('@/pages/kpis/kpi-breeding-birds-phase.vue'),
        meta: { head: `KPI Breeding Birds Phase - ${DEFAULT_TITLE}` }
      },
      {
        path: 'kpi-production-birds-phase',
        name: 'KpiProductionBirdsPhase',
        component: () => import('@/pages/kpis/kpi-production-birds-phase.vue'),
        meta: { head: `KPI Production Birds Phase - ${DEFAULT_TITLE}` }
      },
      {
        path: 'kpi-fattening-birds-phase',
        name: 'KpiFatteningBirdsPhase',
        component: () => import('@/pages/kpis/kpi-fattening-birds-phase.vue'),
        meta: { head: `KPI Fattening Birds Phase - ${DEFAULT_TITLE}` }
      },
      {
        path: 'kpi-incubator',
        name: 'KpiIncubator',
        component: () => import('@/pages/kpis/kpi-incubator.vue'),
        meta: { head: `KPI Incubator - ${DEFAULT_TITLE}` }
      },
    ],
  },


  // ? No Authenticated routes
  {
    path: '/auth',
    component: () => import('@/layouts/auth-layout.vue'),
    children: [
      {
        path: 'login',
        name: 'Login',
        component: () => import('@/pages/login.vue'),
        meta: { head: `Login - ${DEFAULT_TITLE}` }
      },
      {
        path: 'forgotPassword',
        name: 'ForgotPassword',
        component: () => import('@/pages/forgot-password.vue'),
        meta: { head: `Clave perdida - ${DEFAULT_TITLE}` }
      },
      {
        path: "/:pathMatch(.*)*",
        name: "Error",
        component: () => import('@/pages/error.vue'),
        meta: { head: `Error - ${DEFAULT_TITLE}` }
      },
    ],
  },
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
})


router.beforeEach((to, from, next) => {
  if (to.path === '/auth') return next({ name: 'Login' })


  // this route requires auth, check if logged in
  // if not, redirect to login page.
  const tokenAuth = useStorage().getSecureStorageSync(storageSecureCollection.tokenAuth)
  if (to.matched.some(record => record.meta.requiresAuth) && !tokenAuth)
    return next({ name: 'Login' })

  // go to wherever I'm going
  next()
})


router.afterEach((to, from) => {
  // Use next tick to handle router history correctly
  // see: https://github.com/vuejs/vue-router/issues/914#issuecomment-384477609
  nextTick(() => {
    document.title = to.meta.head?.toString() || DEFAULT_TITLE;
  });
});

export default router
