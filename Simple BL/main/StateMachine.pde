float fixDec(float n, int d) {
  return Float.parseFloat(String.format("%." + d + "f", n));
}
int seconds;
int minutes;

//MUSIC VARS
int currentSongIdx = 0;
Boolean musicPaused = false; 
int timer = millis();
Boolean releasedKey = true;

// GAME VARS
int move = 0;
int state = 0;
float score;
float percentCompletion;
Float fadeChange = 0.7;
// MENU VARS
int blinkColor;
int blinkChange = 5;
Boolean upPressed = false;
Boolean downPressed = false;

void gameStates()
{
  switch(state)
  {

  case 0:
    startOfGame = true;
    gameInit = true;
    background(0);
    //outt.mute();

    //DrawLines();
    stroke(255);
    line(40, 0, 40, height);
    line(440, 0, 440, height);
    // classicVi.drawEQ();

    textSize(50);

    //text("Top Line ", 80, ceilling);

    fill(50, 150, 255);
    //text(1 + ". " + songList[0] + "\n", width/2-textWidth(1 + ". " +songList[0]+ "\n")/2, height/2+42);
    text("BassLine\n\n", width/2-textWidth("BassLine\n\n")/2, height/4-100);

    textSize(15);

    if (keyPressed && releasedKey == true) {
      //If the user presses the right arrow, the next song in the array is played
      releasedKey = false;
      if (key == CODED) {
        if (keyCode == UP) {
          noLoop();
          upPressed = true;
          if (currentSongIdx < songList.length -1)
            currentSongIdx++;
          else if (currentSongIdx >= songList.length -1)
            currentSongIdx = 0;
        } else if (keyCode == DOWN) {
          downPressed = true;
          if (currentSongIdx > 0)
            currentSongIdx--;
          else if ( currentSongIdx <= 0 )
            currentSongIdx = 3;
        }
      }
    }

    text("Choose your song", width/2-textWidth("Choose your song")/2, 220);
    fill(0);
    stroke(255);
    //strokeWeight(1);
    if (upPressed == true)
      fill(255);
    triangle(width/2, height- 505, (width/2)-20, height- 485, (width/2)+20, height- 485);
    fill(0);
    if (downPressed == true)
      fill(255);
    triangle(width/2, height- 385, (width/2)-20, height- 405, (width/2)+20, height- 405);
    fill(0);
    rect(width-430, height- 470, 380, 50);

    fill(255);

    textSize(12);
    text(songList[currentSongIdx] + "\n", width/2-textWidth(currentSongIdx + ". " +songList[currentSongIdx]+ "\n")/2, height- 442);

    textSize(20);
    //Draws the blinking press enter key to start
    fill(blinkColor);
    text("Press Space to start", width/2-textWidth("Press Space to start")/2, height- 320);
    blinkColor+= blinkChange;
    if (blinkColor >= 255 || blinkColor <= 0)
      blinkChange = blinkChange* -1;

    loop();


    if (keyPressed) {
      if (key == ' ')
      {
        fill(255);
        text("Loading...", width/2-textWidth("loading...")/2, height - 200); 
        state = 1;
      }
    }


    break;
  case 1:
    seconds = (int)(ac.getTime()/(1000))%60;
    minutes = (int)(ac.getTime()/1000)/60;  
    percentCompletion = min(fixDec((float)(ac.getTime()/songRuntimes[currentSongIdx]), 2), 100);



    //b.manageScore();
    //fill(100, 255, 100);
    //text("Score: " + score, 20, 35);

    //If timer has been initiated (if the player hit the floor), start the fail timer, turn off timer start
    if (hitFloor) {
      //failTimer = millis();
      failing = true;
      hitFloor = false;
    }


    //if(timerStart){
    //  failTimer = millis();
    //  timerStart = false;    
    //}

    //If they are still failing (they have hit the floor and haven't risen above the midline) change the color of the ball from white to black
    if (failing) {
      //fadeValue -= abs(max(failTimer/10000,0));

      if (fadeValue >0)
        fadeValue -= fadeChange;
      if (fadeValue2 < 255)
        fadeValue2 += fadeChange;
      b.bounceCounts[3] -= 0.01;
      //println("fail timer: " + failTimer + " fade value: " + fadeValue + "fail penalty: " + b.bounceCounts[3]);
      //If the fail timer has been on for more than five seconds, end the game
      if (fadeValue <= 0) {
        state = 2;
      }
      //if the player was failing and they are now above the midline, then turn failing off and reset fail timer
      if (b.BelowMidLine()) {
        failing = false;
        failTimer = 0;
        fadeValue = 255.0;
      }
    }




    //println("game started");
    if (gameInit) {

      initMusic();

      println("game init current song idx: " + currentSongIdx);
      gameInit = false;
    }

    //if(start){
    //mp3.play();
    //mp3.mute();
    //}

    Game();
    fill(0, 0, 150);
    //text("Score: " + score , 50,40);
    //if (!(ac.isRunning())) {
    //  songEnded = true;

    //}

    //println("Play Test");


    break;
  case 2:
    //outt.mute();

    //mp3.close();
    //ac.reset();
    //frequencyEnvelope.clear();
    ac.stop();
    ac2.stop();
    //st.kill();




    seconds = (int)(ac.getTime()/(1000))%60;
    minutes = (int)(ac.getTime()/1000)/60;  
    //score = fixDec((float)(ac.getTime()/songRuntimes[currentSongIdx]),2);


    background(0);
    textSize(32);
    fill(255);

    //text("Hit any key to replay", width/2-textWidth("Hit any key to replay")/2, 200);
    //textSize(22);
    drawScore(minutes, seconds);
    //text("Current Time: " + minutes  + ":" + seconds , width/2-textWidth("Current Time: ")/2, height-190);
    //println("Current Time: " + minutes  + ":" + seconds);
    //text("Score: " + score, width/2-textWidth("Score: ")/2, height-160);

    fill(blinkColor);
    text("Press Enter to replay", width/2-textWidth("Press Enter to replay")/2, height/2 + 230);
    blinkColor+= blinkChange;
    if (blinkColor >= 255 || blinkColor <= 0)
      blinkChange = blinkChange* -1;
    //drawScore();
    //menuVi.drawEQ();

    if (keyPressed) {
      if (key == ENTER) {

        resetGame();
        //returnToPlay = true;
        //frequencyEnvelope.clear();
        //sp.kill();

        state = 0;
        //sp.reset();

        //sp.setToEnd();

        //restart = true;
      }
    }
    //println("Game Over");

    break;

  case 3: 
    drawGuides();
    Game();
    println("Debug");
    break;

  case 4:
    //print("\n\n\n\nstate 4 entered\n\n\n\n");
    ac.stop();
    ac2.stop();
    background(0);
    textSize(20);
    fill(255);
    //score = fixDec((float)(ac.getTime()/songRuntimes[currentSongIdx]),2);

    //text("Current Time: " + minutes  + ":" + seconds , width/2-textWidth("Current Time: ")/2, height-190);
    //println("Current Time: " + minutes  + ":" + seconds);
    //text("Score: " + score, width/2-textWidth("Score: ")/2, height-160);

    fill(blinkColor);
    text("Press Enter to return to the main menu", width/2-textWidth("Press Enter to return to the main menu")/2, height/2 + 230);
    blinkColor+= blinkChange;
    if (blinkColor >= 255 || blinkColor <= 0)
      blinkChange = blinkChange* -1;


    stroke(255);
    line(40, 0, 40, height);
    line(440, 0, 440, height);   

    drawScore(minutes, seconds);
    //text("Distance: " + score, width/2-textWidth("Distance: #")/2, height-100);

    if (keyPressed) {
      if (key == ENTER) {
        //frequencyEnvelope.clear();

        resetGame();

        state = 0;
      }
    }   
    break;
  }
}