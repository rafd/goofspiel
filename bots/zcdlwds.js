// ZCDLWDS, 17/03/12

window.BotTurn = function(turn, card, prev_turn){
  window.play([1,2,3,4,8,9,10,11,12,13,5,6,7][card-1]);
};

window.BotReady();