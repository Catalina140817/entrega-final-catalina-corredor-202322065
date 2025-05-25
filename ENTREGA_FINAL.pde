//Catalina Corredor 202322065 entrega final lab. algorítmico 
// solucione errores pequeños con chatgpt, y tambien revise con el q cumpliera con los criterios de evaluacion 
//Andres Pinilla profesor 
// las imágenes las realice con ia, y las mejore con photoshop.


import ddf.minim.*;

// Variables globales para sonido y manejo general
Minim minim;
AudioPlayer[] canciones = new AudioPlayer[7]; // Arreglo para 7 canciones (una por pecado)

PImage[] imagenes = new PImage[7];  // Imágenes de los pecados 
Pecado[] pecados = new Pecado[7];  // Objetos Pecado

int estado = 0;                    // Estado de la pantalla
String nombreUsuario = "";        // Guarda nombre ingresado en la primera pantalla
Boton siguienteBtn;               // Botón "Siguiente" reutilizable

// Nombres y textos de pecados
String[] nombres = {"soberbia", "envidia", "ira", "pereza", "avaricia", "gula", "lujuria"};
String[] descripciones = {
  "Soberbia: Exceso de autoestima y desprecio hacia los demás.",
  "Envidia: Deseo de poseer lo que otro tiene.",
  "Ira: Furia incontrolada ante una situación.",
  "Pereza: Falta de ganas de hacer lo necesario.",
  "Avaricia: Deseo insaciable de bienes materiales.",
  "Gula: Consumo excesivo de comida o bebida.",
  "Lujuria: Deseo sexual desmedido."
};
String[] frases = {
  "La soberbia nunca baja de donde sube.",
  "La envidia va tan flaca porque muerde y no come.",
  "La ira es un veneno que uno toma esperando que muera el otro.",
  "La pereza camina tan despacio que la pobreza no tarda en alcanzarla.",
  "La avaricia lo pierde todo por quererlo todo.",
  "El glotón cava su tumba con los dientes.",
  "La lujuria no es amor, es el disfraz del deseo."
};

// Matriz de objetos interactivos dibujados (5 por pecado)
ObjetoInteractivo[][] objetosPecados = new ObjetoInteractivo[7][5];

// Contador de objetos tocados en el pecado actual
int tocados = 0;

void setup() {
  size(800, 800);
  textFont(createFont("Georgia", 20));
  minim = new Minim(this);

  // Cargar imágenes y canciones
  for (int i = 0; i < 7; i++) {
    imagenes[i] = loadImage(nombres[i] + ".png");        
    canciones[i] = minim.loadFile(nombres[i] + ".mp3");   
    pecados[i] = new Pecado(nombres[i], descripciones[i], frases[i], imagenes[i], canciones[i]);
  }

  // Crear botón siguiente
  siguienteBtn = new Boton("Siguiente", width/2 - 75, height - 100, 150, 40);

  // Inicializar objetos interactivos para cada pecado
  // Posiciono 5 objetos horizontalmente para que el usuario toque
  for (int i = 0; i < 7; i++) {
    for (int j = 0; j < 5; j++) {
      float x = 150 + j*110;
      float y = height - 220;  // Bajé un poco para que no interfiera con texto
      objetosPecados[i][j] = new ObjetoInteractivo(x, y, 60, 60, i);
    }
  }
}

void draw() {
  background(0);

  switch (estado) {
  case 0:
    pantallaBienvenida(); // Pantalla para ingresar nombre
    break;
  case 1:
    pantallaIntroduccion(); // Pantalla de bienvenida con instrucciones
    break;
  case 2:
  case 3:
  case 4:
  case 5:
  case 6:
  case 7:
  case 8:
    mostrarPecado(estado - 2); // Mostrar pecado 
    break;
  case 9:
    pantallaFinal();  // Pantalla final "Ha terminado"
    break;
  }
}

// Pantalla inicial donde se pide el nombre
void pantallaBienvenida() {
  fill(255);
  textAlign(CENTER);
  textSize(24);
  text("Bienvenido. Ingresa tu nombre para comenzar:", width/2, height/2 - 20);

  // Caja de texto para nombre
  rectMode(CENTER);
  fill(255);
  rect(width/2, height/2 + 20, 300, 40); // Ahora está a la misma altura que el texto
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(20);
  text(nombreUsuario, width/2, height/2 + 20);

  // Mostrar botón Siguiente solo si ya hay texto ingresado
  if (nombreUsuario.length() > 0) {
    siguienteBtn.display();
  }
}

// Pantalla de introducción con texto y botón siguiente
void pantallaIntroduccion() {
  fill(255);
  textAlign(CENTER);
  textSize(24);
  text("Hola " + nombreUsuario + ".", width/2, height/2 - 60);
  text("Este será un recorrido por los 7 pecados capitales.", width/2, height/2 - 20);
  textSize(18);
  fill(200);
  text("Instrucción: Toca los dibujos para pasar al siguiente pecado.", width/2, height/2 + 20);
  siguienteBtn.display();
}

// Mostrar un pecado con imagen, texto y objetos interactivos
void mostrarPecado(int index) {
  Pecado p = pecados[index];
  p.display();

  // Mostrar los 5 objetos interactivos para que el usuario toque
  for (int i = 0; i < 5; i++) {
    objetosPecados[index][i].display();
  }

  fill(255);
  textAlign(CENTER);
  textSize(18);
  // Mostrar instrucción y progreso de toque
  text("Toca todos los dibujos para activar el botón Siguiente.", width/2, height - 170);
  text("Progreso: " + tocados + "/5", width/2, height - 140);

  // Mostrar botón Siguiente solo si tocó los 5 objetos
  if (tocados >= 5) {
    siguienteBtn.display();
  }
}

void pantallaFinal() {
  background(20, 30, 50);
  fill(180, 255, 180);
  textAlign(CENTER, CENTER);
  textSize(30);
  text("¡Has terminado el recorrido!", width/2, height/2 - 40);
  textSize(20);
  text("Gracias por participar y reflexionar sobre los 7 pecados capitales.", width/2, height/2 + 10);
  text("Puedes cerrar la aplicación o reiniciar presionando R.", width/2, height/2 + 50);
}

void mousePressed() {
  if (estado == 0) {
    // Si hay nombre y presionó siguiente, avanzar a intro
    if (nombreUsuario.length() > 0 && siguienteBtn.pressed(mouseX, mouseY)) {
      estado++;
    }
  } else if (estado == 1) {
    // En intro, avanzar al primer pecado
    if (siguienteBtn.pressed(mouseX, mouseY)) {
      estado++;
      pecados[0].play();
      tocados = 0;
    }
  } else if (estado >= 2 && estado <= 8) {
    int pecadoActual = estado - 2;

    // Revisar si clickeó un objeto no tocado
    for (int i = 0; i < 5; i++) {
      if (!objetosPecados[pecadoActual][i].tocado && objetosPecados[pecadoActual][i].contains(mouseX, mouseY)) {
        objetosPecados[pecadoActual][i].tocado = true;
        tocados++;
        break; // Solo contar uno por clic
      }
    }

    // Si tocó todos los objetos y clic en siguiente, avanzar pecado y manejar música
    if (tocados >= 5 && siguienteBtn.pressed(mouseX, mouseY)) {
      pecados[pecadoActual].stop();
      estado++;
      tocados = 0;
      if (estado <= 8) {
        pecados[estado - 2].play();
        // Resetear estado de objetos para el nuevo pecado
        for (int j = 0; j < 5; j++) {
          objetosPecados[estado - 2][j].tocado = false;
        }
      } else {
        // Último pecado terminado, pasar a pantalla final
        estado = 9;
      }
    }
  }
}

void keyPressed() {
  // En la pantalla inicial, capturar el nombre
  if (estado == 0) {
    if (key == BACKSPACE && nombreUsuario.length() > 0) {
      nombreUsuario = nombreUsuario.substring(0, nombreUsuario.length() - 1);
    } else if (key != CODED && key != ENTER && key != RETURN) {
      nombreUsuario += key;
    }
  }
  // Reiniciar si está en pantalla final
  if (estado == 9 && (key == 'r' || key == 'R')) {
    estado = 0;
    nombreUsuario = "";
    tocados = 0;
  }
}

// Clase para el botón "Siguiente"
class Boton {
  String label;
  float x, y, w, h;

  Boton(String l, float x, float y, float w, float h) {
    label = l;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void display() {
    fill(255);
    rectMode(CORNER);
    rect(x, y, w, h, 10);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(20);
    text(label, x + w/2, y + h/2);
  }

  boolean pressed(float mx, float my) {
    return mx > x && mx < x + w && my > y && my < y + h;
  }
}

// Clase para representar un pecado (imagen, texto, audio)
class Pecado {
  String nombre, descripcion, frase;
  PImage img;
  AudioPlayer cancion;

  Pecado(String n, String d, String f, PImage i, AudioPlayer c) {
    nombre = n;
    descripcion = d;
    frase = f;
    img = i;
    cancion = c;
  }

  void display() {
    // Fondo oscuro semitransparente para mejor lectura
    fill(0, 150);
    rect(0, 0, width, height);

    // Título
    fill(255, 100, 100);
    textAlign(CENTER);
    textSize(40);
    text(nombre.toUpperCase(), width/2, 80);

    // Imagen del pecado
    if (img != null) {
      imageMode(CENTER);
      image(img, width/2, height/2 - 60, 300, 300);
    }

    // Texto descripción
    fill(255);
    textSize(20);
    textAlign(CENTER);
    text(descripcion, width/2, height/2 - 200);

    // Frase relacionada
    fill(255, 200, 200);
    textSize(18);
    text(frase, width/2, height/2 - 250);
  }

  void play() {
    if (cancion != null) {
      cancion.rewind();
      cancion.play();
    }
  }

  void stop() {
    if (cancion != null && cancion.isPlaying()) {
      cancion.pause();
    }
  }
}

// Clase para objetos interactivos
class ObjetoInteractivo {
  float x, y, w, h;
  boolean tocado = false;
  int pecadoIndex;

  ObjetoInteractivo(float x, float y, float w, float h, int pIndex) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.pecadoIndex = pIndex;
  }

  void display() {
    stroke(255);
    strokeWeight(2);

    if (tocado) {
      fill(100, 255, 100, 180);
      ellipse(x, y, w + 10, h + 10);  
    }

    fill(200, 50, 50);
    ellipse(x, y, w, h);

    // Dibujos
    noStroke();
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(20);

    switch(pecadoIndex) {
    case 0: // Soberbia: Corona 
      drawCorona(x, y);
      break;
    case 1: // Envidia: Ojo verde 
      drawOjoVerde(x, y);
      break;
    case 2: // Ira: Llama 
      drawLlama(x, y);
      break;
    case 3: // Pereza: Almohada 
      drawAlmohada(x, y);
      break;
    case 4: // Avaricia: Moneda 
      drawMoneda(x, y);
      break;
    case 5: // Gula: Cubiertos 
      drawCubiertos(x, y);
      break;
    case 6: // Lujuria: Corazón 
      drawCorazon(x, y);
      break;
    }
  }

  boolean contains(float mx, float my) {
    return dist(mx, my, x, y) < w/2;
  }

  // Dibujos 

  void drawCorona(float cx, float cy) {
    fill(255, 215, 0);
    noStroke();
    // Base corona
    rectMode(CENTER);
    rect(cx, cy + 15, 60, 12, 5);
    // Picos
    triangle(cx - 30, cy + 15, cx - 20, cy - 15, cx - 10, cy + 15);
    triangle(cx - 10, cy + 15, cx, cy - 25, cx + 10, cy + 15);
    triangle(cx + 10, cy + 15, cx + 20, cy - 15, cx + 30, cy + 15);
  }

  void drawOjoVerde(float cx, float cy) {
    fill(0, 150, 0);
    ellipse(cx, cy, 50, 30);
    fill(255);
    ellipse(cx, cy, 40, 20);
    fill(0);
    ellipse(cx, cy, 20, 20);
    fill(0, 150, 0, 100);
    ellipse(cx, cy, 10, 10);
  }

  void drawLlama(float cx, float cy) {
    noStroke();
    // Base de llama naranja
    fill(255, 140, 0);
    beginShape();
    vertex(cx, cy + 20);
    bezierVertex(cx - 20, cy, cx - 10, cy - 50, cx, cy - 10);
    bezierVertex(cx + 15, cy - 45, cx + 20, cy - 15, cx, cy + 20);
    endShape(CLOSE);

    // Parte interior más clara
    fill(255, 215, 0);
    beginShape();
    vertex(cx, cy + 15);
    bezierVertex(cx - 10, cy - 5, cx - 5, cy - 35, cx, cy - 5);
    bezierVertex(cx + 10, cy - 30, cx + 10, cy - 10, cx, cy + 15);
    endShape(CLOSE);
  }

  void drawAlmohada(float cx, float cy) {
    fill(220);
    ellipse(cx, cy, 60, 40);
    fill(200);
    ellipse(cx, cy, 55, 35);
    fill(180);
    // Sombras suaves
    ellipse(cx + 15, cy + 5, 15, 10);
  }

  void drawMoneda(float cx, float cy) {
    fill(255, 223, 0);
    ellipse(cx, cy, 50, 50);
    fill(180, 140, 0);
    textSize(30);
    text("$", cx, cy + 5);
    fill(255, 255, 150, 150);
    ellipse(cx - 10, cy - 10, 15, 10); // brillo
  }

  void drawCubiertos(float cx, float cy) {
    fill(255);
    rectMode(CENTER);
    // Tenedor
    rect(cx - 10, cy, 10, 40, 3);
    for (int i = -1; i <= 1; i++) {
      rect(cx - 10 + i*4, cy - 15, 2, 15);
    }
    // Cuchillo 
    pushMatrix();
    translate(cx + 15, cy);
    rotate(radians(45));
    rect(0, 0, 10, 40, 3);
    popMatrix();
  }
    //corazon
  void drawCorazon(float cx, float cy) {
    fill(255, 0, 100);
    beginShape();
    vertex(cx, cy + 10);
    bezierVertex(cx - 25, cy - 10, cx - 10, cy - 40, cx, cy - 20);
    bezierVertex(cx + 10, cy - 40, cx + 25, cy - 10, cx, cy + 10);
    endShape(CLOSE);
  }
}
