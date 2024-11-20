import { useStorage } from "vue3-storage-secure"
import { storageSecureCollection } from "@/plugins/vue3-storage-secure"

const tokenConfig: string | null = useStorage().getSecureStorageSync(storageSecureCollection.tokenAuth);


export { tokenConfig }
