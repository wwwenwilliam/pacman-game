
Board board = new Board();
Player player = new Player();
//Ghost ghost1 = new DumbGhost(8, 6, 8, 3, color(255, 0, 0));
Ghost[] ghosts = {new DumbGhost(8, 6, 8, 3, color(255, 0, 0)), new DumbGhost(7, 6, 8, 6, color(0, 255, 0))};



void setup() {
  size(800, 800);
  frameRate(60);
  noStroke();
  
}


void draw() {
  background(0);
  
  board.drawBoard();
  
  fill(255);
  textAlign(LEFT, TOP);
  textSize(30);
  text(player.score, 15, 10);
  
  player.playerActions();
  
  board.updateBlink();
  
  for(int i=0; i<ghosts.length; i++){
    ghosts[i].drawGhost();
    ghosts[i].moveEntity();
    ghosts[i].checkState();
  }
  
  //should be better encapsulated, might be recoded someday
  //collisions
  if(board.ghostBlink){
    try{
      board.playerCollision(player, ghosts).state = 2;
    } catch (NullPointerException e){
    }
  } else {
    if(board.playerCollision(player, ghosts) != null){
      player.state = 1;
    }
  }

  
  //reset if dead
  if(player.state == 1){
    player.playerReset();
    for(int i=0; i<ghosts.length; i++){
      ghosts[i].ghostReset();
    }
  }

}
