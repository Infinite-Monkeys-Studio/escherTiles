ArrayList<PVector> horizontalPoints, verticalPoints;
PShape horizontal, vertical;
int selected;  // the index of the point to be dragged, or -1 if none is nearby
boolean selectedListIsHor = true;

static float POINT_SELECT_RANGE = 5;
static int SCALE = 200;
static PVector SCALE_VECTOR = new PVector(SCALE, SCALE);
static float bestSoFar = 0;             // this is used by getPositionToInsertNewPoint


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
     
  if(currentPoint.dist(mouseLocation) > POINT_SELECT_RANGE) {
    bestSoFar = POINT_SELECT_RANGE;
    int i = 1 + getPositionToInsertNewPoint(mouseLocation, horizontalPoints);
    int j = 1 + getPositionToInsertNewPoint(mouseLocation, verticalPoints);
 
    if (j > 0) {
      selectedListIsHor = false;
      verticalPoints.add(j, mouseLocation);
      selected = j;
    }
    else if (i > 0) {
      selectedListIsHor = true;
      horizontalPoints.add(i, mouseLocation);
      selected = i;
    }
    else {
      selected = -1;            // NOTHING IS SELECTED
    }
  } else {
    if(horizontalPoints.contains(currentPoint)) {
      selected = horizontalPoints.indexOf(currentPoint);
      selectedListIsHor = true;
      horizontalPoints.set(selected, mouseLocation);
      horizontal = getShape(horizontalPoints);
    } else {
      selected = verticalPoints.indexOf(currentPoint);
      selectedListIsHor = false;
      verticalPoints.set(selected, mouseLocation);
      vertical = getShape(verticalPoints);
    }  
  }
}

void mouseDragged() {
  if(selectedListIsHor && selected >= 0 && selected < horizontalPoints.size()) {
    horizontalPoints.set(selected, mouseVector());
    horizontal = getShape(horizontalPoints);
  } 
  else if (selected >= 0 && selected < verticalPoints.size()) {
    verticalPoints.set(selected, mouseVector());
    vertical = getShape(verticalPoints);
  }
}

PVector getClosestPoint(PVector input, ArrayList<PVector> list) {
  float dist = 10000;
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


/**
* This tests if the distance from the point to any segment of the list is less than "bestSoFar"
* and if so, it returns the index of the first end of the segment.
* NOTE: the caller must set the bestSoFar to a reasonable value
* @return -1 on failure
*/
int getPositionToInsertNewPoint(PVector input, ArrayList<PVector> list) 
{
  int out = -1;
  for (int i = 0; i + 1 < list.size(); ++i) 
  {
    PVector p = pointToSegment(input, list.get(i), list.get(i+1));
    float tdist = p.dist(input);
    if (tdist < bestSoFar){
      bestSoFar = tdist;
      out = i;
    }
  }
  return out;  
}


float clamp(float x, float a, float b)
{
  return (x < a) ? a : (x > b) ? b : x;
}


/**
* given point and segment, return point on the segment that is nearest to the point
* NOTE this works either in 2D or 3D.
*/
PVector pointToSegment(final PVector p, final PVector a, final PVector b)
{
  PVector d = PVector.sub(b,a);
  float m = d.magSq();
  if (m < 1e-20) return a;   // hack to avoid division by zero
  float k = PVector.sub(p, a).dot(d) / m; 
  k = clamp(k, 0, 1);
  return PVector.add(PVector.mult(a, 1 - k), PVector.mult(b, k));    // interpolate between a(0) and b(1)
}
  
  

//PVector getSecoundClosestPoint(PVector input, ArrayList<PVector> list) {
//  float dist = 10000;
//  PVector out = null;
//  PVector smallest = getClosestPoint(input, list);
//  for(PVector p : list) {
//    float tdist = p.dist(input);
//    if(tdist < dist && p != smallest){
//      dist = tdist;
//      out = p;
//    }
//  }
//  return out;
//}

//PVector[] getClosestSegment(PVector input, ArrayList<PVector> list) {
//  PVector first = getClosestPoint(input, list);
//  PVector secound = getSecoundClosestPoint(input, list);
//  return new PVector[]{first, secound};
//}

//void makeNewPoint(PVector newPoint, int first, int secound, ArrayList<PVector> list) {
//  int newIndex = (first > secound) ? first : secound;
//  list.add(newIndex, newPoint);
//  selected = newIndex;
//}

PVector mouseVector() {
  return new PVector(mouseX, mouseY);
}

void drawPoints() {
  fill(0);
  for(PVector p : horizontalPoints) {
    ellipse(p.x, p.y, 2, 2);
  }
  
  for(PVector p : verticalPoints) {
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
