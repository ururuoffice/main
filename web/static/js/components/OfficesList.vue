<template>
  <div v-bind:class="{open: open, offices: true}">
    offices
  </div>
</template>

<script>


export default {
  name: 'offices-list',
  props: {
    open: Boolean
  }
};
</script>

<style scoped lang="scss">
  .offices {
    position: fixed;
    top: 70px;
    bottom: 0;
    left: -220px;
    width: 200px;
    background: #ccc;
    transition: left .2s;

    &.open {
      left: 0;
    }
  }
</style>
