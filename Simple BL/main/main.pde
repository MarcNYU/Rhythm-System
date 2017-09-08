import beads.*;
import org.jaudiolibs.beads.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

AudioContext ac; // create our AudioContext
AudioContext ac2;

Float fadeValue;
Float fadeValue2;
Boolean timerStart; 
Integer failTimer;
Boolean failing;
Boolean hitFloor;

Boolean playtest;

String[] songList = new String[5];
String song1 = "Grapevine vs. Feel Good Inc (Demo).mp3";
String song2 = "Lean On (Demo).mp3";  
String song3 = "Twenty One Pilots - Stressed Out (Demo).mp3";
String song4 = "SKRILLEX - BANGARANG (Demo).mp3";
String song5 = "Marlon Roudette - When The Beat Drops Out (Demo).mp3";


Integer[] songRuntimes = new Integer[5];

//full length runtime

//Integer sLen1 = 180000 + 42000;//00:03:42 = (180,000 + 42000)
//Integer sLen2 = 120000 + 58000;//00:02:58 = (120,000 + 58000)
//Integer sLen3 = 180000 + 20000;//00:03:20 = (180,000 + 20000)
//Integer sLen4 = 180000 + 44000;//00:03:36 = (180,000 + 36000)

Integer sLen1 = 60000 + 56000;//00:03:42 = (60,000 + 53000)
Integer sLen2 = 60000 + 11000;//00:01:08 = (60,000 + 8000)
Integer sLen3 = 60000 + 11000;//00:03:20 = (60,000 + 8000)
Integer sLen4 = 60000 + 21000;//00:01:18 = (60,000 + 18000)
Integer sLen5 = 60000 + 36000;//00:01:33 = (60,000 + 33000)

//Abridged Versions

//Integer sLen1 = 60000; //+ 42000;//00:03:42 = (180,000 + 42000)
//Integer sLen2 = 60000;// + 58000;//00:02:58 = (120,000 + 58000)
//Integer sLen3 = 60000 ;//+ 20000;//00:03:20 = (180,000 + 20000)
//Integer sLen4 = 60000; //+ 44000;//00:03:36 = (180,000 + 36000)

Boolean songChosen = false;


void setup() {
  //fullScreen();
  surface.setResizable(true);
  size(480, 852);
  frameRate(60);
  noiseDetail(8);
  songList[0] = song1;
  songList[1] = song2;
  songList[2] = song3;
  songList[3] = song4;
  songList[4] = song5;
  songRuntimes[0] = sLen1;
  songRuntimes[1] = sLen2;
  songRuntimes[2] = sLen3;
  songRuntimes[3] = sLen4;
  songRuntimes[4] = sLen5;
  ac = new AudioContext();
  volume = 1;
  gameStates();
  initGame();
  initString();
  initRipples();
  fadeValue = 255.0;
  fadeValue2 = 0.0;
  timerStart = false;
  failTimer = 0;
  failing = false;
  hitFloor = false;
  playtest = true;
  //background(0);
}

void draw() {
  background(0);
  outt.mute();
  if( ac.getTime() > songRuntimes[currentSongIdx] && !startOfGame){
       //songEnded = false;
     //else if( ac.getTime() > 5000){    
      // println("song ended");
       state = 4;
      
       
     }
  gameStates();

  if (keyPressed ) {
    if (key == 'd') {
      state = 3;
    } else if (key == 'o') {
      state = 1;
    }
  }
}