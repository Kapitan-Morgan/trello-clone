<template>
  <div id="app">
    <div v-for="list in original_lists">
      {{ list.name }}
    </div>
  </div>
</template>

<script>
export default {
  props: ["original_lists"],
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
