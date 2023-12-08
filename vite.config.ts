import { defineConfig } from "vite";

export default defineConfig({
  server: {
    proxy: {
      '/api': {
        target: 'http://127.0.0.1:8080', // Your Urbit server address
        changeOrigin: true,
        secure: false,
        rewrite: (path) => path.replace(/^\/api/, '')
      },
    },
  },
  plugins: [],
  resolve: {},
  build: {
    chunkSizeWarningLimit: 600,
    cssCodeSplit: false,
  },
});
