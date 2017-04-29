<template>
  <div v-bind:class="{open: open, users: true}">
    users
  </div>
</template>

<script>


export default {
  name: 'users-list',
  props: {
    open: Boolean
  }
};
</script>

<style scoped lang="scss">
  .users {
    position: fixed;
    top: 70px;
    bottom: 0;
    right: -220px;
    width: 200px;
    background: #ccc;
    transition: right .2s;

    &.open {
      right: 0;
    }
  }
</style>
