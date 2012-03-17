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
          p "win"
        else if game.tie
          p "tie"
        else
          p "lose"