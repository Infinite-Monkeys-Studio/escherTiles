ArrayList<PVector> points;
PShape shape;
int selected;
static float POINT_SELECT_RANGE = 5;

void setup() {
  size(800,600, P2D);
  points = new ArrayList<PVector>();
  points.add(new PVector(10,10));
//  points.add(new PVector(10,20));
  points.add(new PVector(10,30));
//  points.add(new PVector(10,40));
  points.add(new PVector(10,50));
  shape = getShape();
}

void draw() {
  background(167);
  shape(shape, 0,0);
  drawPoints();
}

void mousePressed() {
  PVector tempMouse = mouseVector();
  PVector p = getPoint(tempMouse, false, true);
  if(p != null) {
    selected = points.indexOf(p);
    points.set(selected, tempMouse);
    shape = getShape();
  } else {
    PVector first = getPoint(tempMouse, false, false);
    PVector secound = getPoint(tempMouse, true, false);
    int findex = points.indexOf(first);
    int sindex = points.indexOf(secound);
    int newIndex = (findex > sindex) ? findex : sindex;
    points.add(newIndex, tempMouse);
    selected = newIndex;
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

PVector mouseVector() {
  return new PVector(mouseX, mouseY);
}

void drawPoints() {
  fill(0);
  for(PVector p : points) {
    ellipse(p.x, p.y, 2, 2);
  }
}

PShape getShape() {
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
