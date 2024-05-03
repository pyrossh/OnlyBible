import * as sitemap from 'super-sitemap';

export const prerender = true;

export async function GET() {
  return await sitemap.response({
    origin: 'https://onlybible.app',
  });
};