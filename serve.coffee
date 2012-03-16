mongoose = require('mongoose')
hash = require('node_hash')

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
  @use @express.bodyParser()
  @enable 'default layout'
  
  # ROUTES

  @get '/': ->
    # db: get all bots
    Bot.find {}, (e, bots) =>
      @render 'index.coffee', {bots: bots}


  @get '/new': ->
    @render 'new.coffee'

  @post '/create': ->
    # db: create bot from params
    bot = new Bot(@body.bot)
    bot.save =>
      @redirect "/bot/#{bot._id}"

  @get '/bot/:id': ->
    # db: get bot
    Bot.findById @params.id, (e, bot) =>
      @render 'bot.coffee', {bot: bot}

  @post '/compete/:id': ->
    # check that body.secret matches bot.secret

    Bot.findById @params.id, (e, bot) =>
      if @body.secret == bot.secret
        @render 'compete.coffee', {bot: bot, scripts: ['/zappa/jquery','/socket.io/socket.io.js','/compete']}
    
  @get '/game/:id': ->
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


  @coffee '/compete.js': ->
    $ =>
      alert('hello')

  # SOCKET ROUTES
