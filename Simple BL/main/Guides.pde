// GUIDE VARS
float ceilling = 160;
float ground = 740;
float dropLine = 700;
float safeLine = 600;
float middle = 360;
float left = 40;
float right = 440;
float alphaVal = 255;
float prevPos = ceilling;

void drawGuides() {

  if (!failing) {
    stroke(#FFFFFF, 100);
  } else {
    stroke(#FFFFFF, fadeValue);
  }

  line(0, ground, width, ground);

  line(0, ceilling, width, ceilling);

  line(0, middle, width, middle);

  line(0, dropLine, width, dropLine);

  line(0, safeLine, width, safeLine);

  //line(left-30, 0, left-30, height);
  ////line(width/2 - 200, 0, width/2 -200, height);
  //line(left, 0, left, height);

  //line(right, 0, right, height);
  ////line(width/2 + 200, 0, width/2 + 200, height);
  //line(right+30, 0, right+30, height);
}

void BG() {
  //fill(0, 150, 255);
  //rect(40, 0, 400, ceilling);
  //fill(0, 100, 205);
  //rect(40, ceilling, 400, 210);
  //fill(0, 50, 155);
  //rect(40, middle, 400, 250);
  //fill(0, 0, 105);
  //rect(40, safeLine, 400, 100);

  noStroke();
  if (b.pos.y < ceilling) {
    fill(0, 150, 255);
    rect(0, 0, width, ceilling);

    fill(0, 100, 205);
    rect(0, ceilling, width, 210);

    fill(0, 50, 155);
    rect(0, middle, width, 250);

    fill(0, 0, 105);
    rect(0, safeLine, width, 100);
  } else if (b.pos.y < middle && b.pos.y > ceilling) {
    if (prevPos < ceilling)
      alphaVal = 255;
    fill(0, 150, 255, alphaVal);
    rect(0, 0, width, ceilling);
    alphaVal -= 25;

    fill(0, 100, 205);
    rect(0, ceilling, width, 210);

    fill(0, 50, 155);
    rect(0, middle, width, 250);

    fill(0, 0, 105);
    rect(0, safeLine, width, 100);
  } else if (b.pos.y < safeLine && b.pos.y > middle) {
    if (prevPos < middle)
      alphaVal = 255;
    fill(0, 100, 205, alphaVal);
    rect(0, ceilling, width, 210);
    alphaVal -= 25;

    fill(0, 50, 155);
    rect(0, middle, width, 250);

    fill(0, 0, 105);
    rect(0, safeLine, width, 100);
  } else if (b.pos.y < dropLine && b.pos.y > safeLine) {
    if (prevPos < safeLine)
      alphaVal = 255;
    fill(0, 50, 155, alphaVal);
    rect(0, middle, width, 250);
    alphaVal -= 25;

    fill(0, 0, 105);
    rect(0, safeLine, width, 100);
  }
  fill(0, 0, 20);
  rect(0, dropLine, width, height);
  prevPos = b.pos.y;
}