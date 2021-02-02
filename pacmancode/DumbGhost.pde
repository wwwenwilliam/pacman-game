class DumbGhost extends Ghost{
  
  DumbGhost(int x, int y, int goalx, int goaly, color c){
    super(x, y, goalx, goaly, c);
  }
  
  void changeDirection(){
    if (keyPressed){
      pathFind(8, 5);
    }
    if(path.size()>1){
      super.changeDirection();
    } else {
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
    }
  }
  
  void randomize(){
    boolean olddirection = direction; //<>//
    do{
      if(random(0, 1) > 0.5) {
        direction = false;
      } else {
        direction = true;
      }
      
      if(direction != olddirection){ //stops ghost from going back the way it came. Buggy for some reason
        println(direction, olddirection);
        if(random(0, 1) > 0.5){
          speed = 1;
        } else {
          speed = -1;
        }
      }
    } while (!isWall());
     
  }
  
}
