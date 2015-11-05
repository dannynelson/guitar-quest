geomoment = require 'geomoment'
_ = require 'lodash'
level = require 'local_modules/level'
ObjectId = require 'objectid-browser'

module.exports = ngInject (Upload, $http, User, $stateParams, Piece, UserPiece, $state) ->
  @level = level
  @piece = Piece.get({_id: $stateParams.pieceId})
  @comment = undefined
  user = User.getLoggedInUser()

  UserPiece.query({pieceId: $stateParams.pieceId, userId: user._id}).$promise.then (userPieces) =>
    @userPiece =
      if userPieces.length is 0
        new UserPiece
          _id: new ObjectId().toString()
          pieceId: $stateParams.pieceId
          userId: user._id
          status: 'unfinished'
      else
        userPieces[0]

  videoPreview = document.querySelector('video')

  @getTimeFromNow = (date) ->
    geomoment(date).from(new Date())

  @getSpotifySrc = =>
    "https://embed.spotify.com/?uri=#{@piece.spotifyURI}"

  @fakeUpload = =>
    @userPiece.submissionVideoURL = 'https://s3-us-west-2.amazonaws.com/guitar-quest-videos/user_55d1fa38ce020bb5c73854f4/piece_55d4fbd48b6581784392224f.mov'
    @userPiece.status = 'submitted'
    @userPiece.$update()
    # ngToast.success 'Thanks! Your video has been submitted. We will review it and give you feedback  within 24 hours.'

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
        @userPiece.status = 'submitted'
        @userPiece.$update()
        # ngToast.success 'Thanks! Your video has been submitted. We will review it and give you feedback  within 24 hours.'

      .error (data, status, headers, config) ->
        ngToast.success 'Oops! Something went wrong uploading the video. Please try another file.'
        console.log('error status: ' + status)

  return @ # http://stackoverflow.com/questions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
