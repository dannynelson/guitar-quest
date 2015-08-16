_ = require 'lodash'

module.exports = ngInject (Upload, $http, User) ->
  @max = 100
  @dynamic = 20
  @videoUpload = null

  videoPreview = document.querySelector('video')
  # video = document.querySelector('video')
  videoPreview.src = 'https://guitar-quest-videos.s3-us-west-1.amazonaws.com/user_55ce24317b49a46ce46971e3/test-video.mov'
  videoPreview.load()

  mediaStream = null

  @upload = (file) =>
    @videoSelected = true
    @videoFile = file
    $http.get('/s3_policy?mimeType='+ file.type).then (response) =>
      s3Params = response.data
      Upload.upload
        url: 'https://guitar-quest-videos.s3-us-west-1.amazonaws.com/'
        method: 'POST'
        fields:
          key: "user_#{User.getLoggedInUser()._id}/#{file.name}"
          AWSAccessKeyId: s3Params.AWSAccessKeyId
          acl: 'public-read'
          policy: s3Params.policy
          signature: s3Params.signature
          "Content-Type": if file.type isnt '' then file.type else 'application/octet-stream'
        file: file
      .progress (evt) =>
        @progressPercentage = progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
        console.log('progress: ' + progressPercentage + '% ' + evt.config.file.name)
      .success (data, status, headers, config) =>
        @videoUploadSrc = "https://guitar-quest-videos.s3-us-west-1.amazonaws.com/user_#{User.getLoggedInUser()._id}/#{file.name}"
        videoPreview.src = @videoUploadSrc
        videoPreview.load()

        console.log('file ' + config.file.name + 'uploaded. Response: ' + data)
      .error (data, status, headers, config) ->
        console.log('error status: ' + status)

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

  return @ # http://stackoverflow.com/questions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
