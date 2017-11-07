import initFeathersClient from '~api/feathers'

export default function (ctx) {
    window.onNuxtReady((nuxt) => {

      const { isDev} = ctx
      const client = initFeathersClient(ctx)
      if(isDev) {
          window.store = store
          window.feathers = client
      }

    })
}
