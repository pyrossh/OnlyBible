import adapter from '@sveltejs/adapter-static';

/** @type {import('@sveltejs/kit').Config} */
const config = {
  kit: {
    adapter: adapter({
      strict: true,
      fallback: '404.html'
    })
  }
};

export default config;
