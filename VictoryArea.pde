class VictoryArea {
  float x, y, width, height;
  boolean triggered;

  VictoryArea(float x, float y, float width, float height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.triggered = false;
  }

  void display() {
    noStroke();
    fill(triggered ? color(0, 255, 0) : color(0, 100, 0));
    rect(x, y, width, height);
  
  }

  void checkForVictory(ArrayList<FCircle> circles) {
    if (!triggered) {
      for (FCircle circle : circles) {
        if (circle.getX() > x && circle.getX() < x + width && circle.getY() < y) {
          triggered = true;
            ganar = minim.loadFile("ganar.mp3", 2048);
    ganar.play();
    Fondo.mute();
          break;
        }
      }
    }
  }
}

class DefeatArea {
  float x, y, width, height;
  boolean defeated;

  DefeatArea(float x, float y, float width, float height) {
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.defeated = false;
  }

  void display() {
    noStroke();
    fill(defeated ? color(255, 0, 0) : color(100, 0, 0)); // Cambiar el color a rojo
    rect(x, y, width, height);
  }

  void checkForDefeat(ArrayList<FCircle> circles) {
    if (!defeated) {
      for (FCircle circle : circles) {
        if (circle.getY() >= x && circle.getY() <= y + height && circle.getY() > width/2) {
                     perder = minim.loadFile("perder.mp3", 2048);
    perder.play();
    Fondo.mute();
    
          defeated = true;
          break;
        }
      }
    }
  }
}
