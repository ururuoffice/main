<template>
  <div
    class="place"
    :class="{'place__fill': user !== null}"
    :style="getPosition">
  </div>
</template>

<script>
  import { prependCssDimension } from '../heplers';

  export default {
    name: 'place',
    props: {
      position: Object,
      busy: Boolean,
      user: String
    },
    computed: {
      getPosition() {
        const { position } = this

        return prependCssDimension(position)
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

    &__fill {
      background-color: red;
    }
  }
</style>