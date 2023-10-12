  ArrayList<FCircle> circles;

class PhysicsSimulation {
  FWorld world;
  ArrayList <Integer> jointsCircle; //Lista de cant de joints por circulo para hacer cosas (Iba a usarlos para hacer calculos de tirones con el joint del circulo estatico o con el forceThreshold para romper los circulos que tuvieran menos conexiones, pero no lo termine usando)
  ArrayList<FDistanceJoint> joints; // Lista de joints para llevar un seguimiento
  FBox platform;
  FBox platform1;
  float forceThreshold = 2000.0; // Umbral de fuerza para romper el joint (Lo aumente par que no se rompan todos los joints de nada, pero que tampoco sea taaaaan permisivo. Ajustenlo a gusto porque ni idea lo que pretenden)
  float fuerzaTiron = 1000; //Fuerza con la que va a tirar el joint
  float frecuencia = 5; //Frecuencia de los tirones

  PhysicsSimulation() {
    world = new FWorld();
    world.setEdges();
    world.setGravity(0, 500);

    circles = new ArrayList<FCircle>();
    jointsCircle = new ArrayList<Integer>();
    joints = new ArrayList<FDistanceJoint>();

    // Plataforma 1
    platform = createPlatform(160, 350);
    // Plataforma 2
    platform1 = createPlatform(displayWidth-130, 350);
    // Círculo estático 1
    FCircle circulostatico = createStaticCircle(200, 300);
    // Círculo estático 2
    FCircle circulostatico1 = createStaticCircle(100, 300);
  }

  FBox createPlatform(float x, float y) {
    FBox box = new FBox(200, 20);
    box.setPosition(x, y);
    box.setStatic(true);
    world.add(box);
    box.attachImage(Plataforma);
    

    return box;
  }

  FCircle createStaticCircle(float x, float y) {
    FCircle circle = new FCircle(50);
   
    circle.setPosition(x, y);
    circle.setDensity(1.0);
    circle.setStatic(true);
    world.add(circle);
    circle.attachImage(Pinguino);
    circles.add(circle);
   
   
    return circle;
  }

  void update() {
    
    world.step();
    world.draw();
    checkAndBreakJoints(); // Llama a la función para verificar y romper los joints
  }

  void addDynamicCircle(float x, float y) {
    if (dedosTocandose){
      
    //Sonido
    pinguino = minim.loadFile("pinguino.mp3", 2048);
    pinguino.play();
    
    //Circulo movible
    FCircle newCircle = new FCircle(50);
    newCircle.setDensity(1.0);
    world.add(newCircle);
    newCircle.attachImage(Pinguino);
    newCircle.setPosition(x, y);
    circles.add(newCircle);
    
    //Circulo estatico para mantener un toquel la estructura
    FCircle newStaticCircle = new FCircle(50);
    newStaticCircle.setDensity(1);
    newStaticCircle.setStatic(true);
    newStaticCircle.setDrawable(false);
    newStaticCircle.setSensor(true);
    world.add(newStaticCircle);
    newStaticCircle.setPosition(x,y);
    
    int jos= 0;

    for (FCircle circle : circles) {
      if (circle != newCircle) {
        float distance = dist(newCircle.getX(), newCircle.getY(), circle.getX(), circle.getY());

        // Define una distancia mínima antes de agregar una unión
        float minDistance = 200; // Puedes ajustar esta distancia según tus necesidades

        if (distance < minDistance) {
          FDistanceJoint joint = new FDistanceJoint(newCircle, circle);
          joint.setDamping(fuerzaTiron);
          joint.setFrequency(frecuencia);
          world.add(joint);
          joints.add(joint); // Agrega el joint a la lista
          jos ++;
        }
      }
    }
    
    //Si el circulo que armaron se conecta con mas de dos circilos, se va a crear el joint entre el circulo movible y el estatico
    //Esto hace que se mantenga la estructura un toque mas si se basa en armarlas con muchas conexiones
    //pero que si lo haces asi nomas no va a tener nada que lo soporte y se va a caer mas facil
    if (jos>2){
      FDistanceJoint j = new FDistanceJoint(newStaticCircle,  newCircle);
      j.setDamping(0.1); //Tira muy poco, para que no sea muy obvio ni rompa el balance del juego
      j.setFrequency(0.05); //Los tirones estan muy separados en el tiempo, si quieren ajustar el tiron que pegan los joints estos les conviene manipular esta variable antes que la otra
      j.setDrawable(false);
      world.add(j);
      //joints.add(joint); // Agrega el joint a la lista
      //jos ++;
    }
    } 
  }

  // Nueva función para verificar y romper los joints
  void checkAndBreakJoints() {
    for (int i = joints.size() - 1; i >= 0; i--) {
      FDistanceJoint joint = joints.get(i);

      // Calcula la fuerza y el torque en el joint
      float force = joint.getReactionForceX();
      float torque = joint.getReactionTorque();

      // Compara con el umbral de fuerza para romper el joint
      if (force > forceThreshold || torque > forceThreshold) {
        world.remove(joint); // Rompe el joint
        joints.remove(i); // Elimina el joint de la lista
      }
    }
  }
}
