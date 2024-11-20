import axios from "axios";
import { useStorage } from "vue3-storage-secure";
import { storageSecureCollection } from "@/plugins/vue3-storage-secure";
import { EtapaGranjaEnum, StatusEnum } from "./enums";

export default class Produccion {
  //const token = useStorage().getSecureStorageSync(storageSecureCollection.tokenAuth);
  private static token: string | null = useStorage().getSecureStorageSync(storageSecureCollection.tokenAuth);
  private static headers = {
    headers:{
      "Authorization": `Token ${this.token}`
    }
  }

  static async getSalidasHuevos(data: {
    limit: number,
    index: number,
    buscar: string
  }): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/consult_granja_produccion/get-salidas-huevos`, data, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }

  static async getInspeccionesTransporteHuevos(data: {
    limit: number,
    index: number,
    buscar: string
  }): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/consult_granja_produccion/get-inspecciones-transporte-huevos`, data, this.headers)

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
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/consult_granja_produccion/get-recepciones`, data, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }


  static async getRecepcionById(recepcionId: number): Promise<void> {
    try {
      const response = await axios.get(`${process.env.VITE_BACKEND_URL!}/consult_granja_produccion/get-recepcion-byid/${recepcionId}`, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }

}
