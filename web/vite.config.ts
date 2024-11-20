// Plugins
import vue from '@vitejs/plugin-vue'
import vuetify, { transformAssetUrls } from 'vite-plugin-vuetify'

// Utilities
import { defineConfig, loadEnv } from 'vite'

// https://vitejs.dev/config/
export default defineConfig((userConfig) => {
  const path = require('path'),
  env = loadEnv(userConfig.mode, process.cwd(), '')
  // isProduction = process.env.NODE_ENV === 'production',

  return {
    base: env.VITE_BASE_URL,
    plugins: [
      vue({
        template: { transformAssetUrls }
      }),
      // https://github.com/vuetifyjs/vuetify-loader/tree/next/packages/vite-plugin
      vuetify({
        autoImport: true,
        // styles: { configFile: 'src/assets/styles/settings.scss' }
      }),
    ],
    define: {
      'process.env': {
        NODE_ENV: env.NODE_ENV,
        BASE_URL: env.VITE_BASE_URL,
        API_URL: env.VITE_API_URL,
        SECURE_STORAGE_NAME_SPACE: env.VITE_SECURE_STORAGE_NAME_SPACE,
        VITE_BACKEND_URL: env.VITE_BACKEND_URL,
      },
      __VUE_I18N_FULL_INSTALL__: true,
      __VUE_I18N_LEGACY_API__: false,
      __INTLIFY_PROD_DEVTOOLS__: false,
    },
    optimizeDeps: {
      include: ['vuetify'],
      exclude: ['js-big-decimal'],
    },
    build: {
      chunkSizeWarningLimit: 2000, // Raise the chunk size limit to avoid warnings
      sourcemap: false, // Disable source maps for faster builds
    },
    resolve: {
      alias: {
        '@': path.resolve(__dirname, './src'),
      },
      extensions: [
        '.js',
        '.json',
        '.jsx',
        '.mjs',
        '.ts',
        '.tsx',
        '.vue',
      ],
    },
    server: {
      port: 3017,
      host: 'localhost',
      protocol: 'ws',
    },
  }
})
