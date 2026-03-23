int NUM_ORBS = 10;
int MIN_SIZE = 10;
int MAX_SIZE = 60;
float MIN_MASS = 10;
float MAX_MASS = 100;
float G_CONSTANT = 1;
float D_COEF = 0.1;
float F_COEF = 9000000;

int SPRING_LENGTH = 50;
float  SPRING_K = 0.005;

int MOVING = 0;
int BOUNCE = 1;
int GRAVITY = 2;
int DRAGF = 3;
boolean[] toggles = new boolean[4];
String[] modes = {"Moving", "Bounce", "Gravity", "Drag"};

FixedOrb earth;
Orb[] orbs;
int orbCount;


void setup()
{
  size(600, 600);

  //Part 0: Write makeOrbs below
  makeOrbs(true);
  //Part 3: create earth to simulate gravity
  earth = new FixedOrb(width/2, height/5, 100, 10);
}//setup


void draw()
{
  background(255);
  displayMode();
  earth.display();

  //draw the orbs and springs
  for (int o=0; o < orbCount; o++) {
    orbs[o].display();

    //Part 1: write drawSpring below
    //Use drawspring correctly to draw springs
    if (o < orbCount - 1) {
      drawSpring(orbs[o], orbs[o+1]);
    }
  }//draw orbs & springs

  if (toggles[MOVING]) {
    //Part 2: write applySprings below
    applySprings();


    //part 3: apply other forces if toggled on
    for (int o=0; o < orbCount; o++) {
      if (toggles[GRAVITY]) {
        //if (orbs[o] != null) {
        orbs[o].applyForce(orbs[o].getGravity(earth, G_CONSTANT));
        //}
      }
      if (toggles[DRAGF]) {
        orbs[o].applyForce(orbs[o].getDragForce(D_COEF));
      }
    }//gravity, drag

    for (int o=0; o < orbCount; o++) {
      orbs[o].move(toggles[BOUNCE]);
    }
  }//moving
}//draw


/**
 makeOrbs(boolean ordered)
 
 Set orbCount to NUM_ORBS
 Initialize and create orbCount Orbs in orbs.
 All orbs should have random mass and size.
 The first orb should be a FixedOrb
 If ordered is true:
 The orbs should be spaced SPRING_LENGTH distance
 apart along the middle of the screen.
 If ordered is false:
 The orbs should be positioned radomly.
 
 Each orb will be "connected" to its neighbors in the array.
 */
void makeOrbs(boolean ordered)
{

  float offset = 0;
  orbCount = NUM_ORBS;
  orbs = new Orb[orbCount];

  for (int i = 0; i < orbs.length; i++) {
    float s = random(MIN_SIZE, MAX_SIZE);
    float m = random(MIN_MASS, MAX_MASS);
    float x = offset;
    float y = height / 2;
    int charge;
    if (int(random(1)) == 1) {
      println("hi");
      charge = -1;
    } else {
      charge = 1;
      println("h");
    }

    if (ordered) {
      x += SPRING_LENGTH * i;
    } else {
      x = random(s, width - s);
      y = random(s, height - s);
    }

    if (i == 0) {
      offset = s;
      x += offset;
      orbs[i] = new FixedOrb(x, y, s, m);
      //earth = orbs[i];
    } else {
      orbs[i] = new Orb(x, y, s, m, charge);
    }
  }
}//makeOrbs


/**
 drawSpring(Orb o0, Orb o1)
 
 Draw a line between the two Orbs.
 Line color should change as follows:
 red: The spring is stretched.
 green: The spring is compressed.
 black: The spring is at its normal length
 */
void drawSpring(Orb o0, Orb o1)
{
  PVector a = o0.center;
  PVector b = o1.center;
  float dist = o0.center.dist(o1.center);

  if (dist > SPRING_LENGTH) {
    stroke(255, 0, 0);
  } else if (dist < SPRING_LENGTH) {
    stroke(0, 255, 0);
  } else if (dist == SPRING_LENGTH) {
    stroke(0);
  }

  line(a.x, a.y, b.x, b.y);
}//drawSpring


/**
 applySprings()
 
 FIRST: Fill in getSpring in the Orb class.
 
 THEN:
 Go through the Orbs array and apply the spring
 force correctly for each orb. We will consider every
 orb as being "connected" via a spring to is
 neighboring orbs in the array.
 */
void applySprings()
{
  PVector f = new PVector();

  for (int i = 0; i < orbCount; i++) {
    if (i - 1 > -1) {
      f = orbs[i].getSpring(orbs[i-1], SPRING_LENGTH, SPRING_K);
      orbs[i].applyForce(f);
    }
    if (i + 1 < orbCount) {
      f = orbs[i].getSpring(orbs[i+1], SPRING_LENGTH, SPRING_K);
      orbs[i].applyForce(f);
    }
  }
}//applySprings

void applyTF(float mx, float my) {
  PVector mLoc = new PVector(mx, my);
  for (int i = 0; i < orbCount; i++) {
    orbs[i].applyForce(orbs[i].getTF(F_COEF, mLoc));
  }
}

void mousePressed() {
  //if toggled
  applyTF(mouseX, mouseY);
  println("pressed");
}


/**
 addOrb()
 
 Add an orb to the arry of orbs.
 
 If the array of orbs is full, make a
 new, larger array that contains all
 the current orbs and the new one.
 (check out arrayCopy() to help)
 */
void addOrb()
{
  if (orbCount == orbs.length) { // array full
    Orb[] newOrbs = new Orb[orbCount + 1];
    arrayCopy(orbs, newOrbs);
    orbs = newOrbs;
  }
  //else {
  orbs[orbCount] = new Orb();
  orbCount += 1;
  //}
}//addOrb


/**
 keyPressed()
 
 Toggle the various modes on and off
 Use 1 and 2 to setup model.
 Use - and + to add/remove orbs.
 */
void keyPressed()
{
  if (key == ' ') {
    toggles[MOVING]  = !toggles[MOVING];
  }
  if (key == 'g') {
    toggles[GRAVITY] = !toggles[GRAVITY];
  }
  if (key == 'b') {
    toggles[BOUNCE]  = !toggles[BOUNCE];
  }
  if (key == 'd') {
    toggles[DRAGF]   = !toggles[DRAGF];
  }
  if (key == '1') {
    makeOrbs(true);
  }
  if (key == '2') {
    makeOrbs(false);
  }

  if (key == '-') {
    //Part 4: Write code to remove an orb from the array
    orbCount -= 1;
  }//removal
  if (key == '+') {
    //Part 4: Write addOrb() below
    addOrb();
    //println("add");
  }//addition
}//keyPressed



void displayMode()
{
  textAlign(LEFT, TOP);
  textSize(20);
  noStroke();
  int spacing = 85;
  int x = 0;

  for (int m=0; m<toggles.length; m++) {
    //set box color
    if (toggles[m]) {
      fill(0, 255, 0);
    } else {
      fill(255, 0, 0);
    }

    float w = textWidth(modes[m]);
    rect(x, 0, w+5, 20);
    fill(0);
    text(modes[m], x+2, 2);
    x+= w+5;
  }
}//display
