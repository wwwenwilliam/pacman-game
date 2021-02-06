class SmartGhost extends Ghost{
  Player player;
  
  SmartGhost(int x, int y, int goalx, int goaly, color c, Player p){
    super(x, y, goalx, goaly, c);
    player = p;
  }
  
  void changeDirection(){
    if(state == 2){
      pathFind(8, 6);
    } else if (state == 1){
      path.clear();
      //random movement
      if(direction){ //@ an intersection
        if(board.getSquare((int)x, (int)y+1) != 2 || board.getSquare((int)x, (int)y-1) != 2){
          randomize();
        }
      } else {
        if(board.getSquare((int)x+1, (int)y) != 2 || board.getSquare((int)x-1, (int)y) != 2){
          randomize();
        }
      }
    } else if(state == 0) {
      pathFind((int)player.x, (int)player.y);
    }
    if(path.size()>1){
      super.changeDirection();
    }
  }
  
  void randomize(){
    boolean olddirection = direction;
    do{
      if(random(0, 1) > 0.5) {
        direction = false;
      } else {
        direction = true;
      }
      
      if(direction != olddirection){ //stops ghost from going back the way it came. Buggy for some reason
        if(random(0, 1) > 0.5){
          speed = 1;
        } else {
          speed = -1;
        }
      }
    } while (!isWall());
     
  }
  
}
