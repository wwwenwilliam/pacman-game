class Player extends Movable{
  
  int mouth = 90;
  int changeMouth;
  
  Player(int x, int y) {
    super(x, y, 5);
  }
  
  //draws player
  void drawPlayer() {
    fill(255, 255, 0);
    arc(x_pos, y_pos, 40, 40, radians(30 + 30 - mouth), radians(270 + 30 + mouth));
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
  
  void changeDirection() {
    if (keyPressed) {
      switch(key) {
        case 'd':
          direction = true;
          speed = 1;
          break;
        case 'a':
          direction = true;
          speed = -1;
          break;
        case 'w':
          direction = false;
          speed = -1;
          break;
        case 's':
          direction = false;
          speed = 1;
          break;
      }
    }
  }
    
  
  
}
