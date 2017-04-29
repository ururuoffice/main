// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import socket from "./socket"
import Vue from 'vue'
import App from "../components/App.vue"

window.userId = Math.random().toString(36).substring(7)

Vue.component('app', App)

// Now that you are connected, you can join channels with a topic:
window.socket = socket;
window.channel = socket.channel("room:lobby", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

window.usersLobby = socket.channel("user:lobby", {})
usersLobby.join()
  .receive("ok", resp => { console.log("Joined successfully to usersLobby", resp) })
  .receive("error", resp => { console.log("Unable to join to usersLobby", resp) })

window.personalChannel = socket.channel("user:" + userId, {})
personalChannel.join()
  .receive("ok", resp => { console.log("Joined successfully to my channel", resp) })
  .receive("error", resp => { console.log("Unable to join to my channel", resp) })

personalChannel.on("message", function(payload) { console.log(payload) });

new Vue({
  el: '#app',
  render(createElement) {
    return createElement(App, {})
  }
});

import SimplePeer from "simple-peer"

window.currentUserStream = null;

window.outboundConnections = {}
window.inboundConnections = {}

navigator.getUserMedia({ video: true, audio: false }, function(stream) {window.currentUserStream = stream}, function () {})

function sendMessageToUser(user, type, message) {
  usersLobby.push("message_for_user:" + user, {type: type, message: message})
}

personalChannel.on("webrtc-connection-requested", function(payload) {
  let signal = payload.message
  console.log(signal)

  let requesterId = signal.userId
  let peer = outboundConnections[requesterId] || inboundConnections[requesterId]

  if (!peer) {
    peer = new SimplePeer({stream: window.currentUserStream});

    peer.on('signal', function (data) {
      console.log('Confirm WebRTC connection', data)
      sendMessageToUser(requesterId, "webrtc-connection-requested", { userId: window.userId, data: data })
    });

    peer.on('stream', function (stream) {
      console.log('Stream received #1')
      var video = document.createElement('video')
      video.src = window.URL.createObjectURL(stream)
      document.body.appendChild(video)
      video.play()
    })

    inboundConnections[requesterId] = peer
  }

  peer.signal(signal.data)
});

window.initiatePeerConnection = function(user) {
  var peer = new SimplePeer({ initiator: true, stream: window.currentUserStream });

  peer.on('signal', function (data) {
    console.log('Initiate WebRTC connection', data)
    sendMessageToUser(user, "webrtc-connection-requested", { userId: window.userId, data: data })
  })

  peer.on('stream', function (stream) {
    console.log('Stream received #2')
    var video = document.createElement('video')
    video.src = window.URL.createObjectURL(stream)
    document.body.appendChild(video)
    video.play()
  })

  outboundConnections[user] = peer
}

window.connectToUsers = function(users) {
  users.forEach(function(user) { initiatePeerConnection(user) })
}
