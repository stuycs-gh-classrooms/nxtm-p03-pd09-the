int NUM_ORBS = 10;
int MIN_SIZE = 10;
int MAX_SIZE = 60;
float MIN_MASS = 10;
float MAX_MASS = 100;
float G_CONSTANT = 1;
float D_COEF = 0.1;
float F_COEF = 900000;
int fMode;
int fPower;

int SPRING_LENGTH = 50;
float  SPRING_K = 0.005;

int MOVING = 0;
int SPRING = 1;
int GRAVITY = 2;
int DRAGF = 3;
int THEF = 4;
int COMBO = 5;
int BOUNCE = 6;
int LIGHT = 1;
int DARK = -1;
boolean[] toggles = new boolean[7];
String[] modes = {"Moving", "Spring", "Gravity", "Drag", "The Force", "Combination","bounce(?)"};

FixedOrb earth;
Orb[] orbs;
int orbCount;


void setup()
{
  size(600, 600);

  makeOrbs(true);
  earth = new FixedOrb(width/2, height/5, 100, 10);

  fMode = LIGHT;
  fPower = 1;
}//setup


void draw()
{
  background(255);
  displayMode();
  earth.display();

  for (int o=0; o < orbCount; o++) {
    orbs[o].display();

    if (o < orbCount - 1) {
      drawSpring(orbs[o], orbs[o+1]);
    }
  }//draw orbs & springs

  if (toggles[MOVING]) {
    if(toggles[SPRING]){
    applySprings();
    }


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
    if (int(random(2)) == 1) {
      println("light");
      charge = LIGHT;
    } else {
      charge = DARK;
      println("dark");
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
  if (toggles[THEF]) {
    applyTF(mouseX, mouseY);
    //println("pressed");
  }
}

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

void keyPressed()
{
  if (key == ' ') {
    toggles[MOVING]  = !toggles[MOVING];
  }
  if (key == '1') {
    
    toggles[GRAVITY] = true;
    toggles[THEF] = false;
    toggles[DRAGF] = false;
    toggles[SPRING] = false;
    toggles[COMBO] = false;
    makeOrbs(true);
  }
  if (key == '2') {
    toggles[SPRING]  = true;
    toggles[GRAVITY] = true;
    toggles[DRAGF] = false;
    toggles[THEF] = false;
    toggles[COMBO] = false;
    makeOrbs(true);
    
  }
  if (key == '3') {
    toggles[DRAGF]   = true;
    toggles[GRAVITY] = true;
    toggles[THEF] = false;
    toggles[SPRING] = false;
    toggles[COMBO] = false;
    makeOrbs(true);
  }
  if (key == '4') {
    toggles[THEF] = true;
    toggles[GRAVITY] = false;
    toggles[DRAGF] = false;
    toggles[SPRING] = false;
    toggles[COMBO] = false;
    makeOrbs(true);
  }
  if (key == '5') {
    toggles[THEF] = true;
    toggles[GRAVITY] = true;
    toggles[DRAGF] = true;
    toggles[SPRING] = true;
    toggles[COMBO] = true;
    makeOrbs(true);
  }
  if(key == '6'){
    toggles[BOUNCE] = !toggles[BOUNCE];
  }
  if (key == 'T') {
    makeOrbs(false);
  }

  if (key == '-') {
    orbCount -= 1;
  }//removal
  if (key == '+') {
    addOrb();
    //println("add");
  }//addition
  if (keyCode == SHIFT) {
    fMode *= -1;
  }
  if (keyCode == UP) {
    fPower += 10;
  }
  if (keyCode == DOWN) {
    fPower -= 10;
  }
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
    // force mode and power text
    if (m == THEF) {
      textSize(15);
      if (fMode == LIGHT) {
        text("The Force side: Light", x + 5, 20);
      } else if (fMode == DARK) {
        text("The Force side: Dark", x + 5, 20);
      }
      text("The Force Power: " + fPower, x+5, 40);
    }
    x+= w+5;
  }
}//display
