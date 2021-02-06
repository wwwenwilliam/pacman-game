class Pathfinding{
  ArrayList<Square> squares;
  
  
  ArrayList<int[]> findPath(int x1, int y1, int x2, int y2){
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

  
  ArrayList<Square> allSquares(int[][] grid){
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
  
  boolean isConnected(Square square) {
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
  
  void bfs(Square start) {  //i think this is bfs  
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
  
  ArrayList<Square> findShortestPath(Square start, Square end) {
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
