// Zong Yi, Cheng, 17/03/12


LuckBot = {};




LuckBot.turn = function(turn, card, prev_turn) {
  if(turn==1) {
    this.cheat = new Array();
    this.cheat[0]=[0, 0, 0.05, .031, 0, 0, 0.02, 0, 0, 0, 0.014, 0, 0.01];
    this.cheat[1]=[.414, .227, 0, 0.02, .056, .073, 0, 0.034, 0.047, 0.36, 0, 0.030, 0];
    this.cheat[2]=[.09, .022, .178, .095, .036, .002, 0.069, .021, .002, 0, 0.041, 0, 0.037];
    this.cheat[3]=[.496, .299, .034, .061, .088, .98, 0, 0.054, 0.065, 0.067, 0, 0.056, 0];
    this.cheat[4]=[0, 0.098, .23, .134, .067, 0, .124, .039, 0, 0, 0.08, 0, 0.065];
    this.cheat[5]=[0, .355, 0.092, .107, .124, .185, 0, 0.077, .12, 0.098, 0, .082, 0];
    this.cheat[6]=[0, 0, .274, .175, .101, .002, .168, .06, .001, 0, 0.102, .008, .087];
    this.cheat[7]=[0, 0, 0.139, .154, .165, .218, .021, .103, .142, .138, .016, .099, 0];
    this.cheat[8]=[0, 0, 0, .221, .148, .045, .202, .092, .029, .015, .123, .028, .126];
    this.cheat[9]=[0,0,0,0, .215, .266, 0, .144, .1177, .17, 0, .124, .013];
    this.cheat[10]=[0, 0, 0, 0, 0, .110, .397, .151, 0, .063, .253, .065, 0];
    this.cheat[11]=[0, 0, 0, 0, 0, 0, 0, .226, .417, .241, .023, 0, 0];
    this.cheat[12]=[0, 0, 0, 0, 0, 0, 0, 0, 0, .17, .348, .508, .661];
    this.cards = [1,2,3,4,5,6,7,8,9,10,11,12,13];
    this.theircards = [1,2,3,4,5,6,7,8,9,10,11,12,13];
    document.write("Game on<br />");
    max = 0;
    maxpos = 0;
    
    for(i = 0; i < 13; i++)
    {
      if (this.cheat[i][card-1]>=max)
      {
        max = this.cheat[i][card-1];
        maxpos = i;
      }
    } 
    
    for(i = 0; i < 13; i++)
    {
      this.cheat[maxpos][i] = 0;
    }
    card_to_play= maxpos+1;

  } else {
    
  
    // Update theircards
    if(prev_turn[1] == this.lastcard) opponent = prev_turn[2];
    else opponent = prev_turn[1];
    
    this.theircards = _.without(this.theircards,opponent);  
    
    
    
    max = 0;
    maxpos = 0;
    
    for(i = 0; i < 13; i++)
    {
      if (this.cheat[i][card-1]>=max)
      {
        max = this.cheat[i][card-1];
        maxpos = i;
      }
    } 
    
    
    if (max ==0)
    {
      card_to_play = this.cards[Math.floor(Math.random()*this.cards.length)]; 
    }
    else {
    
    card_to_play= maxpos+1;
    }
    for(i = 0; i < 13; i++)
      {
        this.cheat[card_to_play-1][i] = 0;
      }
    
  }
  
  
  
  
  document.write(card_to_play);
  document.write("<br />");
  document.write(this.cards.join(' '));
  document.write("<br />");
  
  this.cards = _.without(this.cards,card_to_play);
  window.play(card_to_play);
} 

window.BotTurn = LuckBot.turn;
window.BotReady();