p @bot.name + " #{@bot.win || 0}/#{@bot.lose || 0}/#{@bot.tie || 0} (W/L/T)"



form method:"post", action:"/compete/#{@bot._id}", ->
  ul ->
    li ->
      label name:'secret'
      input type:'text', name:'secret'
    li ->
      input type:'submit', value:'compete'


ul ->
  for game in @games
    li -> 
      a href: "/game/#{game._id}", ->
        if "#{@bot._id}" == "#{game.win}"
          "win"
        else if game.tie
          "tie"
        else
          "lose"

      span -> " vs "

      if ""+game.bots[0] != ""+@bot._id
        a href: "/bot/#{game.bots[0]}", -> game.bots[0]
      if ""+game.bots[1] != ""+@bot._id
        a href: "/bot/#{game.bots[1]}", -> game.bots[1]
      