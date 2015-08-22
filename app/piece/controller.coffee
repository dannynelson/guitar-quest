_ = require 'lodash'

module.exports = ngInject (Upload, $http, User, $stateParams, Piece, UserPiece) ->
  @piece = Piece.get({_id: $stateParams.pieceId})
  @comment = undefined
  @userPiece = UserPiece.get({_id: $stateParams.pieceId})
  user = User.getLoggedInUser()

  videoPreview = document.querySelector('video')

  @getSpotifySrc = =>
    "https://embed.spotify.com/?uri=#{@piece.spotifyURI}"

  @fakeUpload = =>
    @userPiece.submissionVideoURL = 'http://youtube.com/'
    @userPiece.status = 'pending'
    @userPiece.$update()
    # ngToast.success 'Thanks! Your video has been submitted. We will review it and give you feedback  within 24 hours.'

  @acceptPiece = =>
    @userPiece.status = 'finished'
    @userPiece.$update()

  @rejectPiece = =>
    @userPiece.status = 'retry'
    @userPiece.$update()

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
          key: "user_#{user._id}/#{fileName}"
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
        @videoUploadSrc = "#{s3Params.bucketURL}/user_#{user._id}/#{fileName}"
        videoPreview.src = @videoUploadSrc
        videoPreview.load()
        console.log('file ' + config.file.name + 'uploaded. Response: ' + data)

        @userPiece.submissionVideoURL = @videoUploadSrc
        @userPiece.status = 'pending'
        @userPiece.$update()
        # ngToast.success 'Thanks! Your video has been submitted. We will review it and give you feedback  within 24 hours.'

      .error (data, status, headers, config) ->
        ngToast.success 'Oops! Something went wrong uploading the video. Please try another file.'
        console.log('error status: ' + status)

  return @ # http://stackoverflow.com/questions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
