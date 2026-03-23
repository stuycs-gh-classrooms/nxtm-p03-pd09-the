class Orb
{

  //instance variables
  PVector center;
  PVector velocity;
  PVector acceleration;
  float bsize;
  float mass;
  color c;


  /**
   YOUR CONCISE+CLEAR DESCRIPTION OF WHAT THIS CONSTRUCTOR DOES
   and/or
   WHY IT EXISTS
   
   initializes the position, size, and mass of the orb with random numbers within ar ange
   */
  Orb()
  {
    bsize = random(10, MAX_SIZE);
    float x = random(bsize/2, width-bsize/2);
    float y = random(bsize/2, height-bsize/2);
    center = new PVector(x, y);
    mass = random(10, 100);
    velocity = new PVector();
    acceleration = new PVector();
    setColor();
  }


  /**
   YOUR CONCISE+CLEAR DESCRIPTION OF WHAT THIS CONSTRUCTOR DOES
   and/or
   WHY IT EXISTS
   
   initializes the position, size, and mass of the orb with inputted values
   */
  Orb(float x, float y, float s, float m)
  {
    bsize = s;
    mass = m;
    center = new PVector(x, y);
    velocity = new PVector();
    acceleration = new PVector();
    setColor();
  }


  /**
   YOUR CONCISE+CLEAR DESCRIPTION OF WHAT THIS METHOD DOES
   and/or
   WHY IT EXISTS
   
   bounces off edges and changes position based on acceleration and velocity
   */
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


  /**
   YOUR CONCISE+CLEAR DESCRIPTION OF WHAT THIS METHOD DOES
   and/or
   WHY IT EXISTS
   
   appplies force by adding it to the acceleartion
   */
  void applyForce(PVector force)
  {
    PVector scaleForce = force.copy();
    scaleForce.div(mass);
    acceleration.add(scaleForce);
  }


  /**
   YOUR CONCISE+CLEAR DESCRIPTION OF WHAT THIS METHOD DOES
   and/or
   WHY IT EXISTS
   
   calculate the drag force on the orb
   */
  PVector getDragForce(float cd)
  {
    float dragMag = velocity.mag();
    dragMag = -0.5 * dragMag * dragMag * cd;
    PVector dragForce = velocity.copy();
    dragForce.normalize();
    dragForce.mult(dragMag);
    return dragForce;
  }


  /**
   YOUR CONCISE+CLEAR DESCRIPTION OF WHAT THIS METHOD DOES
   and/or
   WHY IT EXISTS
   
   calculate the gravity exerted on the orb from another orb
   */
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

  /**
   getSpring()
   
   This should calculate the force felt on the calling object by
   a spring between the calling object and other.
   
   The resulting force should pull the calling object towards
   other if the spring is extended past springLength and should
   push the calling object away from o if the spring is compressed
   to be less than springLength.
   
   F = kx (ABhat)
   k: Spring constant
   x: displacement, the difference of the distance
   between A and B and the length of the spring.
   (ABhat): The normalized vector from A to B
   */
  PVector getSpring(Orb other, int springLength, float springK)
  {
    PVector direction = PVector.sub(other.center, center);
    direction.normalize();

    float displacement = center.dist(other.center) - springLength;
    float mag = springK * displacement;
    direction.mult(mag);

    return direction;
  }//getSpring


  /**
   YOUR CONCISE+CLEAR DESCRIPTION OF WHAT THIS METHOD DOES
   and/or
   WHY IT EXISTS
   
   reverses y velocity when hitting an edge so that the orb bounces off
   */
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


  /**
   YOUR CONCISE+CLEAR DESCRIPTION OF WHAT THIS METHOD DOES
   and/or
   WHY IT EXISTS
   
   reverses x velocity when hitting an edge so that the orb bounces off
   */
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


  /**
   YOUR CONCISE+CLEAR DESCRIPTION OF WHAT THIS METHOD DOES
   and/or
   WHY IT EXISTS
   
   checks if the edges of two orbs are touching each other
   */
  boolean collisionCheck(Orb other)
  {
    return ( this.center.dist(other.center)
      <= (this.bsize/2 + other.bsize/2) );
  }//collisionCheck


  /**
   YOUR CONCISE+CLEAR DESCRIPTION OF WHAT THIS METHOD DOES
   and/or
   WHY IT EXISTS
   
   sets color based on density (?)
   */
  void setColor()
  {
    color c0 = color(0, 255, 255);
    color c1 = color(0);
    /*
    YOUR CONCISE EXPLANATION IN COLLOQUIAL ENGLISH 
    OF WHAT THIS PROCESSING BUILT-IN DOES...
    */
    c = lerpColor(c0, c1, (mass-MIN_SIZE)/(MAX_MASS-MIN_SIZE));
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
}//Ball
