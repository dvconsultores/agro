import axios from "axios"
import { useStorage } from "vue3-storage-secure"
import { storageSecureCollection } from "@/plugins/vue3-storage-secure"
import { StatusRecepcionHuevosEnum } from "./enums"

export default class Incubadora {
  //const token = useStorage().getSecureStorageSync(storageSecureCollection.tokenAuth);
  private static token: string | null = useStorage().getSecureStorageSync(storageSecureCollection.tokenAuth);
  private static headers = {
    headers:{
      "Authorization": `Token ${this.token}`
    }
  }

  static async getInspeccionesIncubadora(data: {
    limit: number,
    index: number,
    buscar: string
  }): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/consult_incubadoras/get-inspecciones-incubadora`, data, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }


  static async getRecepciones(data: {
    limit: number,
    index: number,
    buscar: string,
    status: StatusRecepcionHuevosEnum
  }): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/consult_incubadoras/get-recepciones`, data, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }

  static async getIncubaciones(data: {
    limit: number,
    index: number,
    buscar: string
  }): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/consult_incubadoras/get-incubaciones`, data, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }


  static async getNacimientos(data: {
    limit: number,
    index: number,
    buscar: string
  }): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/consult_incubadoras/get-nacimientos`, data, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }


  static async getSalidasPollitos(data: {
    limit: number,
    index: number,
    buscar: string
  }): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/consult_incubadoras/get-salidas-pollitos`, data, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }


  static async getSemanasIncubadora(): Promise<void> {
    try {
      const response = await axios.get(`${process.env.VITE_BACKEND_URL!}/consult_incubadoras/get-semanas-incubadora`, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }

  static async getKpisIncubadora(semana: number): Promise<void> {
    try {
      const response = await axios.get(`${process.env.VITE_BACKEND_URL!}/consult_incubadoras/get-kpis-diario/${semana}`, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }

}
