class Star {
  float x;
  float y;
  float size;

  public Star(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }
  public void drawStars() {
    stroke(255);
    strokeWeight(1);
    stroke(198, 198, 198);
    line(x-size, y, x+size, y); //left to right line
    line(x, y-size, x, y+size); //top to bottom line
    line(x-size+3, y-size+3, x+size-3, y+size-3); //diagonal top left corner to bottom right corner
    line(x+size-3, y-size+3, x-size+3, y+size-3); //diagonal top right corner to bottom left corner
  }
}
