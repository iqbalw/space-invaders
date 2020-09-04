class Alien {
  private float x;
  private float y;
  private float size;
  private float rad;
  float x1;
  float y1;
  float x2;
  float y2;
  float x3;
  float y3;
  float r;
  float g; 
  float b;
  int status;  //determines colour of alien
  boolean shouldShoot = false;
  boolean wallCollision = false;


  ArrayList<Ammo> alienFire = new ArrayList<Ammo>();

  public Alien(float x, float y, float size, int status) { 
    this.x = x;
    this.y = y;
    this.size = size;
    this.status = status;
  }

  public void draw() {
    rad = this.size+5;
    x1 = x-rad;
    y1 = y+size;
    x2 = x;
    y2 = y-size;
    x3 = x+rad;
    y3 = y+size;
    noStroke();
    if (shouldShoot) {
      loadShoot();
    }
    if (status == 0) {
      fill(255, 247, 27);
    } else if (status == 1) {
      fill(255, 62, 157);
    } else if (status == 2) {
      fill(166, 62, 255);
    } else if (status == 3) {
      fill(0, 132, 255);
    }
    triangle(x1, y1, x2, y2, x3, y3);
  }

  public void despawn() {
    this.x2 = x1;
    this.y2 = y1;
    this.x3 = x1;
    this.y3 = y1;
  }


  public void loadShoot() {
    float r = 255;
    float g = 0;
    float b = 0;
    if (frameCount % (fps * 1.5) == 0) {
      alienFire.add(new Ammo(x, y, r, g, b));  //Shoot ammo from midpoint of alien
    }
    alienShoot();
  }


  public void alienShoot() {
    for (Ammo allBullets : alienFire) {
      allBullets.vel = -5;
      allBullets.draw();
    }
    for (int i = 0; i < alienFire.size(); i++) { 
      if ((alienFire.get(i).y + alienFire.get(i).h) >= height) alienFire.remove(i);  //Clears ammo list to avoid lag
    }
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

  public float getHeight() { 
    return abs(x2-x1);
  }
  public void changeDir() {
    //vel *= -1;
  }
}
