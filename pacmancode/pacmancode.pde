
Board board = new Board();
Player player = new Player();
//Ghost ghost1 = new DumbGhost(8, 6, 8, 3, color(255, 0, 0));
Ghost ghost1 = new DumbGhost(1, 1, 1, 2, color(255, 0, 0));



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
  
  
  ghost1.drawGhost();
  ghost1.moveEntity();
  
  
}
