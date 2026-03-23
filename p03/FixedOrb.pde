class FixedOrb extends Orb
{

  /**
   calls the orb() constructor, sets teh color to red
   */
  FixedOrb(float x, float y, float s, float m)
  {
    super(x, y, s, m);
    c = color(255, 0, 0);
  }

  /**
   YOUR CONCISE+CLEAR DESCRIPTION OF WHAT THIS METHOD DOES
   and/or
   WHY IT EXISTS
   
   default constructor, assigns random values
   */
  FixedOrb()
  {
    super();
    c = color(255, 0, 0);
  }

  /**
   YOUR CONCISE+CLEAR DESCRIPTION OF WHAT THIS METHOD DOES
   and/or
   WHY IT EXISTS
   
   override move() in orb so that fixed orb doestn move
   */
  void move(boolean bounce)
  {
    //do nothing
  }
}//fixedOrb
