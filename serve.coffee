require('zappa') ->
  
  @use 'zappa'
  @enable 'default layout'
  
  # ROUTES

  @get '/': ->
    @render 'index'#: {foo: 'bar'}
  @get '/new': 'new'
  @post '/create': 'create'
  @get '/bot/:id': 'bot'
  @get '/game/:id': 'game'


  @coffee '/app.js': ->
    $ =>
      alert('hello')

  @view index: ->
    @scripts = ['/socket.io/socket.io', '/zappa/jquery', '/app']
    @title = 'Inline template'
    h1 @title
    p @foo

  # SOCKET ROUTES
