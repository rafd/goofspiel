a href: "new", -> "new bot"
table ->
  thead ->
    tr ->
      th "Bot"
      th "(W/L/T)"
  tbody ->
    for bot in @bots
      tr ->
        td ->
          a href: "bot/#{bot._id}", -> bot.name
        td " #{bot.win || 0}/#{bot.lose || 0}/#{bot.tie || 0}"
