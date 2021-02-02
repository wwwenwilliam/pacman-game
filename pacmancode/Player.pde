class Player{
  
  //graphical position
  float x_pos;
  float y_pos;
  
  //logical position
  float x;
  float y;
  int xtarget = 8;
  int ytarget = 12;
  
  int speed = 1;
  int factor = 5;
  boolean direction = true; //true is right/left, false is up/down
  int mouth = 90;
  int changeMouth;
  
  Player(int x, int y) {
    x_pos = x*50+25;
    y_pos = y*50+25;
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
  
  //straight-line movement
  void movePlayer() {
    x = (x_pos-25)/50;
    y = (y_pos-25)/50;
    //if target is reached, assign new target else move player to target
    if(xtarget == x && ytarget == y) {
      
      changeDirection();
      
      if(direction){
        if(xtarget+speed == 16 || xtarget+speed == -1){ //wraparound
          if(speed > 0) {
            xtarget = 0;
            x_pos = -25;
          } else {
            xtarget = 16;
            x_pos = 825;
          }
        }
        //check for wall
        if (board.getSquare(xtarget+speed, ytarget) != 2){
          xtarget += speed;
        }

      } else {
        if (board.getSquare(xtarget, ytarget+speed) != 2){
          ytarget += speed;
        }
      }
        
     } else {
       if (direction) {
         x_pos += speed*factor;
       } else {
         y_pos += speed*factor;
       }
     }

  }
  
  void changeDirection() {
    if (keyPressed) {
      println(x_pos, y_pos);
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
