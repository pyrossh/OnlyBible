import { defineConfig } from 'astro/config';
import path from 'path';

// https://astro.build/config
export default defineConfig({
  integrations: [],
  resolve: {
    alias: {
      '@': path.resolve(process.cwd(), './src'),
    },
  },
});