<template>
  <div
    class="room"
    :style="getRoomStyles">
    <place
      v-for="place in formatedPlaces"
      :position="place.coords"
      :status="place.status"></place>
  </div>
</template>

<script>
  import R from 'ramda';
  import { prependCssDimension } from '../heplers';
  import Place from './Place';

  export default {
    name: 'room',
    props: {
      type: String,
      bgUrl: String,
      places: Array,
      dimensions: Object
    },
    components: {
      Place,
    },
    computed: {
      getRoomStyles() {
        const {dimensions, bgUrl} = this;

        const dimensionsCss = prependCssDimension(dimensions);
        const bgCss = { backgroundImage: `url(${bgUrl})` };

        return R.merge(
          dimensionsCss,
          bgCss
        )
      }
    }
  };
</script>

<style scoped>
  .room {
    border: 3px solid red;
    position: absolute;
    background-position: center;
    background-repeat: no-repeat;
  }
</style>
