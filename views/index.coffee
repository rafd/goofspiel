script src:"/zappa/jquery.js"
script src:"/tablesorter.js"

coffeescript ->
  $ ->
    $("table").tablesorter({sortList:[[5,1]]});

ul ->
  li -> 
    a href: "new", -> "new bot"
  li ->
    a href: "sample", -> "sample code"

table ->
  thead ->
    tr ->
      th "Bot"
      th "W"
      th "L"
      th "T"
      th "Games"
      th "Score"
  tbody ->
    for bot in @bots
      tr ->
        td ->
          a href: "bot/#{bot._id}", -> bot.name
        td "#{bot.win || 0}"
        td "#{bot.lose || 0}"
        td "#{bot.tie || 0}"
        games_played = (parseInt(bot.win||0,10)+parseInt(bot.lose||0,10)+parseInt(bot.tie||0,10))
        td games_played
        td Math.floor(100*(parseInt(bot.win||0,10)*2 +parseInt(bot.tie||0,10)) / Math.max(25,games_played))
