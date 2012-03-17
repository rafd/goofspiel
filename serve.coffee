mongoose = require('mongoose')
hash = require('node_hash')
_ = require('underscore')

db = mongoose.connect(process.env.MONGOLAB_URI || 'mongodb://localhost/goofspiel')

Bot = db.model 'Bot', new mongoose.Schema
  name: String
  secret: String
  code: String
  win: {}
  lose: {}
  tie: {}

Game = db.model 'Game', new mongoose.Schema
  players: []
  bots: []
  player_bots: {}
  turn: Number
  turns: [{}]
  cards: []
  prev_turn: {}
  reveal: Number
  submitted_moves: []
  active: Boolean
  bids: {}
  scores: {}
  win: {}
  lose: {}
  tie: {}

require('zappa') ->
  
  @use 'zappa'
  @use @express.bodyParser()
  @use @express.static(__dirname + '/public')
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
      Game.find {bots : @params.id}, (e, games) =>
        @render 'bot.coffee', {bot: bot, games: games, e: e}

  @post '/compete/:id': ->
    # check that body.secret matches bot.secret

    Bot.findById @params.id, (e, bot) =>
      if @body.secret == bot.secret
        @render 'compete.coffee', {bot: bot, scripts: ['/zappa/jquery','/socket.io/socket.io.js','/underscore','/bot']}
    
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

  PLAYERS = {}

  GAMES = {}

  AVAILABLE =
    data: {}
    length: 0
    add: (id)->
      unless @data[id]
        @data[id] = true
        @length += 1
    remove: (id)->
      if @data[id]
        delete @data[id]
        @length -= 1
    popRandom: ->
      key = _.keys(@data)[Math.floor(Math.random()*@length)]
      @remove(key)
      return key

  @io.sockets.on 'connection', (socket) ->

    socket.on 'player:enter', (id, fn) ->
      console.log "welcome player #{@id}"

      PLAYERS[@id] =
        socket: socket
        id: id
        game: null
      
      AVAILABLE.add(@id)


    socket.on 'disconnect', () ->
      console.log "goodbye player #{@id}"
      #TODO: forfeit the game
      id = @id
      Game.findById PLAYERS[@id].game, (err,game)->
        end_game(game, id) if game

      AVAILABLE.remove(@id)
      delete PLAYERS[@id]

    socket.on 'game:play', (card) ->
      id = @id
      
      console.log('move received for player '+id)
      
      # figure out which game the player is in
      Game.findById PLAYERS[id].game, (err, game) ->
        if game
          console.log('game found for player '+id)
          # TODO: if move is invalid
          if false
            # TODO: forfeit
          # else
          else
            # add to turns
            a = {}
            a[id] = card

            Game.update {_id:game._id}, { $push: { submitted_moves : a }}, {}, (e, num) ->
              console.log "#{num} updated"


  matchmake = ->
    console.log 'matchmaking'

    if AVAILABLE.length >= 2
      start_game(AVAILABLE.popRandom(),AVAILABLE.popRandom())
    else
      console.log 'not enough players to matchmake'

    
    setTimeout matchmake, 1000

  matchmake()

  check_games = ->
    console.log 'checking games'

    Game.find {submitted_moves : { $size : 2 }, turn : { $lt : 14}, active : true}, (err, games) ->
      for game, state in games
        if GAMES[game._id]
          resolve_turn(game)
      setTimeout check_games, 1000

  check_games()

  start_game = (p1,p2) ->
    console.log 'creating game'
    game = new Game
      players: [p1, p2]
      bots: [PLAYERS[p1].id, PLAYERS[p2].id]
      player_bots: {}
      turn: 0
      cards: [1,2,3,4,5,6,7,8,9,10,11,12,13]
      active: true
      forfeit: null
      bids: {}
      scores: {}

    game.bids[p1] = 0
    game.bids[p2] = 0

    game.scores[p1] = 0
    game.scores[p2] = 0

    game.player_bots[p1] = PLAYERS[p1].id
    game.player_bots[p2] = PLAYERS[p2].id

    console.log 'saving game'

    PLAYERS[p1].game = game._id
    PLAYERS[p2].game = game._id

    GAMES[game._id] = true
    
    game.save ->
      next_turn(game)

  next_turn = (game) ->
    console.log('next turn for '+game._id)

    # if turn == 13, end game
    if game.turn >= 13
      end_game(game)
    else
      # choose a card
      card = game.cards[Math.floor(Math.random()*game.cards.length)]
      turn = game.turn + 1
      prev_turn = game.prev_turn

      # remove the card & increment turn
      Game.update {_id:game._id}, { $inc: { turn : 1 }, $pull: { cards : card }, $set: {reveal:card}}, {}, (e, num) ->
        console.log "#{num} updated"

        # broadcast
        console.log 'broadcasting reveal'
        PLAYERS[game.players[0]].socket.emit 'game:reveal', turn, card, prev_turn
        PLAYERS[game.players[1]].socket.emit 'game:reveal', turn, card, prev_turn

      

  resolve_turn = (game) ->
    console.log 'resolving turn'
    #, reveal: game.reveal, cards: game.submitted_moves}
    a = {}
    a.turn = 0+game.turn
    a.reveal = 0+game.reveal
    a.cards = _.extend(game.submitted_moves[0],game.submitted_moves[1])
    game.prev_turn = a
    
    game.bids[game.players[0]] += a.cards[game.players[0]]
    game.bids[game.players[1]] += a.cards[game.players[1]]

    if a.cards[game.players[0]] > a.cards[game.players[1]]
      game.scores[game.players[0]] += a.reveal
    else if a.cards[game.players[1]] > a.cards[game.players[0]]
      game.scores[game.players[1]] += a.reveal

    bids = _.clone game.bids
    scores = _.clone game.scores

    Game.update {_id:game._id}, { $set: {submitted_moves: [], bids: bids, scores: scores }}, {}, ()->
      console.log 'storing turn' 

      Game.update {_id:game._id}, {$push: {turns: a}}, {}, (err, num)->
        console.log err
        console.log num
        next_turn(game)


  end_game = (game, forfeit) ->
    console.log "end game #{game._id}"

    forfeit = forfeit || null
    # TODO: determine winner and store winner
    Game.update {_id:game._id}, {$set : {submitted_moves : [], active: false, forfeit: forfeit}}, {}, (err, num)->
      console.log num

    # CALCULATE RESULT

    win = null
    lose = null
    tie = null
    cheat = null

    if forfeit
      win = game.player_bots[_.without(game.players, forfeit)[0]]
      lose = game.player_bots[forfeit] 
    else if game.bids[game.players[0]] != 91
      win = game.player_bots[game.players[1]]
      lose = game.player_bots[game.players[0]]
      cheat = game.player_bots[game.players[0]]
    else if game.bids[game.players[1]] != 91
      win = game.player_bots[game.players[0]]
      lose = game.player_bots[game.players[1]]
      cheat = game.player_bots[game.players[1]]
    else
      if game.scores[game.players[0]] > game.scores[game.players[1]]
        win = game.player_bots[game.players[0]]
        lose = game.player_bots[game.players[1]]
      else if game.scores[game.players[1]] > game.scores[game.players[0]]
        win = game.player_bots[game.players[1]]
        lose = game.player_bots[game.players[0]]
      else
        tie = true

    Game.update {_id:game._id}, {$set : {win : win, lose: lose, tie: tie, cheat: cheat}}, {}, (err, num)->
      console.log num

    if tie
      Bot.update {_id:game.player_bots[game.players[1]]}, {$inc : {tie : 1}}, {}, (err,num) ->
        console.log num
      Bot.update {_id:game.player_bots[game.players[0]]}, {$inc : {tie : 1}}, {}, (err,num) ->
        console.log num
    else
      Bot.update {_id:win}, {$inc : {win : 1}}, {}, (err,num) ->
        console.log num

      Bot.update {_id:lose}, {$inc : {lose: 1}}, {}, (err,num) ->
        console.log num



    # CLEAN UP

    delete GAMES[game._id]

    PLAYERS[game.players[0]].game = null if PLAYERS[game.players[0]]
    PLAYERS[game.players[1]].game = null if PLAYERS[game.players[1]]

    AVAILABLE.add(game.players[0]) if PLAYERS[game.players[0]]
    AVAILABLE.add(game.players[1]) if PLAYERS[game.players[1]]
