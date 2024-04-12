<template>
  <div>
    <Nav></Nav>
  </div>
  <router-view />

  
</template>

<script>
import Nav from "./views/Nav.vue";
export default {
  components: {
    Nav,
  },
};
</script>

<style>


</style>
