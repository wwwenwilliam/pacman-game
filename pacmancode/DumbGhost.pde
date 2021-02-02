class DumbGhost extends Ghost{
  
  DumbGhost(int x, int y, int goalx, int goaly, color c){
    super(x, y, goalx, goaly, c);
  }
  
  void changeDirection(){
    pathFind(8, 6);
    super.changeDirection();
  }
  
}
