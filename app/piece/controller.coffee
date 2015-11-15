geomoment = require 'geomoment'
_ = require 'lodash'
level = require 'local_modules/level'
ObjectId = require 'objectid-browser'
userPieceHelpers = require 'local_modules/models/user_piece/helpers'

module.exports = ngInject (Upload, $http, User, $stateParams, Piece, UserPiece, $state) ->
  @level = level
  @piece = Piece.get({_id: $stateParams.pieceId})
  @getStatus = (userPiece) ->
    userPieceHelpers.getStatus(userPiece)
  user = User.getLoggedInUser()

  UserPiece.query({pieceId: $stateParams.pieceId, userId: user._id, $add: ['historyChanges']}).$promise.then (userPieces) =>
    @userPiece =
      if userPieces.length is 0
        new UserPiece
          _id: new ObjectId().toString()
          pieceId: $stateParams.pieceId
          userId: user._id
          status: 'unfinished'
          historyChanges: [] # so that server will return the changes when we first submit a video
      else
        userPieces[0]
    tour.init()
    tour.start()
    loadVideo(@userPiece.submissionVideoURL)

  videoPreview = document.querySelector('video')

  loadVideo = (videoUploadSrc) =>
    videoPreview.src = videoUploadSrc
    videoPreview.load()

  @getSpotifySrc = =>
    "https://embed.spotify.com/?uri=#{@piece.spotifyURI}"

  @upload = (file) =>
    return unless file?
    @uploading = true
    [fileName, fileSuffix] = file.name.split('.')
    fileName = file.name = "piece_#{@piece._id}_#{new ObjectId().toString()}.#{fileSuffix}"

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
        @uploading = false
        videoUploadSrc = "#{s3Params.bucketURL}/user_#{user._id}/#{fileName}"
        @userPiece.submissionVideoURL = videoUploadSrc
        loadVideo(videoUploadSrc)
        console.log('file ' + config.file.name + 'uploaded. Response: ' + data)

        @userPiece.$update()
        # ngToast.success 'Thanks! Your video has been submitted. We will review it and give you feedback  within 24 hours.'

      .error (data, status, headers, config) ->
        @uploading = false
        # ngToast.success 'Oops! Something went wrong uploading the video. Please try another file.'
        console.log('error status: ' + status)

  return @ # http://stackoverflow.com/questions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
