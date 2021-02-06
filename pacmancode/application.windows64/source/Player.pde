class Player extends Movable{
  
  int mouth = 90;
  int changeMouth;
  int mouthAngle;
  int score;
  int state = 0; //0-normal, 1-dead
  
  Player() {
    super(7, 12, 8, 12, 5);
    speed = 1;
    direction = true;
  }
  
  //draws player
  void drawPlayer() {
    fill(255, 255, 0);
    if(direction){
      if(speed > 0) {
        mouthAngle = 60;
      } else {
        mouthAngle = 240;
      }
    } else {
      if(speed > 0) {
        mouthAngle = 150;
      } else {
        mouthAngle = 330;
      }
    }
    if(state == 0)
      arc(x_pos, y_pos, 40, 40, radians(mouthAngle - mouth), radians(mouthAngle + 240 + mouth));
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
  
  //turning
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
  
  //eating
  void eatBalls() {
    int x = (int) (x_pos-25)/50;
    int y = (int) (y_pos-25)/50;
    
    score += board.eatScore(x, y);
  }
  
  //combination of fns
  void playerActions() {
    animatePlayer();
    drawPlayer();
    moveEntity();
    eatBalls();
  }
  
  void playerReset(){
    x_pos = 7*50+25;
    y_pos = 12*50+25;
    xtarget = 8;
    ytarget = 12;
    direction = true;
    speed = 1;
    state = 0;
  }
    
  
  
}
