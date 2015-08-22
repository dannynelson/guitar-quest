Promise = require 'bluebird'
Piece = require 'local_modules/models/piece'

console.log 'Loading fixutres'
Piece.remove({}).then ->
  console.log 'Loading fixutres2'
  Piece.create [
    {
      name: 'Malaguena'
      composer: 'traditional spanish folk song'
      era: 'Contemporary'
      level: 1
      points: 3
      sheetMusicURL: 'http://imslp.org/wiki/Fantasie,_Op.7_(Sor,_Fernando)'
      spotifyURI: 'spotify:track:1gFOPRH492kvYMN19xnMoJ'
      description: 'Meh bespoke Odd Future, sriracha YOLO Pinterest twee +1 semiotics mumblecore XOXO put a bird on it DIY mixtape. Marfa narwhal fap, flexitarian Williamsburg beard gentrify Austin kale chips swag American Apparel cold-pressed freegan.'
    }
    {
      name: 'B minor Study - Op. 35, No. 22'
      composer: 'Fernando Sor'
      era: 'Classical'
      level: 2
      points: 5
      sheetMusicURL: 'http://imslp.org/wiki/Fantasie,_Op.7_(Sor,_Fernando)'
      spotifyURI: 'spotify:track:1gFOPRH492kvYMN19xnMoJ'
      description: 'Meh bespoke Odd Future, sriracha YOLO Pinterest twee +1 semiotics mumblecore XOXO put a bird on it DIY mixtape. Marfa narwhal fap, flexitarian Williamsburg beard gentrify Austin kale chips swag American Apparel cold-pressed freegan.'
    }
    {
      name: 'Adelita (Mazurka)'
      composer: 'Francisco Tarrega'
      era: 'Romantic'
      level: 3
      points: 5
      sheetMusicURL: 'http://imslp.org/wiki/Fantasie,_Op.7_(Sor,_Fernando)'
      spotifyURI: 'spotify:track:1zomhC5U7x5kRuSu10YQ8j'
      description: 'Meh bespoke Odd Future, sriracha YOLO Pinterest twee +1 semiotics mumblecore XOXO put a bird on it DIY mixtape. Marfa narwhal fap, flexitarian Williamsburg beard gentrify Austin kale chips swag American Apparel cold-pressed freegan.'
    }
  ]
