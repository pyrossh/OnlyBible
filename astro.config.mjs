import { defineConfig } from 'astro/config';
import path from 'path';

import alpinejs from "@astrojs/alpinejs";

// https://astro.build/config
export default defineConfig({
  integrations: [alpinejs()],
  resolve: {
    alias: {
      '@': path.resolve(process.cwd(), './src')
    }
  },
  experimental: {
    viewTransitions: true
  }
});