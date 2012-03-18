// Fraser + Pawel, 17/03/12

window.BotTurn = function(turn, card, prev_turn){
  window.play([1,2,3,5,6,7,8,12,13,11,4,9,10][card-1]);
};

window.BotReady();