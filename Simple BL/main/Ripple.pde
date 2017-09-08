float RIPPLE_INITIAL_RADIUS = 100.0;
float RIPPLE_RADIOUS_STEP_SIZE = 3.0;
float RIPPLE_TRANSPARENCY_STEP_SIZE = 5.0;
float NEW_RIPPLE_RATE = 0.01;
boolean trigger = false;

ArrayList<Ripple> ripples;

void initRipples() {
  ripples = new ArrayList<Ripple>();
  ripples.add(new Ripple());
}

void makeRipples() {
  for (Ripple ripple : ripples) {
    ripple.draw();
  }
  for (Ripple ripple : ripples) {
    ripple.update();
  }

  ArrayList<Ripple> nextRipples = new ArrayList<Ripple>();
  for (Ripple ripple : ripples) {
    if (!ripple.isTransparent()) {
      nextRipples.add(ripple);
    }
  }  
  ripples = nextRipples;
  limitRip();
  if (trigger) {
    trigger = false;
    ripples.add(new Ripple());
  }
}

class Ripple {

  float x;
  float y;
  float rad;
  float transparency;

  Ripple() {
    x = width/2;
    y = height;
    rad = RIPPLE_INITIAL_RADIUS;
    transparency = 255.0;
  }

  void draw() {
    noFill();
    stroke(250, 255, 0, transparency);
    //strokeWeight(1);
    arc(x, y, rad * 2.0, rad * 2.0, 0, PI * 2);
    arc(x, y, rad * 2.0 +1, rad * 2.0 +1, 0, PI * 2);
    arc(x, y, rad * 2.0 -1, rad * 2.0 -1, 0, PI * 2);
  }

  void update() {
    rad += RIPPLE_RADIOUS_STEP_SIZE;
    transparency -= RIPPLE_TRANSPARENCY_STEP_SIZE;
  }  

  boolean isTransparent() {
    if (transparency <= 0.0) {
      return true;
    } else {
      return false;
    }
  }
}

void limitRip() {
  if (jump && eRadius >= 80 && eRadius < 85) {
    trigger = true;
  } else {
    trigger = false;
  }
}