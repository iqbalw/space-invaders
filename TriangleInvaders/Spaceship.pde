class Spaceship {
  private float x1;
  private float y1;
  private float x2;
  private float y2;
  private float x3;
  private float y3;
  float x;
  float shipY = 700;    //MAYBE CHANGE LATER?
  float shipSize = 20;
  float lives;

  public Spaceship(float lives) {
    this.lives = lives;
  }
  public void load() {
    x1 = mouseX-shipSize;
    y1 = shipY+shipSize;
    x2 = mouseX;
    y2 = shipY-shipSize;
    x3 = mouseX+shipSize;
    y3 = shipY+shipSize;
    if (tripleShoot) {
      strokeWeight(random(7)+4); //if powerup is active this animation plays
    }
    strokeWeight(2);
    float r = 255;
    float g = 204;
    float b = 0;

    //blue jet engines
    noStroke();
    //strokeWeight(1);
    rectMode(RADIUS);
    float rad = shipSize/5;
    fill(0, 61, 186);
    rect(x1+shipSize/1.9, y1+rad, rad, rad);
    rect(x3-shipSize/1.9, y1+rad, rad, rad);


    //if alien's bullets touches barricade delete alien's bullets
    for (int a = 0; a < aliens.size(); a++) {
      Alien current = aliens.get(a);
      for (int bullet = 0; bullet < current.alienFire.size(); bullet++) {
        Ammo currentBullet = current.alienFire.get(bullet);
        if (player.collidesWith(currentBullet)) {
          player.lives--;
          r = 255;
          g = 0;
          b = 0;
          current.alienFire.remove(currentBullet);
        }
      }
    }

    stroke(255, 175, 247);
    strokeWeight(shipSize/8);
    fill(r, g, b);  //yellow ship
    triangle(x1, y1, x2, y2, x3, y3);
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
