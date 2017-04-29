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

// Now that you are connected, you can join channels with a topic:
window.channel = socket.channel("room:lobby", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

window.userId = Math.random().toString(36).substring(7)
let localStream, peerConnection
const localVideo = document.getElementById('localVideo')
const remoteVideo = document.getElementById('remoteVideo')
// let room_1 = document.getElementById("room_1");
// let room_2 = document.getElementById("room_2");
// let leave_all = document.getElementById("leave_all");

const mediaConstraints = { video: true }

function connect() {
  console.log("Requesting local stream")
  navigator.mediaDevices.getUserMedia(mediaConstraints)
                        .then(bindLocalStream)
                        .then(setupPeerConnection)
                        .catch(logError)
}

window.connect = connect

function bindLocalStream(stream) {
  console.log("Bind local stream to DOM")
  localVideo.src = URL.createObjectURL(stream)
  localVideo.srcObject = stream
  return stream
}

function setupPeerConnection(stream) {
  const servers = {
    "iceServers": [{
      "url": "stun:stun.l.google.com:19302"
    }]
  };

  peerConnection = new RTCPeerConnection(servers);
  console.log("Created local peer connection");
  peerConnection.onicecandidate = handleICECandidateEvent
  peerConnection.onaddstream = handleAddStreamEvent
  peerConnection.ontrack = handleTrackEvent
  peerConnection.addStream(stream)
  console.log("Added localStream to localPeerConnection");
}

function handleICECandidateEvent(event) {
  if (event.candidate) {
    sendToServer({
      type: "new-ice-candidate",
      candidate: event.candidate
    });
  }
}

function call() {
  console.log("Starting call");
  peerConnection.createOffer()
                .then(offer => peerConnection.setLocalDescription(offer))
                .then(function() {
                  var msg = {
                    type: 'offer',
                    sdp: peerConnection.localDescription
                  };

                  sendToServer(msg);
                })
                .catch(logError)
}

window.call = call

function sendToServer(message) {
  channel.push("message", { body: JSON.stringify(message) })
}

function logError(error) {
  console.log(error.name + ": " + error.message);
}

function handleOffer(message) {
  const servers = {
    "iceServers": [{
      "url": "stun:stun.l.google.com:19302"
    }]
  };

  peerConnection = new RTCPeerConnection(servers);
  peerConnection.onicecandidate = handleICECandidateEvent
  peerConnection.onaddstream = handleAddStreamEvent
  peerConnection.ontrack = handleTrackEvent

  peerConnection.setRemoteDescription(new RTCSessionDescription(message.sdp)).then(function () {
    return navigator.mediaDevices.getUserMedia(mediaConstraints);
  })
  .then(function(stream) {
    localStream = stream;

    localVideo.src = URL.createObjectURL(stream);
    localVideo.srcObject = stream
    return peerConnection.addStream(localStream);
  })
  .then(function() {
    return peerConnection.createAnswer();
  })
  .then(function(answer) {
    return peerConnection.setLocalDescription(answer);
  })
  .then(function() {
    var msg = {
      type: 'answer',
      sdp: peerConnection.localDescription
    };

    sendToServer(msg);
  })
  .catch(logError);
}

function handleNewICECandidateMsg(msg) {
  var candidate = new RTCIceCandidate(msg.candidate);

  peerConnection.addIceCandidate(candidate).catch(logError);
}

// function handleAnswer(message) { console.log("Handle answer") }

function handleAddStreamEvent(event) {
  console.log(event)
  peerConnection.addStream(event.stream)
  remoteVideo.src = URL.createObjectURL(event.stream)
  // remoteVideo.srcObject = event.stream
  console.log('handleAddStreamEvent')
}

function handleTrackEvent(event) {
  console.log('handleTrackEvent')
}

channel.on("message", payload => {
  let message = JSON.parse(payload.body);

  switch (message.type) {
    case 'offer': {
      handleOffer(message)
      break
    }
    // case 'answer': {
    //   handleAnswer(message)
    //   break
    // }
    case 'new-ice-candidate': {
      handleNewICECandidateMsg(message)
      break
    }
    default: break
  }
})

// connect()

// let room_1_connections = {};
// let room_2_connections = {};

// let current_room = 0;

// function leave_room_1(userId) {
//   leave_room(room_1_connections, userId);
// }

// function leave_room_2(userId) {
//   leave_room(room_2_connections, userId);
// }

// function leave_room(room_connections, userId) {
//   room_connections[userId].close();
//   room_connections[userId] = null;

//   return null;
// }

// function enter_room_1(userId) {
//   if (current_room == 1) {
//     return;
//   }

//   if (current_room == 2) {
//     leave_room_2(userId);
//   }

//   current_room = 1;
//   enter_room(room_1_connections, userId);
// }

// function enter_room_2(userId) {
//   if (current_room == 2) {
//     return;
//   }

//   if (current_room == 1) {
//     leave_room_1(userId);
//   }

//   current_room = 2;
//   enter_room(room_2_connections, userId);
// }

// function enter_room(room_connections, userId) {
//   if (room_connections[userId]) {
//     return;
//   }

//   let servers = {
//     'iceServers': [{
//       'url': 'stun:stun.example.org'
//     }]
//   };

//   // TODO: create a video object here
//   let remoteVideo = document.createElement('video');
//   remoteVideo.autoPlay = true;

//   peerConnection = new RTCPeerConnection(servers);
//   console.log("Created local peer connection");
//   peerConnection.onicecandidate = function gotLocalIceCandidate(event) {
//     if (event.candidate) {
//       console.log("Local ICE candidate: \n" + event.candidate);
//       channel.push("ping", {body: JSON.stringify({
//             'candidate': event.candidate
//             })});
//     }
//   };
//   peerConnection.onaddstream = function gotRemoteStream(event) {
//     remoteVideo.src = URL.createObjectURL(event.stream);
//     console.log("Received remote stream");
//   };

//   peerConnection.addStream(localStream);
//   console.log("Added localStream to localPeerConnection");

//   room_connections[userId] = peerConnection;

//   navigator.getUserMedia({audio:true, video:true}, gotStreamAudioVideo, error => {
//     console.log("getUserMedia error: ", error);
//   });
// }


// function handleError(error) {
//   console.log(error.name + ': ' + error.message);
// }

// function gotRemoteStream(event) {
//   remoteVideo.src = URL.createObjectURL(event.stream);
//   console.log("Received remote stream", remoteVideo.src);
// }

// function gotLocalIceCandidate(event) {
//   if (event.candidate) {
//     console.log("Local ICE candidate: \n" + event.candidate.candidate);
//     channel.push("ping", {body: JSON.stringify({
//           'candidate': event.candidate
//           })});
//   }
// }

// function gotRemoteIceCandidate(event) {
//   callButton.disabled = true;
//   if (event.candidate) {
//     peerConnection.addIceCandidate(new RTCIceCandidate(event.candidate));
//     console.log("Remote ICE candidate: \n " + event.candidate.candidate);
//   }
// }


// channel.on("member_enter_room", function(payload) {
//   let room_number = payload.room_number;
//   let user_id = payload.user_id;

//   if (room_number == 1) {
//     enter_room_1(user_id);
//   }
//   else {
//     enter_room_2(user_id);
//   }
// })

// channel.on("member_leave_room", function(payload) {
//   let room_number = payload.room_number;
//   let user_id = payload.user_id;

//   if (room_number == 1) {
//     leave_room_1(user_id);
//   }
//   else {
//     leave_room_2(user_id);
//   }
// })

// channel.on("ping", payload => {
//   let message = JSON.parse(payload.body);
//   if (message.sdp) {
//     gotRemoteDescription(message);
//   } else {
//     gotRemoteIceCandidate(message);
//   }
// })
