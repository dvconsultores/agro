import axios from "axios"
import { useStorage } from "vue3-storage-secure"
import { storageSecureCollection } from "@/plugins/vue3-storage-secure"

export default class Engorde {
  //const token = useStorage().getSecureStorageSync(storageSecureCollection.tokenAuth);
  private static token: string | null = useStorage().getSecureStorageSync(storageSecureCollection.tokenAuth);
  private static headers = {
    headers:{
      "Authorization": `Token ${this.token}`
    }
  }


  static async getMaestroLotes(data: { limit: number, index: number, search: string}): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/consult_granja_engorde/get-maestro-lotes`, data, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }

  static async setMaestroLote(data: {
    lote: string,
    idSap: string
  }): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/granja_engorde/set-maestro-lote`, data, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }


  static async getRecepciones(data: {
    limit: number,
    index: number,
    buscar: string
  }): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/consult_granja_engorde/get-recepciones`, data, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }


  static async getRecepcionById(recepcionId: number): Promise<void> {
    try {
      const response = await axios.get(`${process.env.VITE_BACKEND_URL!}/consult_granja_engorde/get-recepcion-byid/${recepcionId}`, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }

}
