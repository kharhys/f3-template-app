
### Quick start
1. `npm install -g f3` 
2. `f3 init fullstack-app`

#### Directory structure
Using `f3` to initialize a fullstack app results in the following diectory stucture


```text
.
├── /f3.config.js                               # nuxt & backpack configuration
├── /config/                                    # server environment variables
	├── /default.json                           #   settings for development env
	└── /production.json                        #   settings for production env 
└── /src
    ├── /client/                                # compiled through nuxt
        ├── /assets/                            # files to include in webpack bundle  
        ├── /static/                            # files to serve as static assets 
        ├── /pages/                             # Vue SFC accessible via a URL    
        ├── /components/                        # Vue SFC to use within other SFC
        ├── /layouts/                           # Vue SFC to use for page layout        
        ├── /middleware/                        # functions run before page render
        ├── /plugins/                           # functions to extend Vue.js
        ├── /store/                             # Vuex store modules
        └── /api/                               # directory added by f3
	        └── /feathers.js                    # feathers client for nuxt
    └── /server/                                # compiled through backpack
        ├── /index.ls                           # entry to import & initialize app         
        ├── /app.ls                             # sets up feathers app
        ├── /mongoose.ls                        # configures app to use mongoose 
        ├── /authentication.ls                  # configures app for authentication
        ├── /app.hooks.ls                       # configures global app hooks
        ├── /hooks/                             # triggers run during resource access
        ├── /services/                          # real-time access to HTTP resources 
        ├── /seed/                              # triggers to pre-populate database
        ├── /schemas/                           # mongoose schemas for HTTP resources 
        ├── /models/                            # mongoose models for HTTP resources 
        ├── /email-templates/                   # pug templates for email messages
        └── /middleware/                        # standard express middleware
	        └── /nuxt.ls                        #   nuxt to render within feathers
```


# Architecture Overview

Can be considered data driven in architecture. There are, conceptually, two layers	

* Isomorphic data presentation engine
* Isomorphic real-time data server

`feathers` is the real-time data server and`nuxt` is the isomorphic presentation engine. `feathers` does all server-side processing except rendering which is left to `nuxt` and accomplished either on the server or on the browser. The server instance available as `this.app.api` or `this.$store.app.api` is either a `feathers-client` instance if rendered client-side or a `feathers` server instance when rendered server-side.

 `nuxt` is configured to use `Vuex` in modules mode. `feathers` server is accessible at the presentation layer on the client or on the server as `this.app.api` in `Vuex` store modules or as `this.$store.app.api` in `Vue` components.

> It is recommended to externalize back-end services access logic outside components into store actions where you can access the server as `this.app.api`. However, there are other features of the back-end `api` that you may want to use in your components. For instance, `storyboard` logging (More on that below).

## Presentation Layer
------

Data presentation is done using `Vue.js`. For efficient `Server Side Rendering` and many other features  `nuxt` is used.  This makes the data presentation layer capable of running on the server or on client. The data for the presentation layer is availed by `feathers`

#### `nuxt` baked into `feathers`

The content of `src/server` are processed by backpack are processed through `backpack` following configurations in declared under the key `backpack` in the file `f3.config`.  

**Backpack** handles file-watching, live-reloading, transpiling, and bundling targeting server so we can use awesome tools like [livescript](http://livescript.net/) or latest`EcmaScript` features. See [configuration options](https://github.com/jaredpalmer/backpack). 

In addition to standard `feathers` **server** resources, a middleware is included for leveraging `nuxt` on the server. It sets up `nuxt` for **server side rendering** and stashes the app instance in the context of every `request` so that it is accessible within `nuxtServerInit`.

>Ensure that nuxt middleware is declared last and that middleware configuration is last to set up.


#### `feathers` baked into `nuxt`

The contents of `src/client` are processed through `nuxt` following configurations in declared under the key `nuxt` in the file `f3.config` See [nuxt documentation](https://nuxtjs.org/).

In addition to the resources in a standard `nuxt` project,   `src/client` includes an extra folder called `api` containing a single file named `feathers.js` for initializing `feathers` on the frontend. 

The instance is available within `Vue` components as `this.$store.app.api` and within `Vuex` store modules as `this.app.api` to provide access to backend `services`.

> Ensure that you first declare every service you intend to use in `api/feathers.js` 

When rendering is done server-side, `feathers-client`is never initialized. Instead, `feathers` server instance will be availed as stated above. 

>Thanks, to its isomorphic design, replacing  `feathers` **client ** *instance* with **server** *instance* does not necessiate changing our code.


## Persistence Layer
------

#### mongodb baked in 
Mongo Database set up with

* `mongoose` for model ***schema*** *declaration* and *validation*
* `mongoose-gridfs` for ***streaming*** file uploads to `mongodb`



