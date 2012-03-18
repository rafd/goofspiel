
/// BEHIND THE SCENES

window.BotReady = function(){
  window.socket = io.connect('/', {"reconnect":false})

  window.socket.on('connect', function(){
    console.log('player:enter');
    socket.emit('player:enter', window.location.pathname.split('/')[2], function(data){
      console.log(data);
    });
  });

  window.socket.on('game:reveal', function(turn, card, prev_turn) {
      msg = 'game:reveal turn:'+turn+' card:'+card+' prev_turn:'+prev_turn;
      console.log(msg);
      $("p.log").append('<p>'+msg+'</p>');
      window.BotTurn(turn, card, prev_turn);
  });

  window.play = function(card_to_play){
    msg = 'game:play '+card_to_play
    console.log(msg);
    $("p.log").append('<p>'+msg+'</p>');
      
    window.socket.emit('game:play', card_to_play);
  }
}






// RANDOM BOT

/*

*/

/*
// AT-COST BOT


*/