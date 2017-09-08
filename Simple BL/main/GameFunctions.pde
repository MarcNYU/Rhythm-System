Glide gainGlide;
BeatDetector bd;    
BeatQueue bq;
int forward = 2000;  // how many milliseconds to look forward
float spd;
float fadeInVal = 1;
float volumeFade = 0.4;
boolean checkGap;

void initGame() {
  b = new Ball(40, 100, 26);
  //b = new Player(40, height-200);
  score = (int) b.pos.y;
  ll = new Line(-200);
  rl = new Line(200);
}

void initMusic() {
  stroke(255);
  time = millis();
  bd = new BeatDetector(forward);
  bd.loadSong(songList[currentSongIdx]);
  bq = new BeatQueue(bd);
  bd.start();
}

void Game() {
  //println(frameRate);
  //println(bq.nexts());
  //bq.holdGap();
  manageVolume();
  if (playtest)
    fadeVolume();
  gainGlide.setValue(volume);
  //println("percent completion: " + percentCompletion);

  if (b.pos.x == left || b.pos.x == right) {
    input();
  } 
  BG();
  input();
  //check();
  spd = (abs(bq.next())/100) + 10;
  //println(bq.next());
  //if (spd<10)spd=10;
  //if (spd>20)spd=20;
  //b.setSongSpeed(spd);

  b.update();
  //drawGuides();
  drawStringL();
  drawStringR();
  b.render();
  //seconds = (int)(ac.getTime()/(1000))%60;
  //minutes = (int)(ac.getTime()/1000)/60;
  //score = min(fixDec((float)(ac.getTime()/songRuntimes[currentSongIdx]),2),100);
  makeRipples();
  drawFG();
  if (b.pos.y > dropLine && hitFloor) {
    b.bounceCounts[3] -= 1;
  }
}

void resetGame() {
  //println("game reset");
  //g = new beads.Gain(ac, 2, 0.2);
  volume = 1;
  surface.setResizable(true);
  ac.reset();
  ac2.reset();
  fadeValue = 255.0;
  fadeValue2 = 0.0;
  timerStart = false;
  failTimer = 0;
  failing = false;
  hitFloor = false;
  b.bounceCounts[0] =0;
  b.bounceCounts[1] =0;
  b.bounceCounts[2] =0;
  b.bounceCounts[3] =0;
  //initMusic();
  initGame();
  score = 0;
}

void drawFG() {
  //if player is not failing, draw FG normally, otherwise, draw with fade value
  if (!failing) {
    pushMatrix();
    rectMode(CORNER);

    fill(0);
    stroke(255);
    rect(0, 0, width-1, 40);
    //rect(-10, height-42, width+10, 40);
    fill(0);
    stroke(250, 255, 0);
    ellipse(width/2, height, 300, 300);
    stroke(0);
    //rect(0, height-41, width-1, 40);
    textSize(22);
    fill(250, 255, 0);
    text("Percent Completion: " + min(round(percentCompletion * 100), 100) + "%", 20, 35);
    //text("Minutes: " + round(minutes) + " Seconds: " + seconds + " Score: " + score, 20, 35);
    //fill(255);
    //noStroke();
    //ellipse(width/2, height-45, eRadius, eRadius);
    popMatrix();
  } else {
    pushMatrix();
    rectMode(CORNER);

    //fill(fadeValue);
    fill(0);
    stroke(fadeValue);
    rect(0, 0, width-1, 40);
    //rect(-10, height-42, width+10, 40);
    fill(0);
    stroke(250, 255, 0);
    ellipse(width/2, height, 300, 300);
    stroke(fadeValue2);
    //rect(0, height-41, width-1, 40);
    textSize(22);
    fill(255);
    text("Percent Completion: " + min(round(percentCompletion * 100), 100) + "%", 20, 35);
    //fill(fadeValue);
    //noStroke();
    //ellipse(width/2, height-45, eRadius, eRadius);
    popMatrix();
  }
  //int bs[] = bq.nexts();
  //for (int i = 0; i < bs.length; ++i) {

  //  int y = 300 - bs[i] * 300 / forward;
  //  //int y = beats[i] * height / forward;
  //  //line (0, y, width, y);
  //  if (checkGap) {
  //    noStroke();
  //    fill(255);
  //    ellipse(width/2, height, y, y);
  //    fill(0);
  //    ellipse(width/2, height, y-10, y-10);
  //  }
  //}

  stroke(255);
  noFill();
  int beats[] = bq.nexts(); // returns an array of time of beats
  for (int i = 0; i < beats.length; ++i) {

    int y = 300 - beats[i] * 300 / forward;
    //int y = beats[i] * height / forward;
    //line (0, y, width, y);
    ellipse(width/2, height, y, y);
  }
  int next = bq.next(); // return next beat
  if (next <= 20) {
    eRadius = 85;
  }
  //fill(brightness*255);
  //ellipse(width/2,height/2,100,100); 

  //stroke(100, 255, 100);

  //ellipse(b.pos.x, b.pos.y, eRadius, eRadius);
  //ellipse(b.pos.x, b.pos.y, eRadius-1, eRadius-1);

  int dt = millis() - time;
  eRadius -= (dt * 0.1);
  //eRadius += (dt * 0.1);
  if (eRadius < 20) eRadius = 20;
  //if (eRadius > 85) eRadius = 85;
  time += dt;
}



void drawScore(int minutes, int seconds) {
  textSize(20);
  fill(fadeInVal);
  fadeInVal += 5;
  if (state == 2) {
    text("GAME OVER", width/2-textWidth("GAME OVER")/2, 150);
    text("Percent Completion: ", 80, 250);
    text(min(round(percentCompletion * 100), 100) + "%", 350, 250);
  } else if ( state == 4) {
    text("You've made it to the end of the song!", width/2-textWidth("You've made it to the end of the song!")/2, 150);
    //drawGuides();
  }

  textSize(15);
  float high = b.bounceCounts[2] * 4;
  float mid = b.bounceCounts[1] * 3;
  float bottom = b.bounceCounts[0] * 2;
  float drop = b.bounceCounts[3] * 2;
  text("Bounce points in Top Zone: ", 80, 300);
  text(" = " + high, 350, 300);
  //text( high, 350, 300);

  text("Bounce points in Mid Zone:  ", 80, 350);
  text("= " + mid, 350, 350);
  //text( mid  , 350, 350);

  text("Bounce points in Low Zone: ", 80, 400);
  text("= " + bottom, 350, 400);

  text("Danger Zone penalty: ", 80, 450);
  text("= " + drop, 350, 450);
  //text( bottom , 350, 450);
  score = bottom  + mid + high + drop;
  text("Time in Song: ", 80, 200);
  text( minutes  + ":" + seconds, 350, 200);
  stroke(255);
  line(40, 480, width-40, 480);

  text("Final Score: ", 80, 520);
  text(max(round(score), 0), 350, 520);
  //text(" x 10 = ", 250, 400);
  //text( score, 350, 400);


  //text("Time in Song: " + minutes  + ":" + seconds, 80, 300);
  //text(" x 10 = ", 250, 400);
  //text( score, 350, 400);

  //stroke(255);
  //line(40, 450, width-40, 450);
}

void manageVolume() {
  if (b.pos.y < middle) {
    volume = 1;
  } else if (b.pos.y > middle && b.pos.y < dropLine) {
    volume = .50;
  } else if (b.pos.y > dropLine) {
    volume = .20;
  }
}

void fadeVolume() {
  if (percentCompletion >0.95) {
    if (volume > 0)
      volume -= volumeFade;
    //volume = 0;
    // println("volume after fade: " + volume);
  }
}


void drawBG() {
}

void input() {
  if (keyPressed) {
    if (key == ' ') {
      //if ((key == ' ' || key == 'b')) {
      jump = true;
      startOfGame = false;
      noLoop();
      if (b.currentZone != 3) {
        b.bounceCounts[b.currentZone] += 1;
        //println("current zone: " + b.currentZone + "bounce counts: "+ b.bounceCounts[b.currentZone]);
      } else {
        b.bounceCounts[b.currentZone] -= 1;
        //println("current zone: " + b.currentZone + "bounce counts: "+ b.bounceCounts[b.currentZone]);
      }
      //if (b.pos.y > dropLine && hitFloor) {
      //  //noLoop();
      //  b.bounceCounts[3] -= 1;
      //  //loop();
      //}
      loop();
    }
  } else {
    jump = false;
  }
}

void keyPressed() {
  if (key == ESC) {
    //sp.close();
  }
}

void keyReleased() {
  jump = false;
  releasedKey = true;
  upPressed = false;
  downPressed = false;
}

void check() {
  if (!b.leftB() && !b.rightB() && jump) {
    gravity = .6;
  } else {
    if (b.pos.y < ceilling) {
      gravity = .65;
    } else {
      gravity = .4;
    }
  }
}