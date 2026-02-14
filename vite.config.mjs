import { defineConfig } from 'vite';
import { extensions, classicEmberSupport, ember } from '@embroider/vite';
import { babel } from '@rollup/plugin-babel';
import { VitePWA } from 'vite-plugin-pwa';

export default defineConfig({
  plugins: [
    classicEmberSupport(),
    ember(),
    VitePWA({
      registerType: 'autoUpdate',
      includeAssets: ['favicon.ico', 'robots.txt', 'apple-touch-icon.png'],
      manifest: {
        name: 'Worldmind - Marvel Champions Card Viewer',
        short_name: 'Worldmind',
        description: 'Browse and search Marvel Champions cards offline',
        theme_color: '#2c3e50',
        icons: [
          {
            src: 'pwa-192x192.png',
            sizes: '192x192',
            type: 'image/png'
          },
          {
            src: 'pwa-512x512.png',
            sizes: '512x512',
            type: 'image/png'
          }
        ]
      },
      workbox: {
        globPatterns: ['**/*.{js,css,html,ico,png,svg}'],
        runtimeCaching: [
          {
            urlPattern: /^https:\/\/cerebro-beta-bot\.herokuapp\.com\/.*/,
            handler: 'NetworkFirst',
            options: {
              cacheName: 'cerebro-api-cache',
              expiration: {
                maxEntries: 50,
                maxAgeSeconds: 60 * 60 * 24 * 7 // 1 week
              },
              cacheableResponse: {
                statuses: [0, 200]
              }
            }
          },
          {
            urlPattern: /^https:\/\/cerebrodatastorage\.blob\.core\.windows\.net\/cerebro-cards\/official\/.*\.jpg$/,
            handler: 'CacheFirst',
            options: {
              cacheName: 'cerebro-images-cache',
              expiration: {
                maxEntries: 2000,
                maxAgeSeconds: 60 * 60 * 24 * 30 // 30 days
              },
              cacheableResponse: {
                statuses: [0, 200]
              }
            }
          }
        ]
      }
    }),
    babel({
      babelHelpers: 'runtime',
      extensions,
    }),
  ],
});
