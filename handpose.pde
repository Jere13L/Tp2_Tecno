class Handpose {
  // Propiedades
  float amortiguacion = 0.9;
  float umbralDistancia = 90;
  PVector indice;
  PVector pulgar;
  PVector puntero;
  boolean seTocan = false;
  boolean antesSeTocaban = false;
  boolean down = false;
  boolean up = false;
PImage mano;
  // Constructor
  Handpose() {
    // Constructor
    osc = new OscP5(this, 8008);
 mano= loadImage("mano.png");
    indice = new PVector(0, 0);
    pulgar = new PVector(0, 0);
    puntero = new PVector(0, 0);
  }

  // Métodos

  void dibujar() {
    seTocan = dist(pulgar.x, pulgar.y, indice.x, indice.y) < umbralDistancia;

    if (seTocan) {
      push();
      fill(0, 0, 255, 50);
      ellipse(pulgar.x, pulgar.y, 100, 100);
      pop();

      dedosTocandose = true; // Establece la variable global en true
    } else {
      physics.addDynamicCircle(pulgar.x, pulgar.y);
      dedosTocandose = false; // Establece la variable global en false
    }

    down = !antesSeTocaban && seTocan;
    up = antesSeTocaban && !seTocan;

    if (down)
      println("DOWN");
    if (up)
      println("UP");

    puntero.x = lerp(pulgar.x, indice.x, 0.5);
    puntero.y = lerp(pulgar.y, indice.y, 0.5);

    noStroke();
    //if (seTocan) {
    //  fill(0, 0, 255);
    //  ellipse(puntero.x, puntero.y, 20, 20);
    //}

    noStroke();
   // fill(255, 0, 0);
   
      image(mano,pulgar.x, pulgar.y, 50, 50);
      image(mano,indice.x, indice.y, 50, 50);
   // text("pulgar", pulgar.x + 10, pulgar.y + 10);
 //   fill(0, 255, 0);
   
    //text("indice", indice.x + 10, indice.y + 10);

    antesSeTocaban = seTocan;
  }

  void oscEvent(OscMessage m) {
    if (m.addrPattern().equals("/annotations/thumb")) {
      pulgar.x = map(m.get(9).floatValue(), 0, 800, width, 0);
      pulgar.y = map(m.get(10).floatValue(), 0, 600, 0, height);
    }
    if (m.addrPattern().equals("/annotations/indexFinger")) {
      indice.x = map(m.get(9).floatValue(), 0, 800, width, 0);
      indice.y = map(m.get(10).floatValue(), 0, 600, 0, height);
    }
  }

  // Getter para obtener el PVector 'indice'
  public PVector getIndice() {
    return indice;
  }

  // Getter para obtener el PVector 'pulgar'
  public PVector getPulgar() {
    return pulgar;
  }
}
