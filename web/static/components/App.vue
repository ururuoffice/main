<template>
  <div id="app">
    <img src="images/office_plan.jpg">
    <room v-for="room in rooms" v-bind:dimentions="room.dimentions" v-bind:places="room.places"></room>
  </div>
</template>

<script>
import Room from './Room';

export default {
  name: 'app',
  components: {
    Room,
  },
  data() {
    return {
      rooms: [
        {
          title: '',
          dimentions: { width: '220px', height: '220px', top: '220px', left: '500px' },
          places: [
            {
              title: '',
              coords: { top: '10px', left: '10px' },
            },
            {
              title: '',
              coords: { top: '10px', left: '70px' },
            },
          ],
        },
        {
          title: '',
          dimentions: { width: '220px', height: '220px', top: '220px', left: '1000px' },
        },
      ],
    };
  },
};
</script>

<style>
  #app {
    font-family: 'Avenir', Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-align: center;
    color: #2c3e50;
    margin-top: 60px;
    position: relative;
  }
</style>