// ----------------------------------------------------------------------
// The Game V1.8
// ----------------------------------------------------------------------
// Date     Comment
// -------- -------------------------------------------------------------
// 09/24/20 Initial coding
// 10/08/20 Added collision detection and response when astronaut moves
//          Added movement of asteroid(rock)
// 10/15/20 Added multiple asteroids
//          Added alien and spaceship
// 10/26/20 Added game over and win scenarios
//          Added oxygen meter
// 10/29/30 Added lose scenario when astronaut runs out of oxygen
//          Added penalty for rock/astronaut collisions
//          Added rock/astronaut collision response
// 11/02/20 Added alien laser burst
// 11/05/20 laserExists reset to false when laser burst leaves window
// 11/09/20 Broke up draw() function in to several, smaller functions
//          Added firing calculations for alien's laser fire
// 11/19/20 Added laser sound effect
//          Added laser strike penalty
// 11/23/20 Added cGameelement class
//          Re-implemented airtank as cGameElement object
// 11/30/20 Re-implemented all remaining elements as cGameElement objects
// ----------------------------------------------------------------------

import processing.sound.*;

// -------------------------------------------------- Global declarations
int numRocks;
float 
    //astroX, astroY,
    astroCX, astroCY,
    oldX,oldY,
    //tankX,tankY,
    //tankDX,tankDY,
    //alienX,alienY,
    //shipX,shipY,
    //rockX[], 
    //rockY[],
    //rockDX[],
    //rockDY[],
    //numRocks,
    radius,
    step,
    ht, wd,
    hatchX,hatchY,
    hatchCX,hatchCY,
    hatchR;
float oxygen,
      oxyRate,
      oxyRockPenalty,
      oxyLaserPenalty,
      //laserX,laserY,
      //laserDX,laserDY,
      laserS,
      laserFreq;
//PImage 
       //astro,
       //rock[],
       //tank,
       //alien,
       //ship;
       //laser;
boolean win,
        gameOver;
        //tankExists,
        //laserExists;
SoundFile laserSound,
          bgMusic;
cGameElement tank,
             astro,
             alien,
             rocks[],
             laser,
             ship;

// -------------------------------------------------------------- setup()
void setup(){
  size(750,750);
  // Initial values
  astro = new cGameElement(loadImage("astronaut.png"),0,0,1,0,true);
  alien = new cGameElement(loadImage("Alien.png"),0,0,0,0,true);
  tank  = new cGameElement(loadImage("Airtank.png"),wd/2,ht-astro.getHt(),0,0,false);
  laser = new cGameElement(loadImage("laser.png"),0,0,0,0,false);
  PImage tmp = loadImage("ship.png");
  ship  = new cGameElement(tmp,wd - tmp.width,0,0,0,true);
  ht             = 750;
  wd             = 750;
  //astro          = loadImage("astronaut.png");
  //astroX         = wd / 2;
  //astroY         = ht-astro.height;
  //oldX           = astroX;
  //oldY           = astroY;
  oldX           = astro.getX();
  oldY           = astro.getY();
  numRocks       = 5;
  //rockX          = new float[numRocks];
  //rockY          = new float[numRocks];
  //rockDX         = new float[numRocks];
  //rockDY         = new float[numRocks];
  //rock           = new PImage[numRocks];
  rocks          = new cGameElement[numRocks];
  hatchX         = 70;
  hatchY         = 129;
  hatchR         = 25;
  win            = false;
  gameOver       = false;
  oxygen         = 1.0;
  oxyRate        = 0.0001;
  oxyRockPenalty = 0.01;
  //tankExists     = false;
  //tankDX         = 1;
  //tankDY         = 0;
  //laserExists    = false;
  laserS         = 5;
  laserFreq      = 1.0;
  laserSound     = new SoundFile(this,"laser.mp3");
  bgMusic        = new SoundFile(this,"bgMusic.mp3");
  //bgMusic.loop();
  oxyLaserPenalty= 0.20;
  
  // Initialize rocks
  float nDX, nDY;
  for(int i = 0; i < numRocks; i++){
    nDX = 0;
    nDY = 0;
    //rock[i]   = loadImage("spacerock.png");
    //rockX[i] = int(random(0,wd));
    //rockY[i]  = int(random(0,ht/2));
    while(nDX == 0)
      nDX = int(random(-3,3));
    while(nDY == 0)
      nDY = int(random(-3,3));
    rocks[i] = new cGameElement(loadImage("spacerock.png"),random(0,wd),random(0,ht/2),nDX,nDY,false);
  }
  
  // Init everybody else
  //tank   = loadImage("Airtank.png");
  //alien  = loadImage("Alien.png");
  //alienX = 0;
  //alienY = 0;
  //ship   = loadImage("ship.png");
  //shipX  = wd - ship.width;
  //shipY  = 0;
  
  radius = 25;
  step   = 5;
  //laser  = loadImage("laser.png");
}

// --------------------------------------------------------------- draw()

void draw(){
  // Clear window
  background(48);
  drawRocks();
  drawShip();
  if(gameOver)
    drawBanner();
  else{
    drawTank();
    drawLaserFire();
    drawMeter();
  }
}
  
// ---------------------------------------------------------- drawRocks()
void drawRocks(){
  for(int i = 0; i < numRocks; i++){
    // Move asteroid(rock)
    //rockX[i] += rockDX[i];
    //rockY[i] += rockDY[i];
    rocks[i].move();
    
    // Check for collision with window boundaries
    // Check right edge
    if(rocks[i].getX() >= width)
      rocks[i].setX(-rocks[i].getWd()+1);
    // Check left edge
    if(rocks[i].getX() <= -rocks[i].getWd())
      rocks[i].setX(width);
    // Check bottom edge
    if(rocks[i].getY() >= height)
      rocks[i].setY(-rocks[i].getHt()+1);
    // Check top edge
    if(rocks[i].getY() <= -rocks[i].getHt())
      rocks[i].setY(height);
    //image(rock[i],rockX[i],rockY[i]);
    rocks[i].display();
  }
  
  rockAstroCollisionResponse();
}
  
// --------------------------------------------------------------- drawShip()
void drawShip(){
  //image(ship,shipX,shipY);
  ship.display();
  
  if(!gameOver || !win){
    // Draw astronaut
    //image(astro,astroX,astroY);
    astro.display();
    // Draw alien
    //image(alien,alienX,alienY);
    alien.display();
  }
}
  
// --------------------------------------------------------------- drawMeter()
void drawMeter(){
  oxygen -= oxyRate;
  stroke(255);
  noFill();
  strokeWeight(4);
  rect(10,height-40,width/3,30);
  noStroke();
  fill(#00ff00);
  rect(10,height-40,oxygen*width/3,30);
  if (oxygen <= 0.0)
    gameOver = true;
}
    
// ---------------------------------------------------------------- drawTank()
void drawTank(){
  //if(tankExists){
    if(tank.visible()){
    //tankX += tankDX;
    //tankY += tankDY;
    tank.move();
    //image(tank,tankX,tankY);
    tank.display();
    //if(tankX >= width)
    if(tank.outsideRight())
      //tankExists = false;
      tank.hide();
  }
  else{
    if(random(100) < 1){
      //tankExists = true;
      tank.unhide();
      //tankX = -tank.width;
      //tankY = int(random(height-tank.height));
      tank.setPosition(-tank.icon.width,random(height-tank.icon.height));
    }
  }
}
  
// ------------------------------------------------------------ drawLaseFire()\
void drawLaserFire(){
  float dX,dY,L;
  if(laser.visible()){
    //fill(255);
    //circle(laserX,laserY,10);
    //image(laser,laserX,laserY);
    laser.display();
    //laserX += laserDX;
    //laserY += laserDY;
    laser.move();
    // Check for collision with astronaut
    //if(collision(laser,int(laserX),int(laserY),astro,astroX,astroY)){
    if(collision(laser,astro)){
      oxygen -= oxyLaserPenalty;
      //laserExists = false;
      laser.hide();
    }
    if((laser.getX() > width) || (laser.getY() > height) || (laser.getX() < 0) || (laser.getY() < 0)){
      //laserExists = false;
      laser.hide();
    }
  }
  else{
    if(random(100) < laserFreq){
      laserSound.play();
      //laserExists = true;
      laser.display();
      laser.setX(alien.getX() + alien.getWd());
      laser.setY(alien.getY());
      dX = astro.getX() - alien.getX();
      dY = astro.getY() - alien.getY();
      L = sqrt(sq(dX) + sq(dY));
      //laserDX = 1;
      //laserDY = 1;
      //laserDX = laserS * dX / L;
      //laserDY = laserS * dY / L;
      laser.setVel(laserS * dX / L,laserS * dY / L);
      //println(laserS,dX,dY,L);
    }
  }
}
  
// -------------------------------------------------------------- drawBanner()
void drawBanner(){
  if(win){ // Win scenario
    // Draw win banner
    textAlign(CENTER);
    textSize(60);
    fill(#43fa2a);
    text("You've Escaped!",width/2,height/2);
    // Move ship
    //shipX -= 2;
    //shipY += 1;
    ship.setVel(-2,1);
    ship.move();
  }
  else{ // Lose scenario
    // Draw lose banner
    textAlign(CENTER);
    textSize(60);
    fill(#ff0000);
    text("Failed to Escape!",width/2,height/2);
  }
}

// --------------------------------------------------------- keyPressed()

void keyPressed(){
  float X,Y,
        dX, dY;
  // Store old astronaut position
  oldX = astro.getX();
  oldY = astro.getY(); 
  
  dX = 0;
  dY = 0;
  // Check for astronaut moves
  if(keyCode == 38) // Up
    //astroY -= step;
    dY = -step;
  if(keyCode == 40) // Down
    //astroY += step;
    dY = step;
  if(keyCode == 37) // Left
    //astroX -= step;
    dX = -step;
  if(keyCode == 39) // Right
    //astroX += step;
    dX = step;
  astro.setVel(dX,dY);
    
  // Check for collision with window boundaries  
  if(astro.getX() <= 0)
    astro.setX(oldX);
  if(astro.getX() >= wd-astro.getWd())
    astro.setX(oldX);
  if(astro.getY() <= 0)
    astro.setY(oldY);
  if(astro.getY() >= ht-astro.getHt())
    astro.setY(oldY);
    
  // Has astronaut reached hatch?
  float dist;
  astroCX = astro.getX() + astro.getWd()/2;
  astroCY = astro.getY() + astro.getHt()/2;
  hatchCX = ship.getX() + hatchX;
  hatchCY = ship.getY() + hatchY;
  dist = sqrt(sq(astroCX-hatchCX)+sq(astroCY-hatchCY));
  if(dist <= hatchR){
    gameOver = true;
    win      = true;
  }
  
  // Has astronaut reached airtank?
  if(tank.visible()){
    //if(collision(astro,astroX,astroY,tank.icon,tank.X,tank.Y)){
    if(collision(astro,tank)){
      //tankExists = false;
      tank.hide();
      oxygen = 1.0;
    }
  }
    
  // Check for collison with asteroid (rock)
  rockAstroCollisionResponse();
}

// ----------------------------------------- rockAstroCollisionResponse()
void rockAstroCollisionResponse(){
  for(int i = 0; i < numRocks; i++){
    //if(collision(astro,astroX,astroY,rock[i],rockX[i],rockY[i])){
    if(collision(astro,rocks[i])){
      // Reset astronaut's position
      astro.setX(oldX);
      astro.setY(oldY);
      oxygen -= oxyRockPenalty;
      //rockDX[i] *= -1;
      //rockDY[i] *= -1;
      //rockX[i] += rockDX[i];
      //rockY[i] += rockDY[i];
      rocks[i].revDX();
      rocks[i].revDY();
      rocks[i].move();
    }
  }
}

// ---------------------------------------------------------- collision()

/*
boolean collision(PImage icon1,float x1,float y1,PImage icon2,float x2,float y2){
  boolean result = false;
  if((abs(x1-x2)<=((icon1.width+icon2.width)/2))&&
     (abs(y1-y2)<=((icon1.height+icon2.height)/2)))
    result = true;
  return result;
  */
  
boolean collision(cGameElement E1, cGameElement E2){
  boolean result = false;
  if((abs(E1.getX()-E2.getX())<=((E1.getWd()+E2.getWd())/2))&&
     (abs(E1.getY()-E2.getY())<=((E1.getHt()+E2.getHt())/2)))
    result = true;
  return result;
}
