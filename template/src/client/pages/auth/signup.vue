<template lang="pug">
section
    signup-form
</template>

<style scoped lang="stylus">
.title
  margin: 50px 0
</style>

<script lang="livescript">
require! '~/components/signup/form.vue'
module.exports =
  components:
    signupForm: form.default
</script>

