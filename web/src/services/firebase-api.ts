import { initializeApp } from 'firebase/app'
import { getFirestore } from 'firebase/firestore'

import { VueFire, VueFireFirestoreOptionsAPI } from 'vuefire'

// Types
import type { App } from 'vue'
import type { VueFireOptions } from 'vuefire'

export const firebaseApp = initializeApp({
  // project configuration
  apiKey: process.env.FIREBASE_API_KEY,
  authDomain: process.env.FIREBASE_AUTH_DOMAIN,
  projectId: process.env.FIREBASE_PROJECT_ID,
  storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.FIREBASE_APP_ID,
})

export const db = getFirestore(firebaseApp)

export default (app: App) => {
  const options: VueFireOptions = {
    firebaseApp,
    modules: [
      VueFireFirestoreOptionsAPI({
        // this would be the same behavior as VueFire v2
        reset: true,
        wait: false,
      }),
    ],
  };

  app.use(VueFire, options);
}
