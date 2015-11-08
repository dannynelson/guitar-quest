###
Initial quests to get user accustomed to how the site works. They should show up immediately
when user first creates an account
###

module.exports.generate = (userId) ->
  [
    {
      userId: userId
      name: 'Submit a video for a guitar piece'
      quantityCompleted: 0
      quantityToComplete: 1
      completed: false
      conditions:
        userPiece:
          'submissionVideoURL': {ne: null}
      reward:
        credit: 10
    }
  ]
