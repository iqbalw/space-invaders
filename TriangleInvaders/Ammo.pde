class Ammo {
  float x;
  float y;
  float w = 1;  //width of ammo
  float h = 8;  //height of ammo
  float vel = 5;
  float r;
  float g;
  float b;
  float bot;
  float top;

  public Ammo(float x, float y, float r, float g, float b) {
    this.x = x;
    this.y = y;
    this.r = r;
    this.g = g;
    this.b = b;
  }
  public void draw(){
    rectMode(RADIUS);
    noStroke();
    fill(r, g , b);
    rect(x, y, w, h);
    y -= vel;
    top = y-h;
    bot = y+h;
  }
  
  public float topY(){
    return y-h;
  }
    public float botY(){
    return y+h;
  }

}
