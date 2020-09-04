class Ally {
  float allySize = 25;
  float x = width+300;  //It will spawn from outside of the right window 
  float y = intHeight + 40;  //y-pos will be below the scoreboard panel
  float velocity = 1;
  int power;  //What power it is dropping

  float x1;
  float y1;
  float x2;
  float y2;
  float x3;
  float y3;

  public Ally(int powerUp) {
    this.power = powerUp;
  }
  public void draw() {
    float rad = allySize+5;
    x1 = x-rad;
    y1 = y+allySize;
    x2 = x;
    y2 = y-allySize;
    x3 = x+rad;
    y3 = y+allySize;
    strokeWeight(random(4, 8));
    stroke(255, 195, 50);
    fill(255, 240, 189, 75);
    triangle(x1, y1, x2, y2, x3, y3);
    x -= velocity;
  }

  /**
   * Returns area of a triangle given its 3 points
   */
  public float findArea(float x1, float y1, float x2, float y2, float x3, float y3) {
    float area = (x1*(y2-y3)+x2*(y3-y1)+x3*(y1-y2))/2;
    return abs(area);
  }
  /**
   *  Checks if the ammo's coordinates are inside the alien i.e. checks for collision.
   *  This is done by creating segment triangles and checking the total area of the segments and seeing if
   *  that area matches up with the alien's area.
   */
  public boolean collidesWith(Ammo a) {
    //P = ammo coordinates
    float ammoX = a.x;
    float ammoY = a.topY();
    float og = findArea(x1, y1, x2, y2, x3, y3); //Original area of triangle
    float abP = findArea(x1, y1, x2, y2, ammoX, ammoY);
    float Pbc = findArea(ammoX, ammoY, x2, y2, x3, y3);
    float aPc = findArea(x1, y1, ammoX, ammoY, x3, y3);

    if ((abP + Pbc + aPc) == og) {
      return true;
    }
    return false;
  }
}
