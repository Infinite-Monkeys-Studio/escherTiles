void setup() {
  
}

void draw() {
  
}

void mouseDown() {
  
}

class pointList {
 
  private IntList xPoints;
  private IntList yPoints;
  
  pointList() {
    xPoints = yPoints = new IntList();
  }
  
  void addPoint(char xy, int value, int place) {
    xy = Charictar.toLowerCase(xy);
    
    switch (xy) {
      case 'x':
        //dosomthin
        break;
      case 'y':
        //do somthin
        break;
      default:
        println("error");
        break;
    }
  }
}
