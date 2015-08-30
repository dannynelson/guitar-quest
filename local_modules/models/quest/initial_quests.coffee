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
      conditions:
        userPiece:
          status: 'pending'
      reward:
        credit: 10
    }
    # {
    #   userId: userId
    #   name: 'Complete a tutorial'
    #   quantityCompleted: 0
    #   quantityToComplete: 1
    #   reward:
    #     credit: 10
    # }
    # {
    #   userId: userId
    #   name: 'Schedule a private video lesson'
    #   quantityCompleted: 0
    #   quantityToComplete: 1
    #   reward:
    #     credit: 10
    # }
  ]
