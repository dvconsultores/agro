import axios from "axios"
import router from "@/router"
import { useStorage } from "vue3-storage-secure"
import { storageSecureCollection } from "@/plugins/vue3-storage-secure"
import { jwtDecode } from 'jwt-decode';
import ApiLiderPollo from '@/repository/api-sap-avicola';


class AuthApi {
  static async signIn(fields: { userName: string, password: string, type: string }): Promise<void> {
    try {
      /* const data: string = await new Promise((resolve) => {
        setTimeout(() => resolve("authorizationToken"), 2000);
      }) */ // <-- fake fetch
      const { data } = await axios.post(`${process.env.VITE_BACKEND_URL!}/user/login`, fields)

      useStorage().setSecureStorageSync(storageSecureCollection.tokenAuth, data.token)
      await AuthApi.loadRoles();
    } catch (error) {
      throw error.response.data
    }
  }

  static logOut(): void {
    useStorage().removeStorageSync(storageSecureCollection.tokenAuth); // Asegúrate de eliminar el token
    useStorage().removeStorageSync(storageSecureCollection.roles);
    router.replace({ name: 'Login' })
  }

  static dataToken(): { exp: number, iat: number, id: number, is_admin: boolean, nombre: string, user_name: string } {
    const token = useStorage()?.getSecureStorageSync(storageSecureCollection.tokenAuth)
    let tokenDecode = {
      exp: 0,
      iat: 0,
      id: 0,
      is_admin: false,
      nombre: "",
      user_name: ""
    };

    try {
      const decoded = jwtDecode(token);
      //userName.value = decoded?.nombre;
      tokenDecode = decoded as {
        exp: number,
        iat: number,
        id: number,
        is_admin: boolean,
        nombre: string,
        user_name: string
      };
    } catch (err) {
      console.error('Error decoding token:', err);
    }

    return tokenDecode;
  }

  static async loadRoles(): Promise<void> {
    try {
      const response = await axios.get(`${process.env.VITE_BACKEND_URL!}/consult_users/get-rol-user`,
        {
          headers:{
            "Authorization": `Token ${useStorage()?.getSecureStorageSync(storageSecureCollection.tokenAuth)}`
          }
        }
      )

      useStorage().setSecureStorageSync(storageSecureCollection.roles, response.data)
    } catch (error) {
      console.log(error)
      throw error.response.data
    }
  }

  static getRoles(): void {
    const roles = useStorage()?.getSecureStorageSync(storageSecureCollection.roles) || [];

    console.log(roles);

    return roles
  }
}

export default AuthApi
