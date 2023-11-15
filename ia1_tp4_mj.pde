///////////////////////////////////////////////////////////
//
// BLiPiP
//
// martin julio
// ia1-tp4
// 2023
//
///////////////////////////////////////////////////////////

// ________________________________________________________

// AJUSTES

/* __Colores:__ */
final color am = color(254, 216, 122); // amarillo
final color az = color(7, 165, 219); // azul
final color ro = color(239, 131, 142); // rojo
final color ve = color(149, 201, 150); // verde
final color ne = color(10, 5, 3); // negro
final color bl = color(255, 255, 250); // blanco

/* __Resolucion:__ */
final int res = 400; // ojo: actualizar manualmente en setup -> "size()"
//final int res = 720;

/* __Velocidad movimiento:__ */
final int velMov = 60; // frames total movimiento

/* __Sin animaciones__ */
final boolean sinAni = true; // las animaciones consumen muchos recursos
// quiero hacerlas en p5 usando graficos svg que se optimizaria bastante (creo)

// ________________________________________________________

// VARIABLES DE ESTADO

byte pantalla = 1; // [1=inicio] [2=movimiento] [3=capitulo] [4=fin]
String posicion = "i"; // contiene concatenadas todas las posiciones recorridas
int recorrido; // camino seleccionado en inicio [0=ama] [1=roj] [2=azu]
byte sigPos = 0; // siguiente posicion [0=centro] [1=izq] [2=der]
byte antPos = 0; // posicion anterior [0=centro] [1=izq] [2=der]
byte colPrin = 0; // color pricipal [0=amarillo] [1=rojo] [2=azul]
byte colAnte = 0; // color anterior [0=amarillo] [1=rojo] [2=azul]
int movimiento = 0; // contador, activa pantalla 2 cuando es distinto de 0
float movSua; // calculo suavizado de moviento. pasa como argumento a animaciones
boolean cursorHand = false; // controla si hay que cambiar cursor
boolean salidaMenu = true; // controla si es primer movimiento
boolean entradaMenu = false; // controla si es reiniciar

// ________________________________________________________

// CARGAS

// ruta indice
String INDEX = "data/index.txt";

// datos generales
String user;

// datos recorrido
ArrayList<String> info_recorridos = new ArrayList<String>();

// lista de recorridos disponibles
// contiene arreglos de puntos, que son los recorridos
ArrayList<Punto[]> lista = new ArrayList<Punto[]>();

// vista punto actual
Punto vista = null;

PFont f_portada; // letras portada
PFont f_texto; // texto general
PFont f_texto_bo; // texto bold

PGraphics portadaInicio; // portada
PGraphics portadaInicioRei; // portada fija
PGraphics menuInicio; // menu -> dinamico

PGraphics vAmRoAz; // amarillo
PGraphics vRoAzAm; // rojo
PGraphics vAzAmRo; // azul
PGraphics sombra, marco; // bordes negros

PGraphics imgTexto; // variable vista texto
PGraphics imgSal; // variable imagen que sale
PGraphics imgEnt; // variable imagen que entra

// ________________________________________________________

void setup() {

  // width = res
  // height = res * 1.25
  // ojo: actualizar manualmente en ajustes -> "final int res"
  size(400, 500);
  //size(720, 900);
  
  // tipografias
  f_portada = createFont("fonts/FranklinGothicHeavy.ttf", 12);
  f_texto = createFont("fonts/pt-mono-regular.ttf", 12);
  f_texto_bo = createFont("fonts/pt-mono-bold.ttf", 12);

  // generacion de imagenes
  portadaInicio = displayInicio(res * 2, ve, am, ro, az, ne, f_portada);
  vAmRoAz = displayFractal(res, ve, am, ro, az, ne, true);
  vRoAzAm = displayFractal(res, ve, ro, az, am, ne, true);
  vAzAmRo = displayFractal(res, ve, az, am, ro, ne, true);
  if (!sinAni) sombra = displaySombra(res, ne);
  marco = displayMarco(res, ne);
  portadaInicioRei = createGraphics(res, int(res * 1.25));
  portadaInicioRei.beginDraw();
  portadaInicioRei.background(ve);
  portadaInicioRei.image(portadaInicio, 0, 0, res, res);
  portadaInicioRei.endDraw();
  
  cargaRecorridos(); // carga lista con recorridos de puntos
}

// ________________________________________________________

void draw() {

  // FLUJO(*_3) revisa movimiento
  if (movimiento < 0) movimiento = 0;
  if (movimiento > 0) {
    
    //if (!sinAni) { /* para quitar calculo de suavizacion del movimiento */
      // movimiento suave
      float salTemp;
      float entTemp = map(movimiento, 0, velMov, 0, 1);
      if (entTemp < 0.5) salTemp = 4.0 * pow(entTemp, 3);
      else {
        float f = ((2.0 * entTemp) - 2.0);
        salTemp = 0.5 * pow(f, 3) + 1.0;
      }
      if (salTemp < 0.008) salTemp = 0;
      movSua = map(salTemp, 0, 1.0, 0, velMov);
    //} else movSua = movimiento; /* para quitar calculo  de suavizacion */
    
    // actualizar
    movimiento--;
    if (pantalla != 4) pantalla = 2;
  }

  // FLUJO(*_1) ver abajo
  update(); 

}

// ________________________________________________________

// FLUJO(*_2) ejecuta click
void mouseReleased() { click(); }

// ________________________________________________________

// FLUJO(*_1) control principal
// controla llamadas a animaciones
void update() {
  switch (pantalla) {
    
 // INICIO
    case 1:
      background(ve);
      
      // portada
      image(portadaInicio, 0, 0, res, res);
      
      // menu
      image(displayMenu(res, byte(-1), ro, am, az, ne, f_texto, f_texto_bo), 0, 0);
      
      break;

 // MOVIMIENTO
    case 2:
      
      // agrandar imagen que sale y aparecer sombra
      if (!sinAni) {
        if (!salidaMenu) animaAgrSal(imgSal, sombra, res, sigPos, movSua, salidaMenu);
        else animaAgrSal(portadaInicio, sombra, res, sigPos, movSua, salidaMenu);
      }
      
      // aparecer y agrandar imagen que entra
      animaAgrEnt(imgEnt, res, sigPos, movSua);
      
      // desvanecer texto menu
      if (!sinAni) {
        if (salidaMenu) animaDesv(displayMenu(res, sigPos, ro, am, az, ne, f_texto, f_texto_bo), movimiento);
      }
      
      // aparecer marco negro
      if (!salidaMenu) image(marco, 0, 0, res, res * 1.25);
      else animaMarco(marco, res, movSua);
      
      // botones
      if (!salidaMenu) image(displayBotones(res, colPrin, colAnte, false, ro, am, az, ve, bl, f_texto, f_texto_bo), 0, 0);
      else if (!sinAni) animaApar(displayBotones(res, colPrin, colAnte, false, ro, am, az, ve, bl, f_texto, f_texto_bo), movSua);
      
      // desactivar mano
      if (cursorHand) {
        cursor(ARROW);
        cursorHand = false;
      }
      
      // fin movimiento
      if (movimiento <= 0) pantalla = 3;
     
      break;

 // PUNTO
    case 3:
      
      // imagen
      image(imgEnt, res * 0.05, res * 0.05, res * 0.9, res * 0.9);
      
      // marco
      image(marco, 0, 0, res, res * 1.25);

      // texto
      image(imgTexto, 0, 0);
      
      // botones
      image(displayBotones(res, colPrin, colAnte, true, ro, am, az, ve, bl, f_texto, f_texto_bo), 0, 0);
      
      break;

 // APARECER
    case 4:
    
      if (!sinAni) {

        // reiniciar 
        if (entradaMenu) {
          animaApar(portadaInicioRei, movSua);
          animaApar(displayMenu(res, byte(-1), ro, am, az, ne, f_texto, f_texto_bo), movSua);
        }
        // anterior -> falta implementar
        // else {
        //   animaApar(imgEnt, movSua);
        //   image(marco, 0, 0, res, res * 1.25);
        //   image(displayBotones(res, colPrin, colAnte, false, ro, am, az, ve, bl, f_texto, f_texto_bo), 0, 0);
        //   if (movimiento <= 0) pantalla = 3;
        // }
      }
      
      if (movimiento <= 0) pantalla = 1;

      // desactivar mano
      if (cursorHand) {
        cursor(ARROW);
        cursorHand = false;
      }
    
      break;

 // test error  
    default :
      text("error pantalla: " + pantalla, 20, 20);
      break;
    }
}
