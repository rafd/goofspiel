p @bot.name

form method:"post", action:"/compete/#{@bot._id}", ->
  ul ->
    li ->
      label name:'secret'
      input type:'text', name:'secret'
    li ->
      input type:'submit', value:'compete'