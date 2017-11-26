
### Quick start
1. `npm install -g f3` 
2. `f3 init fullstack-app`

#### Directory structure
Using `f3` to initialize a fullstack app results in the following diectory stucture

* **f3.config.js**  *webpack configuration*
* ***config/***  *server environment variables*
* ***src/*** *uncompiled code*
	* ***client/***  *nuxt frontend*
	* ***server/***  *feathers backend*
* **package.json**  *orchestration scripts*
	* **scripts:**
		* "dev" 	*run app in development*
		* "build" *build client and server*
		* "build:client" *build client only*
		* "build:server" *build  server only*

#### `feathers` baked into `nuxt`
---
The contents of `src/client` are processed through `nuxt` following configurations in declared under the key `nuxt` in the file `f3.config` See [nuxt documentation](https://nuxtjs.org/).

In addition to the resources in a standard `nuxt` project,   `src/client` includes an extra folder called `api` containing a single file named `feathers.js` for initializing `feathers` on the frontend. 

The instance is available within `Vue` components as `this.$store.app` and within `Vuex` store modules as `this.app` to provide access to backend `services`.

> Ensure that you first declare every service you intend to use in `api/feathers.js` 

When rendering is done server-side, `feathers-client`is never initialized. Instead, `feathers` server instance will be availed as stated above. 

>Thanks, to its isomorphic design, replacing  `feathers` **client ** *instance* with **server** *instance* does not necessiate changing our code.

#### `nuxt` baked into `feathers`
----
The content of `src/server` are processed by backpack are processed through `backpack` following configurations in declared under the key `backpack` in the file `f3.config`.  

**Backpack** handles file-watching, live-reloading, transpiling, and bundling targeting server so we can use awesome tools like [livescript](http://livescript.net/) or latest`EcmaScript` features. See [configuration options](https://github.com/jaredpalmer/backpack). 

In addition to standard `feathers` **server** resources, a middleware is included for leveraging `nuxt` on the server. It sets up `nuxt` for **server side rendering** and stashes the app instance in the context of every `request` so that it is accessible within `nuxtServerInit`.

>Ensure that nuxt middleware is declared last and that middleware configuration is last to set up.



