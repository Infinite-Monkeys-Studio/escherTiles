/**
* Represents one side of the tile
*/
class Side {
  ArrayList<PVector> points;
  
  Side(PVector startPoint, PVector endPoint) {
    points = new ArrayList<PVector>();
    points.add(startPoint);
    points.add(endPoint);
    
  }
  
  PShape getShape() {
    PShape s = createShape();
    s.beginShape().noFill();
    s.stroke(255,0,0);
    for(PVector p : points) {
      s.vertex(p.x, p.y);
    } 
    s.endShape();
    return s;
  }
}
