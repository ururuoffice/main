<template>
  <div style="background-color: #63a433; width: 100%">
    <header-panel
      @toggleOffices="officesListVisible = !officesListVisible"
      @toggleUsers="usersListVisible = !usersListVisible"
    ></header-panel>
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
    <offices-list :open="officesListVisible"></offices-list>
    <users-list :open="usersListVisible"></users-list>
  </div>
</template>

<script>
  import socket from "../socket";
  import Room from './Room';
  import R from 'ramda';
  import SimplePeer from "simple-peer";
  import { toArrayWithKeyAsId } from '../heplers';
  import HeaderPanel from './HeaderPanel';
  import OfficesList from './OfficesList';
  import UsersList from './UsersList';

  export default {
    name: 'app',
    components: {
      Room,
      HeaderPanel,
      OfficesList,
      UsersList
    },
    data() {
      return {
        officeLobby: socket.channel('office:lobby', {}),
        usersLobby: socket.channel("user:lobby", {}),
        personalChannel: null,
        current_user: {
          name: 'username',
          current_room: null,
          stream: null,
          outboundConnections: {},
          inboundConnections: {}
        },
        state: null,
        officesListVisible: false,
        usersListVisible: false
      };
    },
    mounted() {
      console.log('mounted')

      const _this = this

      const userName = document.getElementById('user-id').dataset.user

      this.current_user.name = userName

      navigator.getUserMedia({ video: false, audio: true }, (stream) => {_this.current_user.stream = stream}, function () {})

      _this.personalChannel = socket.channel("user:" + userName, {})

      console.log(userName)

      _this.officeLobby.join()
        .receive('ok', resp => { console.log('Joined successfully', resp) })
        .receive('error', resp => { console.log('Unable to join', resp) })

      _this.usersLobby.join()
        .receive("ok", resp => { console.log("Joined successfully to usersLobby", resp) })
        .receive("error", resp => { console.log("Unable to join to usersLobby", resp) })

      _this.personalChannel.join()
        .receive("ok", resp => { console.log("Joined successfully to my channel", resp) })
        .receive("error", resp => { console.log("Unable to join to my channel", resp) })

      _this.personalChannel.on("message", function(payload) { console.log(payload) });

      _this.personalChannel.on("room_joined", function(payload) {
        console.log(payload)
        _this.connectToUsers(payload.message)
      });
      // Listening event
      _this.officeLobby.on('office_updated', function(payload) {
        console.log('OFFICE UPDATED');
        console.log(window.JSON.stringify(payload, null, 2));
        _this.state = payload;
      });

      _this.personalChannel.on("webrtc-connection-requested", function(payload) {
        let signal = payload.message
        console.log(signal)

        let current_user = _this.current_user

        let requesterId = signal.userId
        let peer = current_user.outboundConnections[requesterId] || current_user.inboundConnections[requesterId]

        if (!peer) {
          peer = new SimplePeer({stream: current_user.stream});

          peer.on('signal', function (data) {
            console.log('Confirm WebRTC connection', data)
            _this.sendMessageToUser(requesterId, "webrtc-connection-requested", { userId: current_user.name, data: data })
          });

          peer.on('stream', function (stream) {
            console.log('Stream received #1')
            var video = document.createElement('video')
            video.src = window.URL.createObjectURL(stream)
            document.getElementById('media-container').appendChild(video)
            video.play()
          })

          current_user.inboundConnections[requesterId] = peer
        }

        peer.signal(signal.data)
      });

      _this.officeLobby.push('join_office:1', {});
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
      sendMessageToUser(user, type, message) {
        this.usersLobby.push("message_for_user:" + user, {type: type, message: message})
      },
      enterRoom(id) {
        console.log('ENTER ROOM ID');
        console.log(id);

        const { officeLobby, current_user: { name, current_room } } = this

        if(id === current_room) return

        console.log({
          office_id: '1',
          from_id: current_room,
          to_id: id,
          user: name
        })

        if (current_room) {
          this.dropAllExistingPears()
        }

        officeLobby.push('take_place', {
          office_id: '1',
          from_id: current_room,
          to_id: id,
          user: name
        });

        this.current_user.current_room = id
      },
      toggleOffices() {
        this.officesListVisible = !this.officesListVisible
        console.log('toggle', this.officesListVisible)
      },
      initiatePeerConnection(user) {
        let _this = this
        let current_user = _this.current_user

        var peer = new SimplePeer({ initiator: true, stream: current_user.stream });

        peer.on('signal', function (data) {
          console.log('Initiate WebRTC connection', data)
          _this.sendMessageToUser(user, "webrtc-connection-requested", { userId: current_user.name, data: data })
        })

        peer.on('stream', function (stream) {
          console.log('Stream received #2')
          var video = document.createElement('video')
          video.src = window.URL.createObjectURL(stream)
          document.getElementById('media-container').appendChild(video)
          video.play()
        })

        current_user.outboundConnections[user] = peer
      },
      connectToUsers(users) {
        users.forEach((user) => { this.initiatePeerConnection(user) })
      },
      dropAllExistingPears() {
        let _this = this

        R.keys(_this.current_user.inboundConnections).forEach(function(peer_name) {
          _this.current_user.inboundConnections[peer_name].destroy();
          delete _this.current_user.inboundConnections[peer_name]
        })

        R.keys(_this.current_user.outboundConnections).forEach(function(peer_name) {
          _this.current_user.outboundConnections[peer_name].destroy();
          delete _this.current_user.outboundConnections[peer_name]
        })

        window.Array.from(document.querySelectorAll('video'), el => el).forEach(el => el.remove())
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
    box-shadow: inset 0 0 0 3px rgba(110, 110, 110, 1);
    margin: 50px auto;
    border: 7px solid #6e6e6e;
    background-color: #d9d6cc;
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
