import { defineConfig } from "vite";

export default defineConfig({
  plugins: [],
  resolve: {},
  build: {
    chunkSizeWarningLimit: 600,
    cssCodeSplit: false,
  },
});
