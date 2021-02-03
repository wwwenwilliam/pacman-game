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
  void drawBoard() {
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
  void updateBoard(int x, int y, int num){
    walls[y][x] = num;
  }
  
  int getSquare(int x, int y){
    try{
      return walls[y][x];
    } catch (ArrayIndexOutOfBoundsException e){
      println("?");
      return 0;
    }
  }
  
  //updates board when things are eaten
  int eatScore(int x, int y){
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
  
  void updateBlink(){
    if(blinkTimer > 0){
      blinkTimer -= 1;
    } else if(blinkTimer <= 0) {
      ghostBlink = false;
    }
  }
  
  boolean isTimer200(){
    if(blinkTimer == 200){
      return true;
    }
    return false;
  }
  
  Ghost playerCollision(Player player, Ghost[] ghosts){
    for(int i=0; i<ghosts.length; i++){
      if(abs(player.x - ghosts[i].x) <= 0.5 && abs(player.y - ghosts[i].y) <= 0.5){
        return ghosts[i];
      }
    }
    return null; 
  }
  
}
