_ = require 'lodash'

module.exports = ngInject ->
  @max = 100
  @dynamic = 20

  video = document.querySelector('video')

  mediaStream = null

  @stopVideo = ->
    console.log 'STOPPING'
    video?.pause()
    mediaStream?.stop()

  @replayVideo = ->
    video?.play()

  @getVideo = ->
    navigator.getUserMedia  = navigator.getUserMedia or navigator.webkitGetUserMedia or navigator.mozGetUserMedia or navigator.msGetUserMedia


    if navigator.getUserMedia
      navigator.getUserMedia {audio: true, video: true}, (stream) ->
        mediaStream = stream
        video.src = window.URL.createObjectURL(stream)
        video.muted = true
        video.controls = false
        video.play()
      , (err) ->
        console.log err
    # } else {
    #   video.src = 'somevideo.webm'; // fallback.
    # }

  return @ # http://stackoverflow.com/challengeions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
