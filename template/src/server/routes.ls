fs = require 'fs'
path = require 'path'
cache = require 'lru-cache'
express = require 'express'
serverRenderer = require 'vue-server-renderer'

opts = cache: cache max: 1000 maxAge: 1000 * 60 * 15
isProd = process.env.NODE_ENV is 'production'
options = if isProd then opts else null

module.exports = ->
    app = this
    
    # rendererPath = path.join (app.get 'src'), 'compiled-ssr.js'
    # indexPath = path.join (app.get 'public'), 'index.html'
    # indexHTML = fs.readFileSync indexPath, 'utf8'

    app.use '/public', express.static app.get 'public'

    # app.get '/*', (req, res) ->
    #     code = fs.readFileSync rendererPath, 'utf8'
    #     renderer = serverRenderer.createBundleRenderer code, options
    #     context = {req.url}
    #     renderer.renderToString context, (err, html) ->
    #         return (res.status 200).send 'Server Error: server-side rendering is not working' if err
    #         tags = context.meta.inject!
    #         title = tags.title
    #         htmlAttrs = tags.htmlAttrs
    #         bodyAttrs = tags.bodyAttrs
    #         link = tags.link
    #         style = tags.style
    #         script = tags.script
    #         noscript = tags.noscript
    #         meta = tags.meta
    #         html = ((indexHTML.replace '<div id="app"></div>', html).replace '"init_state"', JSON.stringify context.initialState).replace '<title></title>', meta.text! + title.text! + link.text! + style.text! + script.text! + noscript.text!
    #         (res.status 200).send html
    #     return
    # return