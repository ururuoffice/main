<template>
  <div class="room" v-bind:style="dimentions" v-on:click="addPerson">
    <place v-for="place in formatedPlaces" v-bind:position="place.coords" v-bind:status="place.status"></place>
  </div>
</template>

<script>

import Place from './Place';

export default {
  name: 'room',
  props: ['dimentions', 'places'],
  components: {
    Place,
  },
  data() {
    return {
      msg: 'Welcome to Your Vue.js App',
      formatedPlaces: this.places.map((item) => {
        const formatedItem = item;
        formatedItem.status = 'empty';
        return formatedItem;
      }),
    };
  },
  computed: {
    ol() {
      return this.places;
    },
  },
  // methods: {
  //   addPerson() {
  //     for (let i = 0; i < this.formatedPlaces.length; ++i) {
  //       if (this.formatedPlaces[i].status == 'empty') {
  //         this.formatedPlaces[i].status == 'busy';
  //         break;
  //       }
  //     }
  //   }
  // }
};
</script>

<style scoped>
  .room {
    border: 3px solid red;
    position: absolute;
  }
</style>
