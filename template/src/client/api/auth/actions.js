
export default actions = {
    async signup(store, params) {
        const {state, rootState, getters, rootGetters, commit, dispatch} = store
        console.log('store auth/register >>>>>', params)
//        this.app.router.app.$Notice.success({title: 'titl', desc: 'messag', duration: 16})
        dispatch('logout')
        commit('SIGN_UP_REQUEST')
        try {
            const user = await this.app.api.services.users.create(params)
            this.app.router.app.$Notice.success({
                title: 'Account signup successful',
                desc: `Welcome ${params.first_name} ${params.last_name} to tendapa marketplace. Check you email ${user.email} for instructions on verification of your account`,
                duration: 16
            })
            commit('SIGN_UP_SUCCESS', user)
            try {
                const auth = await dispatch('authenticate', {
                    strategy: 'local',
                    email: params.email,
                    password: params.password
                })
                commit('SIGN_IN_SUCCESS', auth)
            } catch (error) {
                console.log('auth signup authenticate error', error)
                return Promise.reject(error)
            }
        } catch (error) {
            this.app.router.app.$Notice.error({
                title: error.code + ': ' + error.name,
                desc: error.message,
                duration: 16
            })
//            console.log('auth signup error', error)
            commit('SIGN_UP_FAILURE', error)
            return Promise.reject(error)
        }
    },
     authenticate (store, credentials) {
      const { commit, state, dispatch } = store
      const feathersClient = this.app.api
      commit('setAuthenticatePending')
         dispatch('logout')
      if (state.errorOnAuthenticate) {
        commit('clearAuthenticateError')
      }
      
      return feathersClient.authenticate(credentials)
        .then(response => {
          if (response.accessToken) {
            commit('setAccessToken', response.accessToken)

            // Decode the token and set the payload, but return the response
            return feathersClient.passport.verifyJWT(response.accessToken)
              .then(payload => {
                commit('setPayload', payload)

                // Populate the user if the userService was provided
                if (state.userService && payload.hasOwnProperty('userId')) {
                  return dispatch('populateUser', payload.userId)
                    .then(() => {
                      commit('unsetAuthenticatePending')
                      return response
                    })
                } else {
                  commit('unsetAuthenticatePending')
                }
                return response
              })
          // If there was not an accessToken in the response, allow the response to pass through to handle two-factor-auth
          } else {
            return response
          }
        })
        .catch(error => {
          commit('setAuthenticateError', error)
          commit('unsetAuthenticatePending')
          return Promise.reject(error)
        })
    },
    populateUser ({ commit, state }, userId) {
        const feathersClient = this.app.api
      return feathersClient.service(state.userService)
        .get(userId)
        .then(user => {
          commit('setUser', user)
          return user
        })
    },
    async logout ({commit}) {
        console.log('logout')
      commit('setLogoutPending')
        const feathersClient = this.app.api
        try {
          const response = feathersClient.logout()
          commit('logout')
          commit('unsetLogoutPending')
          return response
        } catch (error) {
          console.error('auth/logout action error error', error)
          return Promise.reject(error)
        }
    }
}