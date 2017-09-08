float yoff = 0.0;  // 2nd dimension of perlin noise
float nVal;        // noise value
float nInt = 1;    // noise intensity
float nAmp = 1;    // noise amplitude

float spike;
float easing = 0.35;
Ball b;
boolean started; //boolean for telling if the program has started 
boolean shortHop = false;
boolean hop = false;
boolean jump = false;
boolean superjump = false;
boolean leftPressed = false;
boolean rightPressed = false;
float gravity = 0.2;
float ground = 300;
float dampen = 0.2;
float y;

int set = 0;
int[] seq;

Camera c;
PipeSet[] ps;
static final int NUMPIPES = 1000;
int numPipes;
static final int GAMEOVER = 1;
static final int GAME = 0;
int gameState;

class Ball {
  PVector pos;
  float dir;
  PVector velo;
  float roll;
  float bounce;
  float radius;
}

class Camera {
  PVector pos; //Camera's position
  //The Camera should sit in the top left of the window
  Camera() {
    pos = new PVector(0, 0);
    //You should play with the program and code to see how the staring position can be changed
  }
  void draw() {
    pos.x+=2;
  }
}

class PipeSet {
  PVector pos;
  float bHeight, bWidth;
  boolean scored;
  float hVal = 0;

  PipeSet(float x, float y, float h) {
    pos = new PVector(x, y);
    bHeight = h;
    bWidth = 50;
    scored = false;
  }

  void draw() {
    drawPipes();
  }

  void drawPipes() {
    //fill(pos.x/2, 30, pos.y/2);
    smooth();
    colorMode(HSB);// sets color mode value 
    fill(hVal, 255, 255);//cycles through hue and brightness to expose a greater color palete
    stroke(hVal, 255, 225);// sets the stroke to cycle through the whole color spectrum 
    colorMode(RGB);//sets color mode back to Red green and blue 

    rect(pos.x, 0, 50, pos.y);
    rect(pos.x, pos.y+bHeight, 50, height);

    hVal +=1;

    if (hVal > 255)
    {
      hVal = 0;
    }
  }
}

void setup() {
  size(640, 640);
  noiseDetail(8);
  initGame();
  
}

void draw() {
  seq = new int[4];
  switch(gameState) {
  case 1:
    background(0);
    textSize(32);
    fill(255);
    text("GAME OVER", width/2-textWidth("GAME OVER")/2, height/2-32);
    text("Hit any key to replay", width/2-textWidth("Hit any key to replay")/2, height/2+32);
    text("Distance: " + (int)(b.pos.x/100), width/2-textWidth("Distance: #")/2, height-100);
    if (keyPressed) {
      initGame();
      gameState = 0;
    }
    break;
  case 0:
    background(0);
    update();
    stroke(255);
    fill(0);

    handelInputs();

    nInt = map(spike, 0, width, 0.1, 30); // map jmp to noise intensity
    nAmp = map(spike, 0, height, 0.0, 1.0); // map jmp to noise amplitude

    // We are going to draw a polygon out of the wave points

    beginShape(); 

    float xoff = 0;       // Option #1: 2D Noise

    // Iterate over horizontal pixels
    for (float x = 0; x <= width; x += 10) {
      // Calculate a y value according to noise, map to 
      if (spike >= 0) {
        y = map(noise(xoff*nInt+1, yoff*nAmp+1), 0, 1, 200, 300); // Option #1: 2D Noise
      } 
      if (spike <= 1) {
        y = 260;
      }
      //println(spike);
      //float y = map(noise(cos(xoff)*nInt+1, sin(yoff)*nAmp+1), 0, 1, 200,300); // Option #2: map noise value to match the amplitude
      //println(y);
      // Set the vertex
      vertex(x, y); 
      // Increment x dimension for noise
      xoff += 0.05;
    }
    // increment y dimension for noise
    yoff += 0.01;
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
    if (b.pos.y > 260 && spike < 1) {
      stroke(255);
      line(0, ground-40, 1000, ground-40);
    }
    fill(0, 255, 0);
    translate(-c.pos.x, -c.pos.y);
    render();
    c.draw();
    drawPipes();
    translate(c.pos.x, c.pos.y);
    drawFG();
    drawGUI();
    break;
  }
}

void initGame() {
  b = new Ball();
  b.pos = new PVector(100, 250);
  b.dir = 1;
  b.velo = new PVector(0, 0);
  b.roll = 5;
  b.bounce = 8;
  b.radius = 20;

  gameState = 0;
  ps = new PipeSet[NUMPIPES];
  c = new Camera();
  makePipes();
}

void keyPressed(KeyEvent e) {
  //if (key == CODED) {
  //  if (keyCode == LEFT) {
  //    leftPressed = true;
  //  } else if (keyCode == RIGHT) {
  //    rightPressed = true;
  //  }
  //}
}

void keyReleased(KeyEvent e) {
  //if (key == CODED) {
  //  if (keyCode == LEFT) {
  //    leftPressed = false;
  //  } else if (keyCode == RIGHT) {
  //    rightPressed = false;
  //  }
  //}
}

void update() {
  b.pos.x += 2;
  if (b.pos.y < ground) {
    b.pos.y += b.velo.y;
    b.velo.y += gravity;
    if (b.pos.y >= ground-100/2) {
      b.velo.y *= -dampen;
    }
  } else {
    b.velo.y = 0;
  }

  if (leftPressed && b.pos.x > 0) {
    b.pos.x -= b.roll;
  }
  if (rightPressed && b.pos.x < width) {
    b.pos.x += b.roll;
  }
  if (b.pos.y >= (ground-50) && shortHop) {
    b.velo.y = -b.bounce + 3;
  }
  if (b.pos.y >= (ground-50) && hop) {
    b.velo.y = -b.bounce + 2;
  }
  if (b.pos.y >= (ground-50) && jump) {
    b.velo.y = -b.bounce + 1.4;
  }
  if (b.pos.y >= (ground-50) && superjump) {
    b.velo.y = -b.bounce + .5;
  }
}

void render() {
  //display ballnoStroke();
  noStroke();
  fill(255);
  ellipse(b.pos.x, b.pos.y, b.radius, b.radius);
}

void drawFG() {
  fill(0);
  rect(-20, height-200, width+50, 300);
  fill(255);
  ellipse(width/2 - 35, 500, 50, 50);
  ellipse(width/2 + 35, 500, 50, 50);
  ellipse(width/2 - 75, 550, 50, 50);
  ellipse(width/2 + 75, 550, 50, 50);
}

void drawGUI() {
  textSize(20);
  fill(255);
  text("Distance: " + (int)(b.pos.x/100), 0, height - 40);
  fill(25);
  text("Q", width/2 - 83, 555);
  text("P", width/2 + 70, 555);
  text("W", width/2 - 45, 505);
  text("O", width/2 + 25, 505);
}

void makePipes() {
  float x = 500;
  float y = random(50, 200);
  float h = 125;

  for (int i = 0; i < NUMPIPES; i++) {
    ps[i] = new PipeSet(x, y, h);
    y = random(50, 200);
    h = 125;
    x += 150;
  }
}

void drawPipes() {


  for (int i = 0; i < NUMPIPES; i++) {
    if (PVector.dist(b.pos, ps[i].pos) < 650)
      ps[i].draw();
    //if (b.pos.x > ps[i].pos.x && b.pos.x < ps[i].pos.x + ps[i].bWidth && b.pos.y > ps[i].pos.y && b.pos.y < ps[i].pos.y + ps[i].bHeight)
    //{
    //  ps[i].scored = true;
    //}
    if (b.pos.x > ps[i].pos.x && b.pos.x < ps[i].pos.x + ps[i].bWidth && (b.pos.y < ps[i].pos.y || b.pos.y > ps[i].pos.y + ps[i].bHeight))
      gameState = GAMEOVER;
  }
}

void handelInputs() {
  if (keyPressed) {
    //LEFT
    if (key == 'q') {
      shortHop = true;
      if (b.pos.y >= ground-50 && b.pos.y <= ground) {
        spike = 100;
        if (set < 4) {
          seq[set] = 1;
          set += 1;
        }
      } else {
        float targetA = 0;
        float dx = targetA - spike;
        spike += dx * 0.35;//ease rate
      }
    }
    if (key == 'w') {
      hop = true;
      if (b.pos.y >= ground-50 && b.pos.y <= ground) {
        spike = 300;
        if (set < 4) {
          seq[set] = 2;
          set += 1;
        }
      } else {
        float targetA = 0;
        float dx = targetA - spike;
        spike += dx * 0.3;//ease rate
      }
    }
    //RIGHT
    if (key == 'o') {
      jump = true;
      if (b.pos.y >= ground-50 && b.pos.y <= ground) {
        spike = 600;
        if (set < 4) {
          seq[set] = 3;
          set += 1;
        }
      } else {
        float targetA = 0;
        float dx = targetA - spike;
        spike += dx * 0.25;//ease rate
      }
    }
    if (key == 'p') {
      superjump = true;
      if (b.pos.y >= ground-50 && b.pos.y <= ground) {
        spike = 900;
        if (set < 4) {
          seq[set] = 4;
          set += 1;
        }
      } else {
        float targetA = 0;
        float dx = targetA - spike;
        spike += dx * 0.2;//ease rate
      }
    }
  }
  if (!keyPressed) {
    //LEFT
    if (key == 'q') {
      //spike = 0;
      shortHop = false;
      float targetA = 0;
      float dx = targetA - spike;
      spike += dx * 0.35;//ease rate
    }
    if (key == 'w') {
      //spike = 0;
      hop = false;
      float targetA = 0;
      float dx = targetA - spike;
      spike += dx * 0.3;//ease rate
    }
    //RIGHT
    if (key == 'o') {
      //spike = 0;
      jump = false;
      float targetA = 0;
      float dx = targetA - spike;
      spike += dx * 0.25;//ease rate
    }
    if (key == 'p') {
      //spike = 0;
      superjump = false;
      float targetA = 0;
      float dx = targetA - spike;
      spike += dx * 0.2;//ease rate
    }
  }
}