<template>
  <!--<header>-->
    <!--<button @click="toggleOffices">Open offices list</button>-->
    <!--<button @click="toggleUsers">Open users list</button>-->
  <!--</header>-->
</template>

<script>


export default {
  name: 'header-panel',
  methods: {
    toggleOffices() {
      this.$emit('toggleOffices');
    },
    toggleUsers() {
      this.$emit('toggleUsers');
    }
  }
};
</script>

<style scoped lang="scss">
  header {
    display: flex;
    justify-content: space-between;
    padding: 20px;
    background-color: #ccc;
  }
</style>
