import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;



import fisica.*;
import java.util.ArrayList;
import oscP5.*;
OscP5 osc;

Minim minim;
AudioPlayer pinguino;
AudioPlayer Fondo;
AudioPlayer ganar;
AudioPlayer perder;

PImage Pinguino,Plataforma,victoria,fondo;
PImage estado0,boton,mano,fondoJ;
boolean dedosTocandose = false; //Declaracion de la variable global

PImage[] victoryImages;
PImage[] defeatImages;
PImage[] animacionFondo;


int totalFrames = 3; // Cambia el número de cuadros según la velocidad deseada de la animación
int frame = 0;
int currentFrame = 0;
int frameRate = 3;  // Velocidad de la animación (cambia según lo desees)

PhysicsSimulation physics;
Handpose handpose;
VictoryArea victoryArea;
DefeatArea defeatArea;

int estadoJuego = 0; // 0 para la pantalla de inicio, 1 para el juego en curso

void setup() {
  fullScreen();
  estado0= loadImage("estado0.png");
   victoria= loadImage("estado0.png");
 boton= loadImage("boton.png");
 mano= loadImage("mano.png");
  fondoJ= loadImage("fondoJ.png");
  Plataforma = loadImage("plataforma.png");
  Pinguino = loadImage("pinguino1.png");
  
  animacionFondo = new PImage[totalFrames];
  
  minim = new Minim (this);
  Fondo = minim.loadFile("Fondo.mp3", 2048);
  Fisica.init(this);
  physics = new PhysicsSimulation();
   handpose = new Handpose(); // Crear una instancia de la clase Handpose
 //handpose.Handpose(); // Llamar al constructor de Handpose si es necesario
 
  float platform1X = displayWidth - 120;
  float platform1Y = 350;

  victoryArea = new VictoryArea(platform1X - 100, platform1Y - 40, 200, 20);
  defeatArea = new DefeatArea(0, height - 20, width, 20);
  
  // Cargar imágenes de victoria en la matriz
  victoryImages = new PImage[3];
  for (int i = 0; i < 3; i++) {
    String filename = "Ganaste_" + i + ".png";
    victoryImages[i] = loadImage(filename);
  }

  // Cargar imágenes de derrota en la matriz
  defeatImages = new PImage[3];
  for (int i = 0; i < 3; i++) {
    String filename = "Perdiste_" + i + ".png";
    defeatImages[i] = loadImage(filename);
  }
  
  // Cargar imágenes de derrota en la matriz
  animacionFondo = new PImage[12];
  for (int i = 0; i < 12; i++) {
    String filename = "Fondo_" + i + ".png";
    animacionFondo[i] = loadImage(filename);
  }
  
  

}

void draw() {
  background(255);
   if (estadoJuego == 0) {
         if (Fondo.isPlaying())
    {
     
    } else {
       Fondo.loop();
    }
    //   imageMode(CENTER);
      image(estado0,0,0,1400,800);
    // Dibujar el rectángulo en el centro de la pantalla
        noStroke();
   fill(0, 0, 0, 0);
    rect(200, 200, 200, 200);

 image(boton,90,140,400,400);
  PVector pulgar = handpose.getPulgar();
      PVector indice = handpose.getIndice();
      image(mano,pulgar.x, pulgar.y, 50, 50);
      image(mano,indice.x, indice.y, 50, 50);
    // Acceder a las variables pulgar e indice de la instancia de Handpose

    // Verificar si el círculo (pulgar o índice) está dentro del rectángulo
    boolean colisionPulgar = (pulgar.x >= 200 && pulgar.x <= 400 && pulgar.y >= 200 && pulgar.y <= 400);
    boolean colisionIndice = (indice.x >= 200 && indice.x <= 400 && indice.y >= 200 && indice.y <= 400);

    // Si hay una colisión, cambia el estado a 1
    if (colisionPulgar || colisionIndice) {
      estadoJuego = 1;
    }
  } else if (estadoJuego == 1) {
    // Lógica y dibujo del juego en curso
// Muestra la imagen actual de la animación
  image(animacionFondo[frame], 0, 0, width, height);

  // Actualiza el índice de cuadro
  frame = (frame + 1) % totalFrames;
   
     victoryArea.checkForVictory(circles);
  defeatArea.checkForDefeat(circles);
      victoryArea.display();
  defeatArea.display();
   physics.update();
    handpose.dibujar();
    // Verificar si se ha alcanzado la victoria
    if (victoryArea.triggered) {
    // Mostrar la imagen de victoria en el centro de la pantalla
    image(victoryImages[currentFrame], 0, 0, width, height);
    currentFrame = (currentFrame + 1) % victoryImages.length;
  }

  if (defeatArea.defeated) {
    // Mostrar la imagen de derrota en el centro de la pantalla
    image(defeatImages[currentFrame], 0, 0, width, height);
    currentFrame = (currentFrame + 1) % defeatImages.length;
  }
}
}
 // Mostrar el área de derrota// Mostrar el área de victoria

  



void mousePressed() {
  physics.addDynamicCircle(mouseX, mouseY);
}

void keyPressed() {
  if (key == 'r' || key == 'R') {
    // Reinicia el programa
    setup();
  }
}
