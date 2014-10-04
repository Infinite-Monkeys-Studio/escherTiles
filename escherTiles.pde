ArrayList<PVector> horizontalPoints, verticalPoints;
PShape horizontal, vertical;
int selected;

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
  PVector tempMouse = mouseVector();
  PVector p = getPoint(tempMouse, false, true);
  if(p != null) {
    selected = points.indexOf(p);
    points.set(selected, tempMouse);
    shape = getShape();
  } else {
    makeNewPoint(tempMouse);
  }
}

void mouseDragged() {
  points.set(selected, mouseVector());
  shape = getShape();
}

PVector getPoint(PVector input, boolean getSecound, boolean useRange) {
  PVector[] mem = new PVector[2];
  float dist;
  if(useRange)
    dist = POINT_SELECT_RANGE;
  else
    dist = 1000000000;
  PVector out = null;
  for(PVector p : points) {
    float tdist = p.dist(input);
    if(dist > tdist){
      dist = tdist;
      mem[1] = mem[0];
      mem[0] = out = p;
    }
  }
  if(getSecound)
    return mem[1];
  return out; 
}

void makeNewPoint(PVector tempMouse) {
  PVector first = getPoint(tempMouse, false, false);
  PVector secound = getPoint(tempMouse, true, false);
  int findex = points.indexOf(first);
  int sindex = points.indexOf(secound);
  int newIndex = (findex > sindex) ? findex : sindex;
  points.add(newIndex, tempMouse);
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
