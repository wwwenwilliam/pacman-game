abstract class Ghost extends Movable{
  
  color colour;
  ArrayList<int[]> path = new ArrayList<int[]>(); //a path to the start
  int state; //0-normal, 1-blinking, 2-"dead"
  
  Ghost(int x, int y, int goalx, int goaly, color c){
    super(x, y, goalx, goaly, 2);
    colour = c;
    findDirection(x, y, goalx, goaly);
  }
  
  //finds direction/speed based on goal
  void findDirection(int x, int y, int goalx, int goaly){
    if(goalx == x){
      direction = false;
      if(goaly > y){
        speed = 1;
      } else {
        speed = -1;
      }
    } else if (goaly == y){
      direction = true;
      if(goalx > x){
        speed = 1;
      } else {
        speed = -1;
      }
    }
  }
  
  void changeDirection(){
    findDirection((int)x, (int)y, path.get(0)[0], path.get(0)[1]);
    path.remove(0);
  }
  
  
  void pathFind(int goalx, int goaly){ //somewhat flawed
    Pathfinding finder = new Pathfinding();
    
    path = finder.findPath((int)x, (int)y, goalx, goaly);
  }
       
  
  void drawGhost(){
    if(board.ghostBlink){
      fill(50, 0, 255);
    } else {
      fill(colour);
    }
    
    if(state != 2){
      arc(x_pos, y_pos +5, 40, 40, PI, TWO_PI);
      rect(x_pos-20, y_pos +5, 40, 5);
      triangle(x_pos-15-10+5, y_pos+10, x_pos-5-10+5, y_pos+10, x_pos-15-10+5, y_pos+15+10);
      triangle(x_pos-15+10-10+5, y_pos+10, x_pos-5+10-10+5, y_pos+10, x_pos+5-10+5, y_pos+15+10);
      triangle(x_pos-15+20-10+5, y_pos+10, x_pos-5+20-10+5, y_pos+10, x_pos-15+20-10+5, y_pos+15+10);
      triangle(x_pos-15+10+10+5, y_pos+10, x_pos-5+10+10+5, y_pos+10, x_pos+5+10+5, y_pos+15+10);
    }
    fill(255);
    circle(x_pos-8, y_pos, 10);
    circle(x_pos+8, y_pos, 10);
    fill(0, 0, 255);
    circle(x_pos-9, y_pos+2, 3);
    circle(x_pos+7, y_pos+2, 3);
  }
  
  void ghostReset(){
    x_pos = 8*50+25;
    y_pos = 6*50+25;
    direction = false;
    speed = -1;
    //first square
    xtarget = 8;
    ytarget = 3;
  }
  
  void checkState(){
    if(!board.ghostBlink){
      if(state == 1){
        state = 0;
        factor = 2;
      }
    } else {
      if(state == 2){
      factor = 2;
      }
    }
    if(state == 2 && (int)x == 8 && (int)y == 6){
      state = 0;
      factor = 2;
     }
  }
  
  
}
