<template>
  <div>
    <div class="office" :style="getOfficeStyles">
      <room
        v-for="room in rooms"
        :dimensions="room.dimensions"
        :places="room.places"
        :type="room.type"
        :bgUrl="room.bgUrl"
      ></room>
    </div>
  </div>
</template>

<script>
  import socket from "../socket"
  import Room from './Room';

  export default {
    name: 'app',
    components: {
      Room,
    },
    data() {
      return {
        width: 1000,
        height: 800,
        rooms: [
          {
            title: '',
            type: 'conference',
            bgUrl: 'images/conference_table.png',
            dimensions: {
              width: 280,
              height: 480,
              top: 0,
              left: 0
            },
            places: [
              {
                title: '',
                coords: {top: '10px', left: '10px'},
                busy: false
              },
              {
                title: '',
                coords: {top: '10px', left: '70px'},
                busy: false
              },
            ],
          },
          {
            title: '',
            type: 'default',
            bgUrl: 'images/pool_with_sofa.png',
            dimensions: {
              width: 420,
              height: 260,
              bottom: 0,
              right: 0
            },
          },
        ],
        channel: socket.channel("office:lobby", {})
      };
    },
    mounted() {
      console.log('MOUNT')
      console.log(socket)

      const { channel } = this

      channel.join()
        .receive("ok", resp => { console.log("Joined successfully", resp) })
        .receive("error", resp => { console.log("Unable to join", resp) })

      // Listening event
      channel.on("office_updated", function(payload) { console.log(payload) })

      channel.push("join_office:1", {} )

      channel.push("take_place", {office_id: "1", from_id: null, to_id: "1", user: "username"})
    },
    computed: {
      getOfficeStyles() {
        const {width, height} = this

        return {
          width: `${width}px`,
          height: `${height}px`
        }
      }
    }
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

  .office {
    position: relative;
    margin: 50px auto;
    border: 10px solid #6e6e6e;
    border-radius: 8px;
  }
</style>