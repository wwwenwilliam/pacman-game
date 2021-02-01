class Player{
  
  float x_pos;
  float y_pos;
  int direction; //1 is up, 2 is right, etc.
  int mouth = 90;
  int changeMouth;
  
  Player(int x, int y) {
    x_pos = x;
    y_pos = y;
  }
  
  //draws player
  void drawPlayer() {
    fill(255, 255, 0);
    arc(x_pos*50 + 25, y_pos*50 + 25, 40, 40, radians(30 + 30 - mouth), radians(270 + 30 + mouth));
  }
  
  //animates player
  void animatePlayer(){
    if (mouth == 90){
      changeMouth = -10;
    } else if (mouth == 0) {
      changeMouth = 10;
    }
    mouth += changeMouth;
  }
  
  
}
