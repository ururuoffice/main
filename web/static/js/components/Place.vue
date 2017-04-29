<template>
  <div
    class="place"
    :class="{'place__fill': busy}"
    :style="position">
  </div>
</template>

<script>


export default {
  name: 'place',
  props: {
    position: Object,
    busy: Boolean
  },
  computed: {
    getPosition() {

    }
  }
};
</script>

<style scoped lang="scss">
  .place {
    position: absolute;
    border: 2px solid red;
    width: 40px;
    height: 40px;
    border-radius: 100%;
    cursor: pointer;

    &__fill {
      background-color: red;
    }
  }
</style>