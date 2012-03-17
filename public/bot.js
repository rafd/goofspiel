
/// BEHIND THE SCENES

window.BotReady = function(){
  window.socket = io.connect('http://localhost')

  window.socket.on('connect', function(){
    console.log('player:enter');
    socket.emit('player:enter', window.location.pathname.split('/')[2], function(data){
      console.log(data);
    });
  });

  window.socket.on('game:reveal', function(turn, card, prev_turn) {
      console.log('game:reveal turn:'+turn+' card:'+card+' prev_turn:'+prev_turn)
      window.Bot.turn(turn, card, prev_turn);
  });

  window.play = function(card_to_play){
    console.log('game:play '+card_to_play);
    window.socket.emit('game:play', card_to_play);
  }
}






// RANDOM BOT

RandomBot = {};

RandomBot.turn = function(turn, card, prev_turn){
  if(turn === 1){
    this.cards = [1,2,3,4,5,6,7,8,9,10,11,12,13];
  }

  card_to_play = this.cards[Math.floor(Math.random()*this.cards.length)];
  this.cards = _.without(this.cards,card_to_play);

  window.play(card_to_play);
}

window.Bot = RandomBot;
window.BotReady();

/*
// AT-COST BOT

AtCostBot = {};

AtCostBot.start = function(ack_cb){
  ack_cb();
}

AtCostBot.play = function(prev_turn, card, play_cb){
  card_to_play = card;

  play_cb(card_to_play);
}

AtCostBot.end = function(prev_turn, ack_cb){
  ack_cb();
}

window.Bot = AtCostBot;
window.BotReady();
*/