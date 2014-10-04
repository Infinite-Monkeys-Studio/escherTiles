ArrayList<PVector> horizontalPoints, verticalPoints;
PShape horizontal, vertical;
int selected;
boolean selectedListIsHor = true;

static float POINT_SELECT_RANGE = 5;
static int SCALE = 200;
static PVector SCALE_VECTOR = new PVector(SCALE, SCALE);

void setup() {
  size(800,600, P2D);
  
  horizontalPoints = new ArrayList<PVector>();
  horizontalPoints.add(new PVector(0, 0));
  horizontalPoints.add(new PVector(SCALE / 2,  0));
  horizontalPoints.add(new PVector(SCALE,  0));
  for(PVector p : horizontalPoints) {
    p.add(SCALE_VECTOR);
  }
  
  verticalPoints = new ArrayList<PVector>();
  verticalPoints.add(new PVector(0, 0));
  verticalPoints.add(new PVector(0, SCALE / 2));
  verticalPoints.add(new PVector(0, SCALE));
  for(PVector p : verticalPoints) {
    p.add(SCALE_VECTOR);
  }
  
  horizontal = getShape(horizontalPoints);
  vertical = getShape(verticalPoints);
}

void draw() {
  background(167);
  drawPoints();
  translate(-SCALE, -SCALE);
  for(int x = 0; x < width; x += SCALE) {
    for(int y = 0; y < height; y += SCALE) {
      shape(horizontal, x, y);
      shape(vertical, x, y);
    }
  }
}

void mousePressed() {
  PVector mouseLocation = mouseVector();
  
  PVector closestPointInHorizontal = getClosestPoint(mouseLocation, horizontalPoints);
  PVector closestPointInVertical = getClosestPoint(mouseLocation, verticalPoints);
  PVector currentPoint, secondaryPoint;
  ArrayList<PVector> testList = new ArrayList<PVector>();
  
  if(closestPointInHorizontal.dist(mouseLocation) > closestPointInVertical.dist(mouseLocation))
    currentPoint = closestPointInVertical;
  else
    currentPoint = closestPointInHorizontal;
     
  if(currentPoint.dist(mouseLocation) > POINT_SELECT_RANGE) {e
    if(horizontalPoints.contains(s)) {
      int index = horizontalPoints.indexOf(currentPoint);
      testList.add(horizontalPoints.get(index + 1));
      testList.add(horizontalPoints.get(index - 1));
      secondaryPoint = getClosestPoint(mouseLocation, testList);
      int secIndex = horizontalPoints.indexOf(secondaryPoint);
      
      makeNewPoint(currentPoint, index, secIndex, horizontalPoints);
    } else {
      int index = verticalPoints.indexOf(currentPoint);
      testList.add(verticalPoints.get(index + 1));
      testList.add(verticalPoints.get(index - 1));
      secondaryPoint = getClosestPoint(mouseLocation, testList);
      int secIndex = verticalPoints.indexOf(secondaryPoint);
      
      makeNewPoint(currentPoint, index, secIndex, verticalPoints);
    }
  } else {
    if(horizontalPoints.contains(s)) {
      selected = horizontalPoints.indexOf(s);
      horizontalPoints.set(selected, tempMouse);
      shape = getShape();
    } else {
      selected = verticalPoints.indexOf(s);
      verticalPoints.set(selected, tempMouse);
      shape = getShape();
    }  
  }
}

void mouseDragged() {
  points.set(selected, mouseVector());
  shape = getShape();
}

PVector getClosestPoint(PVector input, ArrayList<PVector> list) {
  float dist;
  PVector out = null;
  for(PVector p : list) {
    float tdist = p.dist(input);
    if(tdist < dist){
      dist = tdist;
      out = p;
    }
  }
  return out;
}

PVector getSecoundClosestPoint(PVector input, ArrayList<PVector> list) {
  float dist;
  PVector out = null;
  PVector smallest = getClosestPoint(input, list);
  for(PVector p : list) {
    float tdist = p.dist(input);
    if(tdist < dist && p != smallest){
      dist = tdist;
      out = p;
    }
  }
  return out;
}

PVector[] getClosestSegment(PVector input, ArrayList<PVector> list) {
  PVector first = getClosestPoint(input, list);
  PVector secound = getSecoundClosestPoint(input, list);
  return new PVector[]{first, secound};
}

void makeNewPoint(PVector newPoint, int first, int secound, ArrayList<PVector> list) {
  int newIndex = (first > secound) ? first : secound;
  list.add(newIndex, newPoint);
  selected = newIndex;
}

PVector mouseVector() {
  return new PVector(mouseX, mouseY);
}

void drawPoints() {
  fill(0);
  for(PVector p : points) {
    ellipse(p.x, p.y, 2, 2);
  }
}

PShape getShape(ArrayList<PVector> points) {
  PShape s = createShape();
  s.beginShape();
  s.noFill();
  s.stroke(255,0,0);
  for(PVector p : points) {
    s.vertex(p.x, p.y);
  } 
  s.endShape();
  return s;
}
