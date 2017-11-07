<template lang="pug">
section
    SubscribeForm
</template>

<style scoped lang="stylus">
.title
  margin: 50px 0
</style>

<script lang="livescript">
require! '~/components/signin/form.vue'
module.exports =
  components:
    SubscribeForm: form.default
</script>

