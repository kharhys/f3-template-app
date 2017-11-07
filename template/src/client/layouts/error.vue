{{{{raw}}}}
<template lang="pug">
section.container
  .img
  h1.title
    | {{ error.statusCode }}
  h2.info
    | {{ error.message }}
  nuxt-link.button(to='/', v-if='error.statusCode === 404')
    | Homepage
</template>
{{{{/raw}}}}
<script lang="livescript">
module.exports =
  props: ['error']
</script>

<style scoped lang="stylus">
section.container
  height: 80vh
  display: flex
  align-items: center
  justify-content: center
  flex-direction: column
.img
  background-image: '~/assets/img/tendapa_logo_white.png'
.title
    margin-top 15px
    font-size 5em

.info
    font-weight 300
    color #9aabb1
    margin 0

.button
    margin-top 50px
</style>
