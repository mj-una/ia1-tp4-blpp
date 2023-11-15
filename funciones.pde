///////////////////////////////////////////////////////////
//
// FUNCIONES GENERALES
//
// hover -> retorna t/f si mouse sobre cierta area
// click -> controla efectos de clicks segun pantalla
// nuevaImagen -> asigna imagen a imgEnt
// cargaRecorrido -> carga arrayList de puntos
//
///////////////////////////////////////////////////////////

// ________________________________________________________

// devuelve true/false segun si el mouse se encuentra
// entre las coordenadas que recibe como parametro
boolean hover(float x1, float y1, float x2, float y2) {
  if (
    mouseX < x1 + res / 2 ||
    mouseX > x2 + res / 2 ||
    mouseY < y1 + res / 2 ||
    mouseY > y2 + res / 2
    ) return false;
  else return true;
}

// ________________________________________________________

// valida clicks y controla sus efectos segun pantalla
// y posicion en que se hagan (hover)
void click() {
  // FLUJO(*_2) en pantalla 1
  // FLUJO(*_4) en pantalla 3
  
  float dp = res * 0.9; 

  // fuera de la pantalla
  if (mouseX < 0 || mouseX > width || mouseY < 0 || mouseY > height) return;

  switch (pantalla) {

 // pantalla inicio
    case 1:

      // boton rojo
      if (hover(-dp * 0.429, dp * 0.678, -dp * 0.239, dp * 0.797)) {
        sigPos = 1;
      }
      // boton amarillo
      else if (hover(-dp * 0.189, dp * 0.678, dp * 0.189, dp * 0.797)) {
        sigPos = 0;
      }
      // boton azul
      else if (hover(dp * 0.239, dp * 0.678, dp * 0.432, dp * 0.797)) {
        sigPos = 2;
      }
      // salida ningun boton valido
      else break;
      
      // actualiza imgEnt y imgSal
      salidaMenu = true;
      nuevaImagen();

      // actualizar string de posicion
      posicion += sigPos;

      // actualizar objeto vista
      actualizarVista();
      nuevoTexto();

      // FLUJO(*) activa movimiento
      movimiento = velMov; // <- cambia pantalla en draw

      break;

 // pantalla puntos
    case 3:

      // boton rojo
      if (hover(-res * 0.5, -res * 0.3, -dp * 0.215, res)) {
        antPos = sigPos;
        sigPos = 1;
      }
      // boton amarillo
      else if (hover(-dp * 0.214, -res * 0.3, dp * 0.214, res)) {
        antPos = sigPos;
        sigPos = 0;
      }
      // boton azul
      else if (hover(dp * 0.215, -res * 0.3, res * 0.5, res)) {
        antPos = sigPos;
        sigPos = 2;
      }
      // boton inicio
      else if (hover(-res * 0.5, -dp * 0.52, -res * 0.26, -dp * 0.47)) {
        entradaMenu = true;
        colPrin = 0;
        posicion = "i";
        pantalla = 4;
        movimiento = velMov; // FLUJO(*)
        break;
      }
      // boton anterior -> falta implementar
      // else if (hover(res * 0.26, -dp * 0.52, res * 0.5, -dp * 0.47)) {
      //   sigPos = antPos;
      //   retroImagen();
      //   entradaMenu = false;
      //   pantalla = 4;
      //   movimiento = velMov; // FLUJO(*)
      //   break;
      // }

      // salida ningun boton valido
      else break; 

      // actualiza imgEnt y imgSal
      salidaMenu = false;
      nuevaImagen();

      // actualizar string de posicion
      posicion += sigPos;

      // actualizar objeto vista
      actualizarVista();
      nuevoTexto();

      // FLUJO(*) activa movimiento
      movimiento = velMov; // <- cambia pantalla en draw
 
      break;
  
 // invalido
    default :
      break;
  }
}

// ________________________________________________________

// asigna nueva imagen a imgEnt
// evaluando color actual y posicion siguiente
void nuevaImagen() {
  nueIma(true); }
void retroImagen() { // color anterior -> falta implementar
  nueIma(false); }
void nueIma(boolean adelante) {
  
  // color anterior -> falta implementar
  if (adelante) colAnte = colPrin;
  else colPrin = colAnte;

  // imagen que sale
  imgSal = imgEnt;
  
  // imagen que entra
  if (colPrin == 0) { // del amarrillo
    if (sigPos == 1) imgEnt = vRoAzAm; // al rojo
    else if (sigPos == 2) imgEnt = vAzAmRo; // al azul
    else if (sigPos == 0) imgEnt = vAmRoAz; // al amarillo
    colPrin = sigPos;
  }
  else if (colPrin == 1) { // del rojo
    if (sigPos == 1) {
      imgEnt = vAzAmRo; // al azul
      colPrin = 2;
    }
    else if (sigPos == 2) {
      imgEnt = vAmRoAz; // al amarillo
      colPrin = 0;
    }
    else if (sigPos == 0) {
      imgEnt = vRoAzAm; // al rojo
      colPrin = 1;
    }
  }
  else if (colPrin == 2) { // del azul
    if (sigPos == 1) {
      imgEnt = vAmRoAz; // al amarillo
      colPrin = 0;
    }
    else if (sigPos == 2) {
      imgEnt = vRoAzAm; // al rojo
      colPrin = 1;
    }
    else if (sigPos == 0) {
      imgEnt = vAzAmRo; // al azul
      colPrin = 2;
    }
  }
}

// ________________________________________________________

// actualiza texto en imgTexto
void nuevoTexto() {

  // revisa si existe algun punto para esta posicion
  // y llama a funcion pgraphics que dibuja texto
  if (vista != null) imgTexto = displayTexto(res, vista.tex, bl, f_texto);
  else imgTexto = displayTexto(res, "...", bl, f_texto);
}

// ________________________________________________________

// carga arraylist "lista" con arrays de recorridos*
// segun nombres de archivo que contiene el index.
// (*)cada recorrido contiene varios punto
void cargaRecorridos() {

  // carga indice
  String index[] = loadStrings(INDEX); // indice de archivos

  for (int i = 0; i < index.length; i++) {

    // array temporal -> index linea i
    String[] index_linea = index[i].split("_");
    
    // primera linea index
    if (i == 0) {
      user = index_linea[1];
      /* otros datos, por ejemplo
      densidad = index_linea[3]; */
      continue; // salta a siguiente linea
    }

    // nombre archivo de recorrido
    String archivo = index_linea[0];

    // array temporal con archivo de recorrido
    String[] reco_temp = loadStrings("data/" + archivo);

    // array temporal con resultado del segundo ciclo for
    Punto[] reco_salida = new Punto[reco_temp.length - 1];

    for (int j = 0; j < reco_temp.length; j++) {

      // info recorridos (global)
      if (j == 0) {
        info_recorridos.add(reco_temp[j]);
        continue; // solo afecta a indice j, no a i
      }
      
      // array temporal -> reco_temp linea j
      String[] reco_temp_linea = reco_temp[j].split("_");

      // creacion de objeto Punto
      reco_salida[j - 1] = new Punto(reco_temp_linea[0], reco_temp_linea[1]);
    }

    // carga array a la lista
    lista.add(reco_salida);
  }
}

// ________________________________________________________

// actualiza objeto vista (global)
// segun string de posicion actual
void actualizarVista() {

  // determina recorrido: amarillo, rojo o azul
  int rec = Character.getNumericValue(posicion.charAt(1));

  // objeto temporal vacio
  Punto vista_actu = null;

  // posicion temporal (sin "i")
  String pos_temp = posicion.substring(1, posicion.length());

  // busca objeto segun propiedad pos
  for (Punto pto : lista.get(rec)) {

    // compara si es igual
    if (pto.pos.equals(pos_temp)) {
      
      vista_actu = pto;
      break;
    }
  }

  // asigna a vista
  vista = vista_actu;
}
