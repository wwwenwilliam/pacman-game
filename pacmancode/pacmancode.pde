
Board board = new Board();
Player player = new Player(7, 12);



void setup() {
  size(800, 800);
  frameRate(60);
}


void draw() {
  background(0);
  fill(50, 0, 250);
  
  board.drawBoard();
  
  player.animatePlayer();
  player.drawPlayer();
  player.movePlayer();
  
  
}
