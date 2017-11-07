import feathers from 'feathers'
import io from 'socket.io-client'
import hooks from 'feathers-hooks'
import socketio from 'feathers-socketio'
// import socketio from 'feathers-socketio-ssr'
import auth from 'feathers-authentication-client'
import AuthManagement from  'feathers-authentication-management/lib/client'

import { CookieStorage } from 'cookie-storage'


async function init(ctx) {
    const {isServer, isClient, app, store} = ctx

    const host = process.env.HOST || '127.0.0.1'
    const port = process.env.PORT || '3030'

    let feathersClient = feathers().configure(hooks())

    let storage

    if(isServer) {
        storage = require('localstorage-memory')  
        const rest = require('feathers-rest/client')
        const axios = require('axios')         
        const { req } = ctx
        feathersClient.configure(rest(`http://${host}:${port}`).axios(axios, {
            headers: {
              Cookie: req.get('cookie'),
            //   authorization: req.header('authorization')
            }
          }))
        console.log('server side feathersClient ', feathersClient)
    }

    if(isClient) {
        storage = new CookieStorage({ path: '/' })
        const socket = io(`http://${host}:${port}`)
        feathersClient.configure(socketio(socket, { timeout: 60000 }))        
        socket.on('connect', () => { console.log('nuxt socket.io connected') })
        socket.on('event', (data) => { console.log('nuxt socket.io event',data) })
        socket.on('disconnect', (data) => { console.log('nuxt socket.io disconnect',data) })
        socket.on('reconnect', (data) => { console.log('nuxt socket.io reconnect',data) })
        window.feathers = feathersClient
        app.api = feathersClient
        
    }
    
    feathersClient.configure(auth({jwtStrategy: 'jwt', storage}))

    feathersClient.auth = AuthManagement(feathersClient)

    feathersClient.service('users') 

    if(isClient) {
        
        if(ctx.store.state.auth.accessToken) {
            // alert('about to authenticate')
            try {
                await store.dispatch('auth/authenticate', { accessToken: ctx.store.state.auth.accessToken })
                console.log('feathersClient browser instance authenticated')
            } catch (error) {
                console.log('feathersClient browser instance authentication error', error)
            }
        }

    }
    
    return feathersClient
}

export default init
