Promise = require 'bluebird'
Piece = require 'local_modules/models/piece'

Piece.remove({}).then ->
  Piece.create [
    {
      _id: "55d8a2696ce78dc3156ca8d0"
      name: 'Malaguena'
      composer: 'Anonymous'
      era: 'contemporary'
      level: 1
      points: 5
      sheetMusicURL: 'http://imslp.org/wiki/Fantasie,_Op.7_(Sor,_Fernando)'
      spotifyURI: 'spotify:track:1gFOPRH492kvYMN19xnMoJ'
      description: 'Meh bespoke Odd Future, sriracha YOLO Pinterest twee +1 semiotics mumblecore XOXO put a bird on it DIY mixtape.'
    }
    {
      _id: "55d8a2696ce78dc3156ca8d1"
      name: 'B minor Study - Op. 35, No. 22'
      composer: 'Fernando Sor'
      era: 'classical'
      level: 1
      points: 6
      sheetMusicURL: 'http://imslp.org/wiki/Fantasie,_Op.7_(Sor,_Fernando)'
      spotifyURI: 'spotify:track:1gFOPRH492kvYMN19xnMoJ'
      description: 'Meh bespoke Odd Future, sriracha YOLO Pinterest twee +1 semiotics mumblecore XOXO put a bird on it DIY mixtape.'
    }
    {
      _id: "55d8a2696ce78dc3156ca8d2"
      name: 'Adelita (Mazurka)'
      composer: 'Francisco Tarrega'
      era: 'romantic'
      level: 2
      points: 10
      sheetMusicURL: 'http://imslp.org/wiki/Fantasie,_Op.7_(Sor,_Fernando)'
      spotifyURI: 'spotify:track:1zomhC5U7x5kRuSu10YQ8j'
      description: 'Meh bespoke Odd Future, sriracha YOLO Pinterest twee +1 semiotics mumblecore XOXO put a bird on it DIY mixtape.'
    }
  ]
