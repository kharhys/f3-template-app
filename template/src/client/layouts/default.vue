<template lang="pug" >
.layout
    app-header
    .layout-breadcrumb
        //- breadcrumb
    .layout-content
        main
            nuxt
    .layout-copy
        app-footer
</template>
<script lang="livescript">
require! '~/components/layout/header.vue'
require! '~/components/layout/footer.vue'
module.exports =
  components:
    AppHeader: header.default
    AppFooter: footer.default
</script>
<style scoped lang="stylus">
.layout
    // border 1px solid #d7dde4
    background #f5f7f9
.layout-assistant
    width 300px
    margin 0 auto
    height inherit
.layout-breadcrumb
    padding 10px 15px 0
.layout-content
    min-height 200px
    margin 15px
    overflow hidden
    // background #fff
.layout-content-main
    padding 10px
.layout-copy
    text-align center
    padding 10px 0 20px
    color #9ea7b4
</style>
