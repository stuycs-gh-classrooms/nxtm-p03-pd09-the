class Orb
{

  //instance variables
  PVector center;
  PVector velocity;
  PVector acceleration;
  float bsize;
  float mass;
  color c;
  int charge;

  Orb()
  {

    bsize = random(10, MAX_SIZE);
    if (int(random(2)) == 0) {
      println("hi");
      charge = DARK;
    } else {
      charge = LIGHT;
      println("hello");
    }
    float x = random(bsize/2, width-bsize/2);
    float y = random(bsize/2, height-bsize/2);
    center = new PVector(x, y);
    mass = random(10, 100);
    velocity = new PVector();
    acceleration = new PVector();
    setColor();
  }

  Orb(float x, float y, float s, float m, int ch)
  {
    charge = ch;
    bsize = s;
    mass = m;
    center = new PVector(x, y);
    velocity = new PVector();
    acceleration = new PVector();
    setColor();
  }

  void move(boolean bounce)
  {
    if (bounce) {
      xBounce();
      yBounce();
    }

    velocity.add(acceleration);
    center.add(velocity);
    acceleration.mult(0);
  }//move

  void applyForce(PVector force)
  {
    PVector scaleForce = force.copy();
    scaleForce.div(mass);
    acceleration.add(scaleForce);
  }

  PVector getTF(float cf, PVector mouseLoc) {
    PVector theForce = new PVector(0, 0, 0);
    println("getTF mouseLoc:" + mouseLoc);
    PVector direction = PVector.sub(center, mouseLoc);
    direction.normalize();

    float rad =  mouseLoc.dist(this.center);
    rad*= rad;
    if (rad > 10000) {
      theForce = direction.mult((cf * charge * fMode * fPower) / rad);
    }
    else {
     theForce = new PVector(0, 0, 0);
    }
    return theForce;
    //PVector theForce = velocity.copy();
    //theForce.normalize();
    // println(theForce);
    //theForce.mult(((cf*this.charge*fMode)/rad));
    //println(theForce);
    //return(theForce);
  }


  PVector getDragForce(float cd)
  {
    float dragMag = velocity.mag();
    dragMag = -0.5 * dragMag * dragMag * cd;
    PVector dragForce = velocity.copy();
    dragForce.normalize();
    dragForce.mult(dragMag);
    return dragForce;
  }

  PVector getGravity(Orb other, float G)
  {
    float strength = G * mass*other.mass;
    //dont want to divide by 0!
    float r = max(center.dist(other.center), MIN_SIZE);
    strength = strength/ pow(r, 2);
    PVector force = other.center.copy();
    force.sub(center);
    force.mult(strength);
    return force;
  }

  PVector getSpring(Orb other, int springLength, float springK)
  {
    PVector direction = PVector.sub(other.center, center);
    direction.normalize();

    float displacement = center.dist(other.center) - springLength;
    float mag = springK * displacement;
    direction.mult(mag);

    return direction;
  }//getSpring


  boolean yBounce()
  {
    if (center.y > height - bsize/2) {
      velocity.y *= -1;
      center.y = height - bsize/2;

      return true;
    }//bottom bounce
    else if (center.y < bsize/2) {
      velocity.y*= -1;
      center.y = bsize/2;
      return true;
    }
    return false;
  }//yBounce

  boolean xBounce()
  {
    if (center.x > width - bsize/2) {
      center.x = width - bsize/2;
      velocity.x *= -1;
      return true;
    } else if (center.x < bsize/2) {
      center.x = bsize/2;
      velocity.x *= -1;
      return true;
    }
    return false;
  }//xbounce

  boolean collisionCheck(Orb other)
  {
    return ( this.center.dist(other.center)
      <= (this.bsize/2 + other.bsize/2) );
  }//collisionCheck

  void setColor()
  {
    color c0 = color(0, 255, 255);
    color c1 = color(0);
    c = lerpColor(c0, c1, (mass-MIN_SIZE)/(MAX_MASS-MIN_SIZE));

    // test
    if (charge == LIGHT) {
      c = color(181);
    } else {
      c = color(0);
    }
  }//setColor


  //visual behavior
  void display()
  {
    noStroke();
    fill(c);
    circle(center.x, center.y, bsize);
    fill(0);
    //text(mass, center.x, center.y);
  }//display
}//Ballclass Orb
