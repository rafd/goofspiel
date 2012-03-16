a href: "new", -> "new bot"
table ->
  thead ->
    tr ->
      th "Bot"
      th "Score"
  tbody ->
    for bot in @bots
      tr ->
        td ->
          a href: "bot/#{bot._id}", -> bot.name
        td "sc" 