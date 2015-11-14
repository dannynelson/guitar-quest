module.exports = __filename
angular.module __filename, []

.factory 'tour', ngInject ->
  tour = new Tour
    template: require './template'
    steps: [
      {
        path: '/#/pieces'
        element: ".gq-navbar",
        placement: 'bottom'
        title: "Welcome to GuitarQuest!",
        # maybe clarify goal of game
        content: "GuitarQuest is an online game for learning to play classical guitar music."
      },
      {
        path: '/#/pieces'
        element: ".gq-navbar .pieces"
        placement: 'bottom'
        title: "Pieces Page",
        content: "In the Pieces section, you will find a collection of classical guitar pieces that you can learn."
      },
      {
        path: '/#/pieces'
        element: ".guitar-quest-pieces .user-level",
        placement: 'right'
        title: "Piece Level",
        content: "Pieces are graded by difficulty. Right now, you are viewing all Level 1 pieces."
      }
      {
        path: '/#/pieces'
        element: ".guitar-quest-pieces .piece:nth-child(1) .piece-points",
        title: "Piece Points",
        content: "For each piece that you learn, you will earn points."
      }
      {
        path: '/#/pieces'
        element: ".guitar-quest-pieces .points-to-next-level",
        placement: 'left'
        title: "Points to Next Level",
        content: "Once you earn enough points, you will progress to the next level and unlock new, more challenging pieces."
      }
      {
        path: '/#/pieces/55d8a2696ce78dc3156ca8d0'
        element: ".guitar-quest-piece .composer",
        placement: 'right'
        title: "Piece Page",
        content: "This page contains all the information you need to learn each piece."
      }
      {
        path: '/#/pieces/55d8a2696ce78dc3156ca8d0'
        element: ".guitar-quest-piece .buy-sheet-music-panel",
        placement: 'left'
        title: "Buy the Sheet Music",
        content: "You can buy the sheet music here. You only need to buy one music book for each GuitarQuest level."
      }
      {
        path: '/#/pieces/55d8a2696ce78dc3156ca8d0'
        element: ".guitar-quest-piece .upload-video",
        placement: 'bottom'
        title: "Submit a Video",
        content: "Once you learn the music, click here to submit a video of you playing the piece."
      }
      {
        path: '/#/pieces/55d8a2696ce78dc3156ca8d0'
        element: ".guitar-quest-piece .points-to-next-level",
        placement: 'left'
        title: "Earn Points",
        content: "A teacher will then grade your video, give you written feedback, and you will earn points."
      }
      {
        path: '/#/quests'
        element: ".gq-navbar .quests",
        placement: 'bottom'
        title: "Quests Page",
        content: "This page shows all of your active quests."
      }
      {
        path: '/#/quests'
        element: ".guitar-quest-quests .quest:nth-child(1)",
        placement: 'right'
        title: "Completing Quest",
        content: "Each quest consists of a challenge and a reward."
      }
      {
        path: '/#/quests'
        element: ".guitar-quest-quests .quest:nth-child(1) .reward-icon",
        placement: 'right'
        title: "Earn Lesson Credits",
        content: "You can use the credits that you earn from quests for buying private lessons with a GuitarQuest teacher."
      }
      {
        path: '/#/pieces'
        element: ".guitar-quest-pieces .piece:nth-child(2)",
        placement: 'left'
        title: "Let's get started!",
        content: "Click any piece to start learning..."
      }
    ]

  return tour
