const path = require('path')

module.exports = {
  backpack: (config, options, webpack) => {
    // server main file
    config.entry.main = path.resolve(__dirname, 'src', 'server', 'index.ls')
    config.output.path = path.resolve(__dirname, 'dist', 'server')
    config.resolve.alias = {
      '~middleware': path.resolve(__dirname, 'src', 'server', 'middleware'),
      '~services': path.resolve(__dirname, 'src', 'services', 'util'),
      '~util': path.resolve(__dirname, 'src', 'server', 'util'),
      '~': path.resolve(__dirname, 'src', 'server')
    }
    config.module.rules.push({
      test: /\.ls$/,
      exclude: /node_modules/,
      loader: 'livescript-loader'
    })
    config.resolve.extensions.push('.ls')
    // console.log(config.resolve.extensions)
    return config
  }, 
  nuxt: {
    build: {
      extractCSS: true,
      publicPath: '/_nuxt/',
      vendor: ['iview'],
      extend(config, { dev, isClient, isServer }) {
          let vueLoader = config.module.rules.find((rule) => rule.loader === 'vue-loader')
          vueLoader.options.loaders.html = {
              loader: 'iview-loader',
              options: {
                  prefix: false
              }
          }
          const aliases = Object.assign(config.resolve.alias, {
          '~api': path.resolve(__dirname, 'src/client/api')
        })
        config.resolve.alias = aliases
      }
    },
    buildDir: 'dist/client',
    cache: true,
    css: [
      // eot is needed for Internet Explorers that are older than IE9 - they invented the spec,
      // but eot is a horrible format that strips out much of the font features
      {src: 'iview/dist/styles/fonts/ionicons.eot'},
      //ttf and otf are normal old fonts,
      // but some people got annoyed that this meant anyone could download and use them
      {src: 'iview/dist/styles/fonts/ionicons.ttf'},
      // At about the same time, iOS on the iPhone and iPad implemented svg fonts
      {src: 'iview/dist/styles/fonts/ionicons.svg'},
      // Then, woff was invented which has a mode that stops people pirating the font.
      // This is the preferred format and WOFF2, a more highly compressed WOFF
      {src: 'iview/dist/styles/fonts/ionicons.woff'},

      {src: '~assets/style/app.less', lang: 'less'},
      {src: '~assets/style/app.styl', lang: 'stylus'},
    ],
    env: {
      HOST: process.env.HOST,
      PORT: process.env.PORT
    },
    head: {
      title: '<%= name %>',
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' },
        { hid: 'description', name: 'description', content: '<%= description %>' }
      ],
      link: [
  //      { rel: 'stylesheet', href: 'https://fonts.googleapis.com/css?family=Roboto:300,400,500,700|Material+Icons' }
      ]
    },
    manifest: {
      name: '<%= name %>',
      description: '<%= description %>',
      theme_color: '#188269'
    },
    modules: [
      '@nuxtjs/sitemap',
      '@nuxtjs/component-cache',
      [ '@nuxtjs/pwa',  {
          globPatterns: ['**/*.{js,css,svg,png,html,json}']
      }],
      // ['@nuxtjs/localtunnel', { subdomain: 'tendapa' }],
    ],
    plugins: [
      { src: '~/plugins/iview' },
      { src: '~/plugins/scrollto', ssr: false },
      { src: '~/plugins/feathers', ssr: false },
      // { src: '~/plugins/routersync', ssr: false }
    ],
    render: {
      static: {
        maxAge: '1y',
        setHeaders (res, path) {
          if (path.includes('sw.js')) {
            res.setHeader('Cache-Control', 'public, max-age=0')
          }
        }
      }
    },
    router: {
      base: '/',
  //    middleware: ['ssr-cookie', 'https']
    },
    srcDir: path.resolve(__dirname, 'src', 'client'),
    loading: {
      color: '#39b54a',
      height: '5px'
    }
  } 
}
