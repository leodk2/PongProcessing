//buttons true/false for inputs
boolean keys[] = {false, false, false, false};

//player ball, and speed variables
float pSpeed; //player vertical speed
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


int winner = -1;//where the ball went in. Actually opposite of the winner
float acc = .25f; //game accelleration whenever ball is hit

void setup() {
  size(600,400); //room size
  init(); //initialize

}

void draw() {
  
  //background and stuff
  background(0,0,0);
  fill(255,255,255); //white draw color
  rect(roomW/2-4, 0, 8, roomH); //middle bar
  
  //players
  
  //p1 move
  if (keys[0] == true) { //up
    p1[1] -= pSpeed;
  }
  if (keys[1] == true) { //down
    p1[1] += pSpeed;
  }
  p1[1] = constrain(p1[1],0,roomH-p1[3]); //keep within room
  
  //p2 move
  if (keys[2] == true) { //up
    p2[1] -= pSpeed;
  }
  if (keys[3] == true) { //down
    p2[1] += pSpeed;
  }
  p2[1] = constrain(p2[1],0,roomH-p2[3]); //keep within room
  
  //ball
  
  //end walls
  if (ball[0] < 0){ //left side goal
    winner = 1;
    init();
  }
  else if (ball[0] > roomW) { //right side goal
    winner = -1;
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
}

void keyReleased() { //same as keypress, just releases them instead
  
  //p1
  if (key == 'w' || key == 'w') {
    keys[0] = false;
  }
  else if (key == 's' || key == 'S') {
    keys[1] = false;
  }
  
  //p2
  if (key == 'o' || key == 'O') {
    keys[2] = false;
  }
  else if (key == 'l' || key == 'L') {
    keys[3] = false;
  }
}

//initialize
void init() {
  print("init called\n"); //sanity check
  
  pSpeed = pSpeedd; //set player speed to default
  
  for (int i = 0; i < p1d.length; i++) { //set player 1 variables to default
    p1[i] = p1d[i];
  }
  
  for (int i = 0; i < p2d.length; i++) { //set player 2 variables to default
    p2[i] = p2d[i];
  }
  
  for (int i = 0; i < balld.length; i++) { //set ball variables to default
    ball[i] = balld[i];
  }
  ball[2] *= winner; //sets ball direction. add - in front of winner to give the other player the serve  
}
