_ = require 'lodash'

module.exports = ngInject (Upload, $http, User, $stateParams, Piece) ->
  @piece = Piece.get({_id: $stateParams.pieceId})

  @videoUpload = null

  videoPreview = document.querySelector('video')

  @getSpotifySrc = =>
    "https://embed.spotify.com/?uri=#{@piece.spotifyURI}"

  @upload = (file) =>
    @videoSelected = true
    [fileName, fileSuffix] = file.name.split('.')
    fileName = file.name = "piece_#{@piece._id}.#{fileSuffix}"
    @videoFile = file

    $http.get('/s3_policy?mimeType='+ file.type).then (response) =>
      s3Params = response.data
      Upload.upload
        url: s3Params.bucketURL
        method: 'POST'
        fields:
          key: "user_#{User.getLoggedInUser()._id}/#{fileName}"
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
        @videoUploadSrc = "#{s3Params.bucketURL}/user_#{User.getLoggedInUser()._id}/#{fileName}"
        videoPreview.src = @videoUploadSrc
        videoPreview.load()
        console.log('file ' + config.file.name + 'uploaded. Response: ' + data)
      .error (data, status, headers, config) ->
        console.log('error status: ' + status)

  return @ # http://stackoverflow.com/questions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected