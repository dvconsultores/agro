/// <reference types="vite/client" />

declare module '*.vue' {
  import type { DefineComponent } from 'vue'
  const component: DefineComponent<{}, {}, any>
  export default component
}

import SimplePieChart from '@/components/simple-pie-chart.vue'
import FullScreen from '@/components/helpers/full-screen.vue'
import CustomModal from '@/components/modals/custom-modal.vue'
import VImgLoad from '@/components/helpers/v-img-load.vue'
import VImgInput from '@/components/helpers/v-img-input.vue'
import VAvatarUpload from '@/components/helpers/v-avatar-upload.vue'
import Navbar from '@/components/navbar.vue'
//import FoodRecords from '@/components/process-birds/food-records.vue'

declare module '@vue/runtime-core' {
  export interface GlobalComponents {
    Navbar: typeof Navbar,
    SimplePieChart: typeof SimplePieChart,
    FullScreen: typeof FullScreen,
    CustomModal: typeof CustomModal,
    VImgLoad: typeof VImgLoad,
    VImgInput: typeof VImgInput,
    VAvatarUpload: typeof VAvatarUpload,
    //FoodRecords: typeof FoodRecords
  }
}
