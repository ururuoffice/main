<template>
  <div>
    <div v-if="state === null" class="spinner">
      <span class="spinner__text"> Loading... </span>
    </div>
    <div v-else class="office" :style="getOfficeStyles">
      <room
        v-for="room in getRooms"
        :dimensions="room.dimensions"
        :places="room.places"
        :type="room.type"
        :bg_url="room.bg_url"
        :id="room.id"
        @roomClick="enterRoom"
      ></room>
    </div>
  </div>
</template>

<script>
  import socket from '../socket'
  import Room from './Room';
  import R from 'ramda';
  import { toArrayWithKeyAsId } from '../heplers'

  export default {
    name: 'app',
    components: {
      Room,
    },
    data() {
      return {
        channel: socket.channel('office:lobby', {}),
        current_user: {
          name: 'username',
          current_room: null
        },
        state: null
      };
    },
    mounted() {
      const { channel } = this
      const _this = this

      channel.join()
        .receive('ok', resp => { console.log('Joined successfully', resp) })
        .receive('error', resp => { console.log('Unable to join', resp) })

      // Listening event
      channel.on('office_updated', function(payload) {
        console.log('OFFICE UPDATED');
        console.log(window.JSON.stringify(payload, null, 2));
        _this.state = payload;
      });

      channel.push('join_office:1', {});
    },
    computed: {
      getOfficeStyles() {
        const {width, height} = this.state

        return {
          width: `${width}px`,
          height: `${height}px`
        }
      },
      getRooms() {
        const { rooms } = this.state

        return toArrayWithKeyAsId(rooms)
      }
    },
    methods: {
      enterRoom(id) {
        console.log('ENTER ROOM ID');
        console.log(id);

        const { channel, current_user: { name, current_room } } = this

        if(id === current_room) return

        console.log({
          office_id: '1',
          from_id: current_room,
          to_id: id,
          user: name
        })
        channel.push('take_place', {
          office_id: '1',
          from_id: current_room,
          to_id: id,
          user: name
        });

        this.current_user.current_room = id
      }
    }
  };
</script>

<style lang="scss">
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

  .spinner {
    position: absolute;
    width: 100vw;
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;

    &__text {
      font-size: 36px;
    }
  }
</style>