class Barricade {
  private float x;
  private float y;
  private float size;

  public Barricade (float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }
  /**
   *  Builds one unit of barricade
   */
  public void build() {
    noStroke();
    rectMode(CENTER);
    fill(0, 255, 0); //green
    rect(x, y, size, size);
  }

  public boolean collidesWith(Ammo a) {
    float barricadeBot = y + size/2;
    float barricadeTop = y - size/2;
    float barricadeLeft = x - size/2;
    float barricadeRight = x + size/2;

    //ammo top hitting barricade bot
    if (a.top > barricadeTop && a.top < barricadeBot && 
      a.x > barricadeLeft && a.x < barricadeRight) {
      return true;
    }
    //ammo bot hitting barricade top
    if (a.bot > barricadeTop && a.bot < barricadeBot && 
      a.x > barricadeLeft && a.x < barricadeRight) {
      return true;
    }
    return false;
  }
}
