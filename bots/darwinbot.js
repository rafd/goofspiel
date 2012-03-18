//jkl

RandomBot = {};

RandomBot.turn = function(turn, card, prev_turn){
  if(turn === 1){
    this.cards = [[23,1,1,1],[23,4,5,6],[23,7,8,9],[23,10,11,12],[23,13,2,3]];
  }
  card_part = Math.floor((card + 1)/3);
  card_to_play = this.cards[card_part][Math.floor(Math.random()*(this.cards[card_part][0]%20)) + 1];
  
  this.cards[card_part] = _.without(this.cards[card_part],card_to_play);
  this.cards[card_part][0] = this.cards[card_part][0] - 1;

  window.play(card_to_play);
}

window.BotTurn = RandomBot.turn;
window.BotReady();