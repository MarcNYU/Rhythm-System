float [] j = new float [50];
float [] k = new float [50];
boolean startOfGame = true;
float gravity = .3;
boolean gameInit = true;
boolean jump;
Ball b;

int bmLevCount ;
int midLevCount;
int highLevCount;
class Ball {
  PVector pos;
  PVector velo;

  int dir;
  int currentPlatform;

  float songSpd;
  float radius;
  //int score;
  int bounceCounter;
  int bonusCap = 20;

  boolean alive;
  int bColor;
  int currentZone = 0;
  int bounceCounts[] = new int[4];

  int lowZoneIdx = 0;
  int midZondIdx = 1;
  int highZoneIdx = 2;




  Ball (float x, float y, float r) {
    pos = new PVector(x, y); //Vec2 of x and y position
    velo = new PVector(0, 0); //Vec2 of x and y velocity
    currentPlatform = 1;
    dir = 1;  
    radius = r;
    alive = true;
    //bColor = (int)(random(1, 3));
    bColor = 1;
    bounceCounter = 0;
    songSpd = 13;

    bounceCounts[0] =0;
    bounceCounts[1] =0;
    bounceCounts[2] =0;
    bounceCounts[3] =0;

    for (int i = 0; i<50; i++) {
      j[i] = -10;
      k[i] = -10;
    }
  }
  void update() {
    //pos.y-=move;
    pos.x += velo.x;
    pos.y += velo.y;


    if (min(round(percentCompletion * 100), 100) < 2) {
      velo.y = 0;
      jump = false;
    } else {
      velo.y += gravity;
    }

    if (BelowDropLine() && !hitFloor) {
      hitFloor = true;
    } else if (BelowMidLine()) {
      currentZone =0;
    } else if (AboveMidLine()) {
      currentZone =1;
    } else if (BelowDropLine()) {
      currentZone = 3;
    } else if (AboveTopLine()) {
      currentZone = 2;
    }

    if (pos.x == 40 && jump) {
      if (eRadius >= 52) {
        //if (jump && brightness != 0.0) {
        velo.y = -9;
      } else {
        velo.y = -4.5;
      }
      velo.x = 13.5;
    } else if (pos.x == 440 && jump) {
      if (eRadius >= 52) {
        //if (jump && brightness != 0.0) {
        velo.y = -9;
      } else {
        velo.y = -4.5;
      }
      velo.x = -13.5;
    }

    if (pos.x < 40) {
      velo.x = 0;
      velo.y = 0;
      pos.x = 40;
    } else if (pos.x > 440) {
      velo.x = 0;
      velo.y = 0;
      pos.x = 440;
    } 

    //if (pos.x == 40 || pos.x == 440) {
    //  gravity = .01;
    //} else {
    //  gravity = .3;
    //}
    if (grounded()) {
      //gravity = 0;
      pos.y = ground-3;
    }
    if (pos.y > ground) {
      pos.y = ground-5;
    }
    //if (pos.y < ceilling) {
    //  //if (false) {
    //  gravity = .6;
    //} else {
    //  gravity = .3;
    //}
    if (TopLine()) {
      if (pos.x == 40 || pos.x == 440) {
        gravity = .03;
      } else {
        gravity = .7;
      }
    } else if (AboveMidLine()||BelowMidLine()) {
      if ((pos.x == 40 || pos.x == 440) || (pos.x < 40 || pos.x > 440)) {
        gravity = .03;
      } else {
        gravity = .45;
      }
    } else if (BelowSafeLine()) {
      if ((pos.x == 40 || pos.x == 440) || (pos.x < 40 || pos.x > 440)) {
        gravity = .02;
      } else {
        gravity = .2;
      }
    } else if (BelowDropLine()) {
      if ((pos.x == 40 || pos.x == 440) || (pos.x < 40 || pos.x > 440)) {
        gravity = .01;
      } else {
        gravity = .1;
      }
    }
  }
  void onGround() {
    if (TopLine()) {
      if (leftB() && jump) {
        if (checkRadius()) {
          velo.y = -7;
        } else {
          velo.y = 0;
        }
        velo.x = songSpd;
      } else if (rightB() && jump) {
        if (checkRadius()) {
          velo.y = -7;
        } else {
          velo.y = 0;
        }
        velo.x = -songSpd;
      }
    } else if (AboveMidLine() || BelowMidLine()) {
      if (leftB() && jump) {
        if (checkRadius()) {
          velo.y = -7;
        } else {
          velo.y = 0;
        }
        velo.x = songSpd;
      } else if (rightB() && jump) {
        if (checkRadius()) {
          velo.y = -7;
        } else {
          velo.y = 0;
        }
        velo.x = -songSpd;
      }
    } else if (BelowSafeLine()) {
      if (leftB() && jump) {
        if (checkRadius()) {
          velo.y = -7;
        } else {
          velo.y = 0;
        }
        velo.x = songSpd;
      } else if (rightB() && jump) {
        if (checkRadius()) {
          velo.y = -7;
        } else {
          velo.y = 0;
        }
        velo.x = -songSpd;
      }
    } else if (BelowDropLine()) {
      if (leftB() && jump) {
        if (checkRadius()) {
          velo.y = -7;
        } else {
          velo.y = 0;
        }
        velo.x = songSpd;
      } else if (rightB() && jump) {
        if (checkRadius()) {
          velo.y = -7;
        } else {
          velo.y = 0;
        }
        velo.x = -songSpd;
      }
    } else if (pos.y < 100) {
      if (leftB() && jump) {
        if (checkRadius()) {
          velo.y = -7;
        } else {
          velo.y = 0;
        }
        velo.x = songSpd;
      } else if (rightB() && jump) {
        if (checkRadius()) {
          velo.y = -7;
        } else {
          velo.y = 0;
        }
        velo.x = -songSpd;
      }
    }
    gravity = .2;
  }
  void inAir() {
    if (leftB() && jump) {
      if (eRadius >= 52) { 
        velo.y = -.95;
      } else {
        velo.y = 0;
      }
      velo.x = songSpd;
    } else if (rightB() && jump) {
      if (eRadius >= 52) { 
        velo.y = -.95;
      } else {
        velo.y = 0;
      }
      velo.x = -songSpd;
    } 
    gravity = .3;
    if (pos.y < ceilling && !leftB() && !rightB()) {
      velo.y = 0;
    }
  }
  void setSongSpeed(float s) {
    songSpd = s;
  }
  boolean AboveTopLine() {
    if (pos.y > ceilling) return true;
    return false;
  }
  Boolean grounded() {
    if (pos.y <= ground+3 && pos.y >= ground-3) return true; //If the ball is between the positions right above and below the "ground"
    return false;
  }
  Boolean leftB() {
    if (pos.x <= left+1 && pos.x >= left-2) return true;
    return false;
  }
  Boolean rightB() {
    if (pos.x <= right+2 && pos.x >= right-1) return true;
    return false;
  }
  boolean TopLine() {
    if (pos.y < ceilling) return true;
    return false;
  }
  boolean BelowMidLine() {
    if (pos.y > middle && pos.y < safeLine) return true;
    return false;
  }
  boolean AboveMidLine() {
    if (pos.y < middle && pos.y > ceilling) return true;
    return false;
  }
  boolean BelowSafeLine() {
    if (pos.y < dropLine && pos.y > safeLine) return true;
    return false;
  }
  boolean BelowDropLine() {
    if (pos.y > dropLine) return true;
    return false;
  }

  void render() {
    noStroke();

    noStroke();
    showLastPosition();
    //showTrail();
    noStroke();

    drawPlayer();
    //stroke(255);
    //line(0, linePos.y, width, linePos.y);
  }

  void showLastPosition() {
    if (pos.x == 40 || pos.x == 440) {
      for (int i=0; i<radius; i++) {
        j[i] = pos.x;
        k[i] = pos.y;
        //if (!(jump && eRadius >= 52)) {
        //  fill(255, 1, 1);
        //} else {
        //  fill(250, 255, 100);
        //}
        if (hitFloor) {
          fill(255, fadeValue);
        } else {
          fill(250, 255, 100);
        }
        ellipse (j[i], k[i], radius, radius);
      }
    } else {
      for (int i=0; i<radius; i++) {
        j[i] = j [i+1];
        k[i] = k [i+1];
        //if (!(jump && eRadius >= 52)) {
        //  fill(255, 1, 1);
        //} else {
        //  fill(100, 255, 100);
        //}
        if (hitFloor) {
          fill(255, fadeValue);
        } else {
          fill(250, 255, 100);
        }
        ellipse (j[i], k[i], i, i);
      }
    }
  }
  void showTrail() {
    for (int i=0; i<radius; i++) {
      j[i] = j [i+1];
      k[i] = k [i+1];
      ellipse (j[i], k[i], i, i);
    }
    j[25] = pos.x;
    k[25] = pos.y;
  }
  void drawPlayer() {
    //draw the player normally
    if (!failing) {
      float rVal = pos.y / height;
      float bVal = 1 - (rVal / 10) ;
      fill(255*bVal, 255, 255*rVal, fadeValue);
      stroke(255*bVal, 255, 255*rVal, fadeValue);
      //println(255*bVal, 255, 255*rVal);
    }
    //draw the player with the faded color
    //else {
    //  fill(100, 255, 100, fadeValue);
    //}

    ellipse(pos.x, pos.y, radius+1, radius+1);
    noFill();
    ellipse(b.pos.x, b.pos.y, eRadius, eRadius);
    ellipse(b.pos.x, b.pos.y, eRadius-1, eRadius-1);
    ellipse(b.pos.x, b.pos.y, eRadius-2, eRadius-2);
  }

  void manageScore() {
    if (BelowMidLine()) {
      //score += 10;
      bmLevCount += 10;
    } else if (AboveMidLine()) {
      //score += 30 * bounceCounter;
      //midLevCount += 30 * bounceCounter;
      midLevCount += 30 ;
    } else if (TopLine()) {
      //score += 50 * bounceCounter;
      highLevCount += 50;
    }
  }
  void manageBonusCounter() {
    if (jump && eRadius >= 52 && (pos.x == 40 || pos.x == 440)) {
      noLoop();
      bounceCounter++;
      loop();
    } else {
      bounceCounter = 0;
    }
  }
}

boolean checkRadius() {
  return eRadius >= 52;
}

//if(b.BelowMidLine()){
//  failing = false;
//  failTimer = 0;
//  fadeValue = 255.0;

// b = //new Ball(40, 100, 26);