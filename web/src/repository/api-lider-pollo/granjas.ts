import axios from "axios";
import { useStorage } from "vue3-storage-secure";
import { storageSecureCollection } from "@/plugins/vue3-storage-secure";
import { EtapaGranjaEnum, StatusEnum } from "./enums";

export default class Granjas {
  //const token = useStorage().getSecureStorageSync(storageSecureCollection.tokenAuth);
  private static token: string | null = useStorage().getSecureStorageSync(storageSecureCollection.tokenAuth);
  private static headers = {
    headers:{
      "Authorization": `Token ${this.token}`
    }
  }

  static async getKpiHome(etapa: EtapaGranjaEnum): Promise<void> {
    try {
      const response = await axios.get(`${process.env.VITE_BACKEND_URL!}/consult_granjas/get-kpis-home/${etapa}`, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }

  static async getGranjas(data: {all: boolean, status?: StatusEnum}): Promise<void> {
    try {
      const statusFinal = data?.status ? `${data.all ? '' : '?'}status=${data.status}` : '';
      const allFinal = data.all ? `?all=true&${statusFinal}` : `${statusFinal}`;
      const response = await axios.get(`${process.env.VITE_BACKEND_URL!}/consult_granjas/get-granjas${allFinal}`, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }

  static async getInspeccionesGranjas(data: {
    etapa: EtapaGranjaEnum,
    limit: number,
    index: number,
    buscar: string
  }): Promise<[[], number]> {
    try {

      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/consult_granjas/get-inspecciones-granjas`, data, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }

  static async getinspeccionGranja(inspeccionId: number): Promise<void> {
    try {
      const response = await axios.get(`${process.env.VITE_BACKEND_URL!}/consult_granjas/get-inspeccion-granja/${inspeccionId}`, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }

  static async getResgistrosAlimento(data: {
    etapa: EtapaGranjaEnum,
    limit: number,
    index: number,
    buscar: string
  }): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/consult_granjas/get-registros-alimento`, data, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }

  static async getResgistrosPesaje(data: {
    etapa: EtapaGranjaEnum,
    limit: number,
    index: number,
    buscar: string
  }): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/consult_granjas/get-registros-pesaje`, data, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }


  static async getResgistrosMortalidad(data: {
    etapa: EtapaGranjaEnum,
    limit: number,
    index: number,
    buscar: string
  }): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/consult_granjas/get-registros-mortalidad`, data, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }

  static async getResgistrosVacunas(data: {
    etapa: EtapaGranjaEnum,
    limit: number,
    index: number,
    buscar: string
  }): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/consult_granjas/get-registros-vacunas`, data, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }

  static async getSalidasAves(data: {
    etapa: EtapaGranjaEnum,
    limit: number,
    index: number,
    buscar: string
  }): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/consult_granjas/get-salidas-aves`, data, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }

  static async getInspeccionesTransporte(data: {
    etapa: EtapaGranjaEnum,
    limit: number,
    index: number,
    buscar: string
  }): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/consult_granjas/get-inspecciones-transporte`, data, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }


  static async getLotesRecepcion(granjaId: number, etapa: string): Promise<void> {
    try {
      const response = await axios.get(`${process.env.VITE_BACKEND_URL!}/consult_granjas/get-lotes-recepcion/${granjaId}/${etapa}`, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }

  static async getSemanasLote(recepcionId: number, etapa: string): Promise<void> {
    try {
      const response = await axios.get(`${process.env.VITE_BACKEND_URL!}/consult_granjas/get-semanas-lote/${recepcionId}/${etapa}`, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }


  static async getKpisLote(recepcionId: number, semana: number, etapa: string): Promise<void> {
    try {
      const dataFinal = {
        "recepcionId": recepcionId,
        "semana": semana,
        "etapa": etapa
      };
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/consult_granjas/get-kpis-lote`, dataFinal, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }

}
