float shipY;

//GAME SYSTEM VARIABLES
float fps = 60;

int state = 0; //the current state of the game (default is 0)
final int mainMenu = 0;
final int runGame = 1;
final int win = 2;
final int lose = 3;


float intHeight;  //interface height
float score = 0;
float lives = 3;
float shootRate; //shooting rate for aliens
Spaceship player = new Spaceship(lives);
Ally hero;

//ALIEN MOVEMENT VARIABLES
float vel;
float downStep = 2;

ArrayList<Star> listStars = new ArrayList<Star>();  //Stars in the sky
ArrayList<Ammo> shotAmmo = new ArrayList<Ammo>();   //Ammo shot by player
ArrayList<Alien> aliens = new ArrayList<Alien>();    //Amount of aliens in the game
ArrayList<Ally> heroes = new ArrayList<Ally>();

//LISTS FOR EACH BARRICADE THAT EXISTS
ArrayList<Barricade> barricades1 = new ArrayList<Barricade>();  //barricade 1
ArrayList<Barricade> barricades2 = new ArrayList<Barricade>();  //barricade 2
ArrayList<Barricade> barricades3 = new ArrayList<Barricade>();  //barricade 3
float heightBarricade;

//Alien row and col
float row = 5;
float col = 6;
float dimensions = row*col;


boolean added = false;
boolean loaded = false;

//POWERUP BOOLEANS
boolean tripleShoot = false;

void setup() {
  size(600, 750);
  //fullScreen();
  frameRate(fps);
  for (int i = 0; i < 150; i++) {
    listStars.add(new Star (random(width), random(height), random(10)*.5));
  }
  shipY = height-70;
  intHeight = height/20; //interface height
  heightBarricade = height*8/10;
}

void draw() {
  switch(state) {
  case mainMenu:
    mainMenu();
    break;
  case runGame:
    runGame();
    break;
  case win:
    winScreen();
    break;
  case lose:
    loseScreen();
    break;
  }
}
public void resetGame() {
  tripleShoot = false;
  hero = new Ally(1);
  heroes.add(hero);
  score = 0;
  player.lives = 3;
  loaded = false; 
  added = false;
  aliens.clear();
  shotAmmo.clear();
  barricades1.clear();
  barricades2.clear();
  barricades3.clear();
}

public void runGame() {
  //The setup
  night();
  addStars();
  shoot();
  addAliens();
  drawAliens();
  drawInterface();
  lol();
  player.load();
  loadBarricade(width*2/20, heightBarricade, 5, 18, 5, barricades1);
  loadBarricade(width*8.5/20, heightBarricade, 5, 18, 5, barricades2);
  loadBarricade(width*15/20, heightBarricade, 5, 18, 5, barricades3);
  if (frameCount % (fps * 2) == 0) {
    if (score >= dimensions*10) {
      state = 2;
    }
  }
  if (player.lives <= 0) {
    state = 3;
  }
}

public void lol() {
  if (!heroes.isEmpty()) {
    hero.draw();
    for (int ammo = 0; ammo < shotAmmo.size(); ammo++) {
      if (hero.collidesWith(shotAmmo.get(ammo))) {
        println("I've been hit! :(");
        tripleShoot = true;
        heroes.clear();
      }
    }

    if (hero.x < -50) heroes.remove(0);
  } else if (heroes.isEmpty()) {
    int timer = millis();
    if (millis() - timer >= 2000) {
      println("stopped");
      tripleShoot = false;
    }
  }
}

public void keyPressed() {
  if (key == 'm' || key == 'M') {
    state = 0;
  }
}

public void night() {
  background(0);
}

public void addStars() {
  for (Star star : listStars) {
    star.drawStars();
    //Animating the stars
    star.y += 1.5;
    if (star.y > height) star.y = 0;
  }
}

//SHOOTING WITH MOUSE
public void mousePressed() {
  float r = 0;
  float g = 255;
  float b = 0;
  shotAmmo.add(new Ammo(player.x2, player.y2, r, g, b));  //Shoot ammo from midpoint of ship
  if (tripleShoot) {
    shotAmmo.add(new Ammo(player.x1, player.y1, r, g, b));
    shotAmmo.add(new Ammo(player.x3, player.y3, r, g, b));
  }
}
public void shoot() {
  for (int i = 0; i < shotAmmo.size(); i++) {
    shotAmmo.get(i).draw();
    if ((shotAmmo.get(i).y + shotAmmo.get(i).h) <= 0) shotAmmo.remove(i);  //Clears ammo list to avoid lag
  }
}

public void addAliens() {
  float gapX = width/8;
  float sizeAlien = 15;
  float gapY = sizeAlien*2;

  if (!added) {      //Only run if maximum number of bricks hasn't been reached
    for (int i = 0; i < col; i++) {
      for (int j = 0; j < row; j++) {
        float alienX = gapX+(gapX+sizeAlien)*i;
        float alienY = intHeight + gapY+(gapY+sizeAlien)*j;
        aliens.add(new Alien (alienX, alienY, sizeAlien, (int) random(0, 4)));
      }
    }
    if (aliens.size() == row*col) added = true;      //Completed once maximum number of bricks are added
  }
}


public void drawAliens() {
  for (Alien alien : aliens) {
    if (alien.x+alien.rad > width || alien.x-alien.rad < 0) {
      vel *= -1;
      for (int c = 0; c < aliens.size(); c++) {
        aliens.get(c).y += downStep;
        //  //If an alien reaches the barricade's height the player has lost the game
        if (aliens.get(c).y1 > heightBarricade) state = 3;
      }
    }
  }
  for (int i = 0; i < aliens.size(); i++) {
    Alien a = aliens.get(i);
    a.draw();

    //ALIENS SHOOTING
    //deciding which alien gets to shoot
    if (frameCount % (fps * shootRate) == 0) {
      //Decides which colour of alien shoots
      int alienType = (int) random(0, 4);
      if (alienType == a.status || aliens.size() <= 5) a.shouldShoot = true;
      else if (alienType != a.status) a.shouldShoot = false;
    }

    //Collision check for ammo and alien
    for (int k = 0; k < shotAmmo.size(); k++) {
      if (a.collidesWith(shotAmmo.get(k))) {
        aliens.remove(a);  //Remove alien if hit
        shotAmmo.remove(k);  //Also remove bullet after it has hit alien
        score += 10;
      }
    }

    //MOVEMENT CONTROLLING ALIENS
    a.x += vel;
  }
}

public void loadBarricade(float left, float top, int rows, int cols, int size, ArrayList<Barricade> barricades) {
  if (!loaded) {
    for (int row = 0; row < rows; row++) {
      float y = top+row*size;
      for (int col = 0; col < cols; col++) {
        float x = left+col*size;
        barricades.add(new Barricade(x, y, size));
      }
    }
    if (barricades1.size() > 0 && barricades2.size() > 0 && barricades3.size() > 0) loaded = true;
  }
  for (int bar = 0; bar < barricades.size(); bar++) {
    Barricade currentBar = barricades.get(bar);
    currentBar.build();

    //if player's bullets touches barricade delete player's bullets
    for (int ammo = 0; ammo < shotAmmo.size(); ammo++) {
      if (currentBar.collidesWith(shotAmmo.get(ammo))) {
        barricades.remove(currentBar);
        shotAmmo.remove(shotAmmo.get(ammo));
      }
    }
    //if alien's bullets touches barricade delete alien's bullets
    for (int a = 0; a < aliens.size(); a++) {
      Alien current = aliens.get(a);
      for (int bullet = 0; bullet < current.alienFire.size(); bullet++) {
        Ammo currentBullet = current.alienFire.get(bullet);
        if (currentBar.collidesWith(currentBullet)) {
          barricades.remove(currentBar);
          current.alienFire.remove(currentBullet);
        }
      }
    }
  }
}


public void drawInterface() {
  noStroke();
  rectMode(CORNERS);
  fill(255);
  rect(0, 0, width, intHeight);
  textSize(15);
  fill(0);
  float txtHeight = intHeight*2.5/4;
  text("Score: " + score, width/15, txtHeight);
  fill(255, 0, 0);
  text("Lives: " + player.lives, width*12.5/15, txtHeight);
  fill(0);
  textSize(14);
  text("Press 'm' to go back and quit to the main menu", width*3.65/15, txtHeight);
}

float imgY = height*2/5;
float original = imgY;
float tVel = 0.5;
boolean bounceDone = false;
/**
 * EASY: SLOWER ENEMIES, 3 LIVES
 * HARD: FASTER ENEMIES, 1 LIFE
 */
public void mainMenu() {
  resetGame();
  background(0);
  PImage titleImg = loadImage("titlescreen.png");

  image(titleImg, width*0.5/5.5, imgY);
  imgY += tVel;
  if (imgY > original+6) tVel *= -1;
  if (imgY < original-6) tVel *= -1;

  //Gamemodes
  PImage easy = loadImage("easy.png");
  PImage hard = loadImage("hard.png");
  float buttonW = 203;  //width
  float buttonH = 59;  //height
  float bX = width*3.2/10;  //x-value for both buttons
  float bY1 = height/2+10;  //easy button
  float bY2 = height/2+80;  //hard button

  image(easy, bX, bY1);
  image(hard, bX, bY2);
  //For EASY button
  if (mouseX > bX && mouseX < bX+buttonW &&
    mouseY > bY1 && mouseY < bY1+buttonH) {
    if (mousePressed) {
      state = 1;
      shootRate = 3;
      vel = 1;
    }
  }
  //For HARD button
  if (mouseX > bX && mouseX < bX+buttonW &&
    mouseY > bY2 && mouseY < bY2+buttonH) {
    if (mousePressed) {
      state = 1;
      shootRate = 3;
      player.lives = 1;
      vel = 3;
    }
  }
}

public void winScreen() {
  background(0);
  PImage titleImg = loadImage("won.png");
  image(titleImg, width*1/5.5, height/9);
  fill(255);
  textSize(13);
  text("Press any key to go back to the main menu.", width*2.7/10, height/2+10);
  if (keyPressed) state = 0;
}
public void loseScreen() {
  background(0);
  PImage titleImg = loadImage("lost.png");
  image(titleImg, width*1/5.5, height/9);
  fill(255);
  textSize(13);
  text("Press any key to go back to the main menu.", width*2.7/10, height/2+10);
  if (keyPressed) state = 0;
}
