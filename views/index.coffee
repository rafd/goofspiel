ul ->
  li -> 
    a href: "new", -> "new bot"
  li ->
    a href: "sample", -> "sample code"

table ->
  thead ->
    tr ->
      th "Bot"
      th "(W/L/T)"
      th "Score"
  tbody ->
    for bot in @bots
      tr ->
        td ->
          a href: "bot/#{bot._id}", -> bot.name
        td " #{bot.win || 0}/#{bot.lose || 0}/#{bot.tie || 0}"
        td Math.floor(100*(parseInt(bot.win||0,10)*2 +parseInt(bot.tie||0,10)) / (parseInt(bot.win||0,10)+parseInt(bot.lose||0,10)+parseInt(bot.tie||0,10)))
