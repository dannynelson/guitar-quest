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
      type: 'piece'
      reward:
        credit: 15
    }
    {
      userId: userId
      name: 'Complete a tutorial'
      quantityCompleted: 0
      quantityToComplete: 1
      type: 'tutorial'
      reward:
        credit: 15
    }
    {
      userId: userId
      name: 'Schedule a private video lesson'
      quantityCompleted: 0
      quantityToComplete: 1
      type: 'lesson'
      reward:
        credit: 15
    }
  ]
