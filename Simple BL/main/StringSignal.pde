import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.signals.*;

Minim minimc;
AudioOutput outt;
StringSignal signal;

Line ll;
Line rl;

float[] xc;
float[] Xcopy;
float[] v;
float[] f;
float kc = 0.5;
float cc = 0.0003;
int num = 256;
int monitorPoint = num/18;

class StringSignal implements AudioSignal {
  void generate(float[] samp) {
    for (int i=0; i<samp.length; i++) {
      samp[i] = xc[monitorPoint];
      stringUpdate();
    }
  }
  void generate(float[] left, float[] right) {
    for (int i=0; i<left.length; i++) {
      left[i] = xc[monitorPoint];
      right[i] = xc[monitorPoint];
      stringUpdate();
    }
  }
}
void initString() {
  minimc = new Minim(this);
  outt = minimc.getLineOut();
  signal = new StringSignal();
  outt.addSignal(signal);
  stroke(255);
  //  smooth();
  ellipseMode(CENTER);
  noFill();
  xc = new float[num];
  Xcopy = new float[num];
  v = new float[num];
  f = new float[num];
}
void drawStringR() {
  pushMatrix();
  //strokeWeight(1.5);
  //if (keyPressed) {
  //  if (key == 'b' && eRadius >= 52 && (b.leftB() || b.rightB()) ) {
  //  //if (key == 'b' && check) {
  //    stroke(1, 255, 1);
  //  } else if (key == 'b' && !(eRadius >= 52)) {
  //    stroke(255, 1, 1);
  //  }
  //} else {
  //  //if (eRadius >= 52) {
  //  //  stroke(255, 1, 1);
  //  //} else {
  //  //  stroke(255);
  //  //}
  //  stroke(255);
  //}
  if(!failing)
    stroke(255);
  else
    stroke(fadeValue); 
  translate (200, 1);
  arrayCopy(xc, Xcopy);
  for (int i=1; i<num; i++) {
    //line(float(i-1)/(num-1)*width, (0.5+Xcopy[i-1]*0.5)*height, 
    //  float(i)/(num-1)*width, (0.5+Xcopy[i]*0.5)*height);
    line( (0.5+Xcopy[i-1]*0.5)*width, float(i-1)/(num-1)*height, 
      (0.5+Xcopy[i]*0.5)*width, float(i)/(num-1)*height);
  }
  //ellipse((0.5+Xcopy[monitorPoint]*0.5)*width, b.pos.y, 10, 10);
  popMatrix();
}
void drawStringL() {
  pushMatrix();
  //strokeWeight(1.5);
  //if (keyPressed) {
  //  if (key == 'b' && eRadius >= 52 && (b.leftB() || b.rightB()) ) {
  //  //if (key == 'b' && check) {
  //    stroke(1, 255, 1);
  //  } else if (key == 'b' && !(eRadius >= 52)) {
  //    stroke(255, 1, 1);
  //  }
  //} else {
  //  //if (eRadius >= 52) {
  //  //  stroke(255, 1, 1);
  //  //} else {
  //  //  stroke(255);
  //  //}
  //  stroke(255);
  //}
  if(!failing)
    stroke(255);
  else
    stroke(fadeValue);
    
  translate (-200, 1);
  arrayCopy(xc, Xcopy);
  for (int i=1; i<num; i++) {
    //line(float(i-1)/(num-1)*width, (0.5+Xcopy[i-1]*0.5)*height, 
    //  float(i)/(num-1)*width, (0.5+Xcopy[i]*0.5)*height);
    line( (0.5+Xcopy[i-1]*0.5)*width, float(i-1)/(num-1)*height, 
      (0.5+Xcopy[i]*0.5)*width, float(i)/(num-1)*height);
  }
  //ellipse((0.5+Xcopy[monitorPoint]*0.5)*width, b.pos.y, 10, 10);
  popMatrix();
}
void stringUpdate() {
  for (int i=1; i<num; i++) {
    float F = (xc[i]-xc[i-1])*kc+(v[i]-v[i-1])*cc;
    f[i-1] += F;
    f[i] -= F;
  }
  for (int i=0; i<num; i++) {
    v[i] += f[i];
    f[i] = 0;
    xc[i] += v[i];
    xc[i] = constrain(xc[i], -1, 1);
  }
  xc[0] = 0;
  v[0] = 0;
  xc[num-1] = 0;
  v[num-1] = 0;
  //  v[num-2] = 0;
  press();
}
void press() {
  float bc = constrain(1f*(155+0.5)/width*(num-1), 0, num-1);
  int a = floor(bc);
  int c = ceil(bc);
  int r = (int)random(height/2 - 10, height/2 + 10);
  if (keyPressed) {
    if ((key == ' ' || key == 'b') && eRadius >= 52) {
      float X = xc[a]+(xc[c]-xc[a])*(bc-a);
      float Xm = float(r)/(height/2)-1;
      float F = (Xm-X)*1f;
      float Fa = (c-bc)*F;
      float Fc = (bc-a)*F;
      f[a] += Fa;
      f[c] += Fc;
    } else if ((key == ' ' || key == 'b') && !(eRadius >= 52)) {
      float V = v[a]+(v[c]-v[a])*(bc-a);
      float F = V*-0.95;
      float Fa = (c-bc)*F;
      float Fc = (bc-a)*F;
      f[a] += Fa;
      f[c] += Fc;
    }
  } else {
    float V = v[a]+(v[c]-v[a])*(bc-a);
    float F = V*-0.95;
    float Fa = (c-bc)*F;
    float Fc = (bc-a)*F;
    f[a] += Fa;
    f[c] += Fc;
  }
}