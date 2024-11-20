import axios from "axios"
import { useStorage } from "vue3-storage-secure"
import { storageSecureCollection } from "@/plugins/vue3-storage-secure"

export default class Users {
  //const token = useStorage().getSecureStorageSync(storageSecureCollection.tokenAuth);
  private static token: string | null = useStorage().getSecureStorageSync(storageSecureCollection.tokenAuth);
  private static headers = {
    headers:{
      "Authorization": `Token ${this.token}`
    }
  }


  static async getRoleUser(): Promise<void> {
    try {
      const response = await axios.get(`${process.env.VITE_BACKEND_URL!}/consult_users/get-rol-user`, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }


  static async getUsers(data: { limit: number, index: number, search: string}): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/consult_users/get-users`, data, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }

  static async getUserById(userId: number): Promise<void> {
    try {
      const response = await axios.get(`${process.env.VITE_BACKEND_URL!}/consult_users/get-user/${userId}`, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }

  static async getModulos(): Promise<void> {
    try {
      const response = await axios.get(`${process.env.VITE_BACKEND_URL!}/consult_users/get-modulos`, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }

  static async getSubModulos(modulos: number[]): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/consult_users/get-sub-modulos`, { modulos: modulos }, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }

  static async createRol(data: {
    nombre: string,
    descripcion: string,
    leer: boolean,
    insertar: boolean,
    editar: boolean,
    eliminar: boolean,
    isActive: boolean,
    modulos: {
      moduloId: number,
      subModulos: number[]
    }[]
  }): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/user/create-rol`, data, this.headers)

      return response.data
    } catch (error) {
      throw error.response.data
    }
  }

  static async updateRol(data: {
    id: number,
    nombre: string,
    descripcion: string,
    leer: boolean,
    insertar: boolean,
    editar: boolean,
    eliminar: boolean,
    isActive: boolean,
    modulos: {
      moduloId: number,
      subModulos: number[]
    }[]
  }): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/user/update-rol`, data, this.headers)

      return response.data
    } catch (error) {
      throw error.response.data
    }
  }

  static async changeStatusRol(data: { rolId: number, status: boolean }): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/user/change-status-rol`, data, this.headers)

      return response.data
    } catch (error) {
      throw error.response.data
    }
  }

  static async getRoles(data: {isActive: boolean}): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/consult_users/get-roles`, data, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }


  static async getRol(rolId: number): Promise<void> {
    try {
      const response = await axios.get(`${process.env.VITE_BACKEND_URL!}/consult_users/get-rol/${rolId}`, this.headers)

      return response.data
    } catch (error) {

      throw error.response.data
    }
  }


  static async createUser(data: {
    userName: string,
    password: string,
    nombre: string,
    apellido: string,
    telefono: string,
    cedula: string,
    email: string,
    rolId: number,
    isAdmin: boolean
  }): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/user/create-user`, data, this.headers)

      return response.data
    } catch (error) {
      throw error.response.data
    }
  }

  static async updateUser(data: {
    id: string,
    password?: string,
    nombre?: string,
    apellido?: string,
    telefono?: string,
    cedula?: string,
    email?: string,
    rolId?: number,
    isAdmin?: boolean,
    isActive?: boolean
  }): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/user/update-user`, data, this.headers)

      return response.data
    } catch (error) {
      throw error.response.data
    }
  }

  static async clearMac(userId: number): Promise<void> {
    try {
      const response = await axios.post(`${process.env.VITE_BACKEND_URL!}/user/clear-mac`, { userId: userId }, this.headers)

      return response.data
    } catch (error) {
      throw error.response.data
    }
  }

}
