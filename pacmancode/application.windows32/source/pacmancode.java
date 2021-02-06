import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class pacmancode extends PApplet {


Board board = new Board();
Player player = new Player();
Ghost[] ghosts = {new DumbGhost(8, 6, 8, 3, color(255, 0, 0)), new DumbGhost(7, 6, 8, 6, color(0, 255, 0))};



public void setup() {
  
  frameRate(60);
  noStroke();
  
}


public void draw() {
  background(0);
  
  board.drawBoard();
  
  fill(255);
  textAlign(LEFT, TOP);
  textSize(30);
  text(player.score, 15, 10);
  
  player.playerActions();
  
  board.updateBlink();
  
  for(int i=0; i<ghosts.length; i++){
    ghosts[i].drawGhost();
    ghosts[i].moveEntity();
    ghosts[i].checkState();
  }
  
  //should be better encapsulated, might be recoded someday
  //collisions
  if(board.ghostBlink){
    try{
      board.playerCollision(player, ghosts).state = 2;
    } catch (NullPointerException e){
    }
  } else {
    if(board.playerCollision(player, ghosts) != null){
      player.state = 1;
    }
  }

  
  //reset if dead
  if(player.state == 1){
    player.playerReset();
    for(int i=0; i<ghosts.length; i++){
      ghosts[i].ghostReset();
    }
  }
  
  //check for win
  if(board.checkForWin()){
    //win thing goes here
    println("winning works");
  }

}
class DumbGhost extends Ghost{
  
  DumbGhost(int x, int y, int goalx, int goaly, int c){
    super(x, y, goalx, goaly, c);
  }
  
  public void changeDirection(){
    if(state == 2){
      pathFind(8, 6);
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
  
  public void randomize(){
    boolean olddirection = direction;
    do{
      if(random(0, 1) > 0.5f) {
        direction = false;
      } else {
        direction = true;
      }
      
      if(direction != olddirection){ //stops ghost from going back the way it came. Buggy for some reason
        if(random(0, 1) > 0.5f){
          speed = 1;
        } else {
          speed = -1;
        }
      }
    } while (!isWall());
     
  }
  
}
abstract class Ghost extends Movable{
  
  int colour;
  ArrayList<int[]> path = new ArrayList<int[]>(); //a path to the start
  int state; //0-normal, 1-blinking, 2-"dead"
  
  Ghost(int x, int y, int goalx, int goaly, int c){
    super(x, y, goalx, goaly, 2);
    colour = c;
    findDirection(x, y, goalx, goaly);
  }
  
  //finds direction/speed based on goal
  public void findDirection(int x, int y, int goalx, int goaly){
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
  
  public void changeDirection(){
    findDirection((int)x, (int)y, path.get(0)[0], path.get(0)[1]);
    path.remove(0);
  }
  
  
  public void pathFind(int goalx, int goaly){ //somewhat flawed
    Pathfinding finder = new Pathfinding();
    
    path = finder.findPath((int)x, (int)y, goalx, goaly);
  }
       
  
  public void drawGhost(){
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
  
  public void ghostReset(){
    x_pos = 8*50+25;
    y_pos = 6*50+25;
    direction = false;
    speed = -1;
    //first square
    xtarget = 8;
    ytarget = 3;
  }
  
  public void checkState(){
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
  
  public abstract void changeDirection();
  
  //wall detection
  public boolean isWall(){
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
  public void moveEntity() {
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
class Pathfinding{
  ArrayList<Square> squares;
  
  
  public ArrayList<int[]> findPath(int x1, int y1, int x2, int y2){
    squares = allSquares(board.walls);
    Square start = new Square(-1, -1);
    Square end = new Square(-1, -1);
    ArrayList<Square> path;
    
    for(Square square : squares){
      if(square.x == x1 && square.y == y1){
        end = square;
      }
      if(square.x == x2 && square.y == y2){
        start = square;
      }
    } 
    
    Graph squareGraph = new Graph(squares);
    System.out.println(squareGraph.findShortestPath(start, end));
    path = squareGraph.findShortestPath(start, end);
    ArrayList<int[]> outs = new ArrayList();
    for(int i=0; i<path.size(); i++){
      outs.add(new int[2]);
      outs.get(i)[0] = path.get(i).x;
      outs.get(i)[1] = path.get(i).y;
    }
    return outs;
  }

  
  public ArrayList<Square> allSquares(int[][] grid){
    ArrayList<Square> squares = new ArrayList();
    for (int i=0; i<16; i++) {
      for(int j=0; j<16; j++) {
        if(grid[i][j] != 2) {
          squares.add(new Square(j, i)); //has to be flipped cuz grid was flipped
        }
      }
    }
    return squares;
  }
}

class Square{
  //equivalent to a node
  int x;
  int y;
  
  Square(int x, int y){
    this.x = x;
    this.y = y;
  }
  
  public String toString() { //debug purposes
    return x +" "+ y;
  }
  
  public boolean isConnected(Square square) {
    if (square.x == x+1 && square.y == y) {
      return true;
    } else if (square.x == x-1 && square.y == y) {
      return true;
    } else if (square.x == x && square.y == y+1) {
      return true;
    } else if (square.x == x && square.y == y-1) {
      return true;
    }
    return false;
  }
  
}

class Graph{
  HashMap<Square, ArrayList> graphDict = new HashMap();
  HashMap<Square, Integer> distanceMap = new HashMap();
  HashMap<Square, Square> preMap = new HashMap();
  
  Graph(ArrayList<Square> squareList){
    
    for (Square i : squareList) {
      graphDict.put(i, new ArrayList<Square>());
    }
    
    //adjacency list
    for (Square square : squareList) { //could be optimized
      for(Square inner : squareList) {
        if (square.isConnected(inner)) {
          graphDict.get(square).add(inner);
        }
      }
    }
  }
  
  public void bfs(Square start) {  //i think this is bfs  
    ArrayList<Square> visited = new ArrayList();
    ArrayList<Square> queue = new ArrayList(); 
    ArrayList<Square> queue2 = new ArrayList();
    
    distanceMap.put(start, 0);
    queue.add(start);
    visited.add(start);
    
    Square current;
    Square currentAdjSquare;
    ArrayList<Square> adjSquares;
    int distance = 1;
    
    while(queue.size() > 0 || queue2.size() > 0) {
      current = queue.get(0);
      queue.remove(0);
      adjSquares = graphDict.get(current);
      
      for(int i=0; i<adjSquares.size(); i++) {
        currentAdjSquare = adjSquares.get(i);
        if(!visited.contains(currentAdjSquare)) {
          visited.add(currentAdjSquare);
          distanceMap.put(currentAdjSquare, distance);
          preMap.put(currentAdjSquare, current);
          
          queue2.add(currentAdjSquare);
        }
      }
      
      if(queue.size() == 0) {//finish all squares at one level before moving onto the next
        queue.addAll(queue2);
        queue2.clear();
        distance++;
      }
    }
  }
  
  public ArrayList<Square> findShortestPath(Square start, Square end) {
    this.bfs(start);
    ArrayList<Square> path = new ArrayList();
    Square current = end;
    
    for(int i=0; i<distanceMap.get(end); i++) {
      path.add(preMap.get(current));
      current = preMap.get(current);
    }
    
    return path;
  }
  
 
}
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
  public void drawPlayer() {
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
  public void animatePlayer(){
    if (mouth == 90){
      changeMouth = -10;
    } else if (mouth == 0) {
      changeMouth = 10;
    }
    mouth += changeMouth;
  }
  
  //turning
  public void changeDirection() {
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
  public void eatBalls() {
    int x = (int) (x_pos-25)/50;
    int y = (int) (y_pos-25)/50;
    
    score += board.eatScore(x, y);
  }
  
  //combination of fns
  public void playerActions() {
    animatePlayer();
    drawPlayer();
    moveEntity();
    eatBalls();
  }
  
  public void playerReset(){
    x_pos = 7*50+25;
    y_pos = 12*50+25;
    xtarget = 8;
    ytarget = 12;
    direction = true;
    speed = 1;
    state = 0;
  }
    
  
  
}
class Board {
  //deals with setup of board
  
  //ghost start: y: 6, 7 x: 8, 9
  //pacman start: (7, 12)
  int[][] walls = {
   {2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
   {2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 2},
   {2, 1, 2, 2, 2, 1, 2, 2, 2, 2, 1, 2, 2, 2, 1, 2},
   {2, 1, 2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 3, 2, 1, 2},
   {2, 1, 2, 1, 2, 2, 2, 0, 0, 2, 2, 2, 1, 2, 1, 2},
   {2, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 2},
   {2, 1, 2, 2, 2, 1, 2, 1, 1, 2, 1, 2, 2, 2, 1, 2},
   {2, 1, 2, 2, 2, 3, 2, 2, 2, 2, 3, 2, 2, 2, 1, 2},
   {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
   {2, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 2},
   {2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2},
   {2, 1, 2, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 2, 1, 2},
   {2, 1, 2, 3, 1, 2, 1, 0, 1, 1, 2, 1, 3, 2, 1, 2},
   {2, 1, 2, 2, 1, 2, 1, 2, 2, 1, 2, 1, 2, 2, 1, 2},
   {2, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3, 2},
   {2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2},
   };
   
   boolean ghostBlink = false;
   int blinkTimer;
   
   
  //draws board to screen
  public void drawBoard() {
    for(int i=0; i<16; i++) {
      for(int j=0; j<16; j++) {
        switch(walls[i][j]){
          case 1:
            fill(255);
            circle(j*50+25, i*50+25, 10);
            break;
          case 2:
            fill(50, 0, 250);
            square(j*50, i*50, 50);
            break;
          case 3:
            fill(255);
            circle(j*50+25, i*50+25, 20);
            break;
        }
      }
    }
  }
  
  //updates a spot on the grid
  public void updateBoard(int x, int y, int num){
    walls[y][x] = num;
  }
  
  public int getSquare(int x, int y){
    try{
      return walls[y][x];
    } catch (ArrayIndexOutOfBoundsException e){
      println("?");
      return 0;
    }
  }
  
  //updates board when things are eaten
  public int eatScore(int x, int y){
    try{
      switch(walls[y][x]) {
        case 1:
          walls[y][x] = 0;
          return 1;
        case 3:
          walls[y][x] = 0;
          ghostBlink = true;
          blinkTimer = 200;
          return 2;
      }
    } catch (ArrayIndexOutOfBoundsException e) {
    }
    return 0;
  }
  
  public void updateBlink(){
    if(blinkTimer > 0){
      blinkTimer -= 1;
    } else if(blinkTimer <= 0) {
      ghostBlink = false;
    }
  }
  
  public boolean isTimer200(){
    if(blinkTimer == 200){
      return true;
    }
    return false;
  }
  
  public Ghost playerCollision(Player player, Ghost[] ghosts){
    for(int i=0; i<ghosts.length; i++){
      if(abs(player.x - ghosts[i].x) <= 0.5f && abs(player.y - ghosts[i].y) <= 0.5f){
        return ghosts[i];
      }
    }
    return null; 
  }
  
  public boolean checkForWin(){
    for(int i=0; i<16; i++){
      for(int j=0; j<16; j++){
        if(walls[i][j] == 1 || walls[i][j] == 3){
          return false;
        }
      }
    }
    return true;
  }
  
}
  public void settings() {  size(800, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "pacmancode" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
