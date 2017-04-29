<template>
  <div
    class="room" :style="getRoomStyles" @click="roomClick">
    <place
      v-for="place in getPlaces"
      :position="place.coords"
      :status="place.status"
      :user="place.user"
      :id="place.id"
    >
    </place>
  </div>
</template>

<script>
  import R from 'ramda';
  import { prependCssDimension, toArrayWithKeyAsId } from '../heplers';
  import Place from './Place';

  export default {
    name: 'room',
    props: {
      id: String,
      type: String,
      bg_url: String,
      places: Object,
      dimensions: Object
    },
    components: {
      Place
    },
    computed: {
      getRoomStyles() {
        const {dimensions, bg_url} = this;

        const dimensionsCss = prependCssDimension(dimensions);
        const bgCss = { backgroundImage: `url(${bg_url})` };

        return R.merge(dimensionsCss, bgCss);
      },
      getPlaces() {
        const { places } = this;
        return toArrayWithKeyAsId(places);
      }
    },
    methods: {
      roomClick() {
        const { id } = this;

        console.log('---ROOM CLICK---')
        console.log(this.$emit)
        this.$emit('roomClick', id)
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
