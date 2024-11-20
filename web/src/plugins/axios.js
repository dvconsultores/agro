import axios from 'axios'
import VueAxios from 'vue-axios'
import router from '../router'
import { useStorage } from 'vue3-storage-secure'
import { storageSecureCollection } from './vue3-storage-secure'

export default (app) => {
  const storage = useStorage()

  // set default baseURL
  axios.defaults.baseURL = process.env.API_URL || 'DEFAULT_DOMAIN_API';

  // request interceptor
  axios.interceptors.request.use(
    config => {
      // set default header auth
      const configToken = config.headers.Authorization,
      tokenAuth = storage.getSecureStorageSync(storageSecureCollection.tokenAuth)

      if (tokenAuth && !configToken) config.headers['Authorization'] = `Token ${tokenAuth}`
      return config
    },
    error => Promise.reject(error)
  )

  // response interceptor
  axios.interceptors.response.use(
    response => response,
    error => {
      if (error?.response.status === 401) {
        storage.removeStorageSync(storageSecureCollection.tokenAuth)
        router.push({ name: 'Login' })
        setTimeout(router.go, 400)
      }

      return Promise.reject(error)
    }
  )

  app
  .use(VueAxios, axios)
  .provide('axios', app.config.globalProperties.axios)
}
