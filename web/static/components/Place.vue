<template>
  <div class="place" v-bind:class="{'place__fill': busy}" v-bind:style="position">
  </div>
</template>

<script>
export default {
  name: 'place',
  props: ['position', 'status'],
  data() {
    return {
      msg: 'Welcome to Your Vue.js App',
    };
  },
  computed: {
    busy() {
      return this.status === 'busy';
    },
  },
};
</script>

<style scoped>
  .place {
    position: absolute;
    border: 2px solid red;
    width: 40px;
    height: 40px;
    border-radius: 100%;
    cursor: pointer;
  }

  .place__fill {
    background-color: red;
  }
</style>