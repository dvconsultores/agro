import axios from "axios"
import { useStorage } from "vue3-storage-secure"
import { storageSecureCollection } from "@/plugins/vue3-storage-secure"

export default class CambioClave {
  //const token = useStorage().getSecureStorageSync(storageSecureCollection.tokenAuth);
  private static token: string | null = useStorage().getSecureStorageSync(storageSecureCollection.tokenAuth);
  private static headers = {
    headers:{
      "Authorization": `Token ${this.token}`
    }
  }



  static async sendCode(data: { userName: string }): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/user_cambio_clave/send-code`, data, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }

  static async verifyCode(data: { userName: string, code: string }): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/user_cambio_clave/verify-code`, data, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }

  static async changeClave(data: { userName: string, clave: string }): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/user_cambio_clave/change-clave`, data, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }



}
