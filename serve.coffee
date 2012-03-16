mongoose = require('mongoose')

db = mongoose.connect(process.env.MONGOLAB_URI || 'mongodb://localhost/goofspiel')

Bot = db.model 'Bot', new mongoose.Schema
  name: String
  secret: String
  code: String

Turn = new mongoose.Schema
  num: Number
  p1: Number
  p2: Number

Game = db.model 'Game', new mongoose.Schema
  p1: mongoose.Schema.ObjectId
  p2: mongoose.Schema.ObjectId
  turns: [Turn]

require('zappa') ->
  
  @use 'zappa'
  @enable 'default layout'
  
  # ROUTES

  @get '/': ->
    # db: get all bots
    Bot.find {}, (e, bots) =>
      @render 'index.coffee', {bots: bots}


  @get '/new': 'new'

  @post '/create': 'create'
    # db: create bot from params

  @get '/bot/:id': ->
    # db: get bot
    Bot.findById @params.id, (e, bot) =>
      @render 'bot.coffee', {bot: bot}
    

  @get '/game/:id': 'game'
    # db: get game
    Game.findById @params.id, (e, game) =>
      @render 'game.coffee', {game: game}

  @get '/seed': ->
    # create a bunch of bots and games
    
    for num in [1..10]
      bot = new Bot
        name: Math.floor(Math.random()*1000)
        secret: Math.floor(Math.random()*1000)
      bot.save()
      #game = new Game

    @redirect '/'


  @coffee '/app.js': ->
    $ =>
      alert('hello')

  # SOCKET ROUTES
