abstract class Movable{
  //graphical position
  float x_pos;
  float y_pos;
  
  //logical position
  float x;
  float y;
  int xtarget;
  int ytarget;
  
  int speed;
  int factor;
  boolean direction; //true is right/left, false is up/down
  
  Movable(int x, int y, int goalx, int goaly, int newfactor) {
    x_pos = x*50+25;
    y_pos = y*50+25;
    factor = newfactor; //changes speed, can be buggy
    //first square
    xtarget = goalx;
    ytarget = goaly;
  }
  
  abstract void changeDirection();
  
  //wall detection
  boolean isWall(){
    if(direction){
        //check for wall
        if (board.getSquare(xtarget+speed, ytarget) != 2){
          return true;
        }

      } else {
        if (board.getSquare(xtarget, ytarget+speed) != 2){
          return true;
        }
      }
      return false;
  }
  
  
  //straight-line movement
  void moveEntity() {
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
        if (isWall()){
          xtarget += speed;
        }

      } else {
        if (isWall()){
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
  
  
}
