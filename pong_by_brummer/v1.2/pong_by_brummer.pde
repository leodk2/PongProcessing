//buttons true/false for inputs
boolean keys[] = {false, false, false, false, false, false, false}; //p1 up (w), p1 down (s), p2 up (o), p2 down (l), select (space), start (enter), back (backspace) 
boolean keysUsed[] = {false, false, false, false, false, false, false, false}; //same as above

//player ball, and speed variables
float pSpeed; //player vertical speed
int p1score;
int p2score;
int p1[] = {0,0,0,0}; //player one variables
int p2[] = {0,0,0,0}; //player two variables
float ball[] = {0,0,0,0,0}; //ball variables

// room height and width
int roomW = 600;
int roomH = 400;

//default vales for players and ball
float pSpeedd = 4;
int p1d[] = {50, roomH/2-50, 15, 100}; //x, y, width, height
int p2d[] = {roomW-50, roomH/2-50, 15, 100}; //x, y, width, height
float balld[] = {roomW/2, roomH/2, 1.5, 0, 3}; //x, y, x dir and multiplier, y dir and multiplier, speed

int winner = -1; //where the ball went in. Actually opposite of the winner
float acc = .25f; //game accelleration whenever ball is hit

//mod variables
int modReverse = 1;
int modThinHeight = 30;

//menu
boolean settings[] = {false, false, false, false, false}; //epilepsy mode, other things..?
String settingsName[] = {"LSD", "reverse", "xtra thin", "placeholder (no effect)", "reset"}; //reset
int highlighted = 0; 
boolean inMenu = true;

void setup() {
  size(600,400); //room size
  init(); //initialize

}

void draw() {
  if (inMenu) {
    background(0,0,0); //background
    textAlign(CENTER, CENTER);
    textSize(30);
    
    for (int i = 0; i < settings.length; i++) {
      
      //colors
      if (i == highlighted) {
        fill(255,255,255);
      }
      else if (settings[i]) {
        fill(50,255,50);
      }
      else {
        fill(128, 128, 128);
      }
      text(settingsName[i], roomW/2, roomH/(settings.length+1) * (i+1));
    }
    
    if (keys[0] && !keysUsed[0]) { //move up
      keysUsed[0] = true;
      highlighted--;
    }
    if (keys[1] && !keysUsed[1]) { //move down
      keysUsed[1] = true;
      highlighted++;
    }
    highlighted = constrain(highlighted, 0, settings.length-1);
    
    if (keys[4] && !keysUsed[4]) {
      keysUsed[4] = true;
      if (settings[highlighted]) {
        settings[highlighted] = false;
      }
      else {
        settings[highlighted] = true;
      }
    }
    //go to game. Set variables
    if (keys[5] && !keysUsed[5]) {
      keysUsed[5] = true;
      inMenu = false;
      
      //mod variables
      //reverse
      if (settings[1]) {
        modReverse = -1;
      }
      else {
        modReverse = 1;
      }
      //xtra thin
      if (settings[2]) {
        p1[3] = modThinHeight;
        p2[3] = modThinHeight;
      }
      else {
        p1[3] = p1d[3];
        p2[3] = p2d[3];
      }
      if (settings[settings.length-1]) {
        init();
        p1score = 0;
        p1score = 0;
        settings[settings.length-1] = false;
      }
    }
    
  }
  else {
    //draw behind gameplay
    background(0,0,0); //background
    
    if (settings[0]) { //lsd setting
      fill((int)random(255),(int)random(255),(int)random(255)); //random color
    }
    else {
      fill(255,255,255); //white draw color
    }
    
    rect(roomW/2-4, 0, 8, roomH); //middle bar
    textAlign(CENTER, CENTER);
    textSize(30);
    text(p1score, roomW/4, roomH/8);
    text(p2score, roomW/4*3, roomH/8);
    
    
    //players
    
    //p1 move
    if (keys[0] == true) { //up
      p1[1] -= pSpeed * modReverse;
    }
    if (keys[1] == true) { //down
      p1[1] += pSpeed * modReverse;
    }
    p1[1] = constrain(p1[1],0,roomH-p1[3]); //keep within room
    
    //p2 move
    if (keys[2] == true) { //up
      p2[1] -= pSpeed * modReverse;
    }
    if (keys[3] == true) { //down
      p2[1] += pSpeed * modReverse;
    }
    p2[1] = constrain(p2[1],0,roomH-p2[3]); //keep within room
    
    //ball
    
    //end walls
    if (ball[0] < 0){ //left side goal
      winner = 1;
      p2score++;
      init();
    }
    else if (ball[0] > roomW) { //right side goal
      winner = -1;
      p1score++;
      init();
    }
    //up down wall
    if (ball[1] != constrain(ball[1], 0, roomH)) {
      ball[3] = -ball[3];
    }
    
    //p1 collision
    if ( (ball[0] == constrain(ball[0], p1[0], p1[0]+p1[2]) && ball[1] == constrain(ball[1], p1[1], p1[1]+p1[3])) ){ //if ball xy is inside player 1
      if (ball[1] >= p1[1]+p1[3]/2) { // if ball hit lower half of player 1
        ball[3] = 1 - ( (p1[1]+p1[3])-ball[1] ) / p1[3]; //math stuff to set y dir / angle of ball
      }
      else { // if ball hit upper half of player 1
        ball[3] = -( (p1[1]+p1[3]/2)-ball[1] ) / (p1[3]/2); //math stuff to set y dir / angle of ball
      }
      ball[3] *= 1.2; //angle amplifier. Hardcoded idgaf
      ball[2] = 2-abs(ball[3]); //makes xy dir = 2 so that speed is the same regardless of y / angle.
      ball[4] += acc; //ball speed increase
      pSpeed += acc; //player speed increase
    }
    //p2 collision
    if ( (ball[0] == constrain(ball[0], p2[0], p2[0]+p2[2]) && ball[1] == constrain(ball[1], p2[1], p2[1]+p2[3])) ){ //if ball xy is inside player 2
      if (ball[1] >= p2[1]+p2[3]/2) { // if ball hit lower half of player 2
        ball[3] = 1 - ( (p2[1]+p2[3])-ball[1] ) / p2[3]; //math stuff to set y dir / angle of ball
      }
      else { // if ball hit lower half of player 2
        ball[3] = -( (p2[1]+p2[3]/2)-ball[1] ) / (p2[3]/2); //math stuff to set y dir / angle of ball
      }
      ball[3] *= 1.2; //angle amplifier. Hardcoded idgaf
      ball[2] = -2+abs(ball[3]); //makes xy dir = 2 so that speed is the same regardless of y / angle.
      ball[4] += acc; //ball speed increase
      pSpeed += acc; // player speed increase
    }
    
    ball[0] += ball[2]*ball[4]; //moves ball on x. 4 is speed.
    ball[1] += ball[3]*ball[4]; //moves ball on x. 4 is speed.
    
    
    //draw players
    rect(p1[0], p1[1], p1[2], p1[3]);
    rect(p2[0], p2[1], p2[2], p2[3]);
    //draw ball
    ellipse(ball[0], ball[1], 10, 10);
    
    
    
    //back to menu
    if (keys[6] && !keysUsed[6]) {
      keysUsed[6] = true;
      inMenu = true;
      print("inMenu");
    }
    
    
  }
}

void keyPressed() { //keypresses should be self explanatory
  //p1
  if (key == 'w' || key == 'w') {
    keys[0] = true;
  }
  else if (key == 's' || key == 'S') {
    keys[1] = true;
  }
  
  //p2
  if (key == 'o' || key == 'O') {
    keys[2] = true;
  }
  else if (key == 'l' || key == 'L') {
    keys[3] = true;
  }
  
  //menu
  if (key == ' ') {
    keys[4] = true;
  }
  if (key == ENTER) {
    keys[5] = true;
  }
  if (key == BACKSPACE) {
    keys[6] = true;
  }
}

void keyReleased() { //same as keypress, just releases them instead
  //p1
  if (key == 'w' || key == 'W') {
    keys[0] = false;
    keysUsed[0] = false;
  }
  else if (key == 's' || key == 'S') {
    keys[1] = false;
    keysUsed[1] = false;
  }
  
  //p2
  if (key == 'o' || key == 'O') {
    keys[2] = false;
    keysUsed[2] = false;
  }
  else if (key == 'l' || key == 'L') {
    keys[3] = false;
    keysUsed[3] = false;
  }
  
  //menu
  if (key == ' ') {
    keys[4] = false;
    keysUsed[4] = false;
  }
  if (key == ENTER) {
    keys[5] = false;
    keysUsed[5] = false;
  }
  if (key == BACKSPACE) {
    keys[6] = false;
    keysUsed[6] = false;
  }
}



//initialize
void init() {
  print("init(); called\n"); //sanity check
  print("p1: " + p1score + "\n");
  print("p1: " + p2score + "\n");
  
  pSpeed = pSpeedd; //set player speed to default
  
  for (int i = 0; i < p1d.length; i++) { //set player 1 variables to default
    p1[i] = p1d[i];
  }
  
  for (int i = 0; i < p2d.length; i++) { //set player 2 variables to default
    p2[i] = p2d[i];
  }
  if (settings[2]) {
    p1[3] = modThinHeight;
    p2[3] = modThinHeight;
  }
  
  
  for (int i = 0; i < balld.length; i++) { //set ball variables to default
    ball[i] = balld[i];
  }
  ball[2] *= winner; //sets ball direction. add - in front of winner to give the other player the serve  
}
