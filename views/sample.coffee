h2 "RandomBot"
pre ->
  '''
  RandomBot = {};

  RandomBot.turn = function(turn, card, prev_turn){
    if(turn === 1){
      this.cards = [1,2,3,4,5,6,7,8,9,10,11,12,13];
    }

    card_to_play = this.cards[Math.floor(Math.random()*this.cards.length)];
    this.cards = _.without(this.cards,card_to_play);

    window.play(card_to_play);
  }

  window.BotTurn = RandomBot.turn;
  window.BotReady();
  '''

h2 "AtCostBot"
pre ->
  '''
  AtCostBot = {};

  AtCostBot.turn = function(turn, card, prev_turn){
    card_to_play = card;

    window.play(card_to_play);
  }

  window.BotTurn = AtCostBot.turn;
  window.BotReady();
  '''