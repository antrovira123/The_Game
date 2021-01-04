class cGameElement{
  // Attributes
  PImage icon;
  float X,Y,
        dX,dY;
  boolean exists;
  //Methods
  cGameElement(){
    X = 0;
    Y = 0;
    dX = 0;
    dY = 0;
    exists = false;
  }
  cGameElement(PImage img, float nX, float nY, float nDX, float nDY, boolean visible){
    icon = img;
    X = nX;
    Y = nY;
    dX = nDX;
    dY = nDY;
    exists = visible;
  }
  boolean visible(){
    return exists;
  }
  void move(){
    X += dX;
    Y += dY;
  }
  void display(){
    exists = true;
    image(icon,X,Y);
  }
  void hide(){
    exists = false;
  }
  void unhide(){
    exists = true;
  }
  boolean outsideRight(){
    boolean result = (X >= width);
    return result;
  }
  void setPosition(float nX, float nY){
    X = nX;
    Y = nY;
  }
  float getHt(){
    return icon.height;
  }
  float getWd(){
    return icon.width;
  }
  float getX(){
    return X;
  }
  float getY(){
    return Y;
  }
  void setVel(float nDX, float nDY){
    dX = nDX;
    dY = nDY;
  }
  void setX(float nX){
    X = nX;
  }
  void setY(float nY){
    Y = nY;
  }
  void revDX(){
    dX = -dX;
  }
  void revDY(){
    dY = -dY;
  }
}
