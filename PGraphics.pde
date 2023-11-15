///////////////////////////////////////////////////////////
//
// FUNCIONES DE DIBUJO
//
// displayFractal -> retorna fractal generico 
// displayInicio -> retorna imagen portada inicio
// displaySombra -> retorna espacio negro entre circulos
// displayMarco -> retorna borde redondo negro
// displayMenu -> retorna menu inicio (dinamico)
// displayBotones -> retorna botones (dinamico)
// displayTexto -> retorna texto vista actual
//
///////////////////////////////////////////////////////////

// ________________________________________________________

// retorna fractal tipo 1+(1+6)
// es llamada individualmente y por displayInicio
PGraphics displayFractal(int ri, color prin, color cen, color izq, color der, color neg, boolean fVer) {
  // - ri = resolucion interna
  // - prin = color circulo pricipal (depende de fVer)
  // - cen = color circulo central interno (y/o principal)
  // - izq = color circulos laterales pares internos
  // - der = color circulos laterales impare internos
  // - neg = color negro
  // - fVer = detalle verde

  float dn = ri / 3.0; // diametro circulos internos
  
  PGraphics f = createGraphics(ri, ri);
  
  push();
  pushMatrix();
  
  f.beginDraw();
  f.stroke(neg);
  f.strokeWeight(ri / 800.0);
  f.resetMatrix();
  f.translate(ri * 0.5, ri * 0.5);
  
  if (fVer) f.fill(cen);
  else f.fill(prin);
  
  f.circle(0, 0, ri); // circulo principal
  
  // fondo verde
  if (fVer) {
    f.push();
    f.noStroke();
    f.fill(prin);
    f.circle(0, 0, ri * sqrt(3) / 3.0);
    f.pop();
  }
  
  f.fill(cen);
  f.circle(0, 0, dn); // circulo central
  
  for (byte i = 0; i < 6; i++) {
    
    float x = 0;
    float y = 0;
    
    x = cos(radians(i * 60)) * dn;
    y = sin(radians(i * 60)) * dn;
    
    if (i % 2 == 0) f.fill(izq);
    else f.fill(der);
    
    f.circle(x, y, dn); // circulos laterales
  }
  
  
  f.endDraw();
  
  popMatrix();
  pop();
  
  return f;
}

// ________________________________________________________

// retorna portada de inicio
// llama a fractal modelo varias veces
// y dibuja letras en bordes y esquinas
PGraphics displayInicio(int ri, color ver, color ama, color roj, color azu, color neg, PFont f_port) {
  // - ri = resolucion interna
  // - ver = color verde
  // - ama = color amarillo
  // - roj = color rojo
  // - azu = color azul 
  // - neg = color negro
  // - f_port = tipografia portada

  float ce = ri * 0.5; // centro circulo principal
  float dp = ri * 0.9; // diametro circulo principal
  float dn = dp / 3.0; // diametro circulos internos
  
  PGraphics m = createGraphics(ri, ri);
  
  m.beginDraw();
  m.push();
  m.pushMatrix();
  m.resetMatrix();

  m.textFont(f_port);
  m.textAlign(CENTER, TOP);
  m.stroke(neg);
  m.strokeWeight(ri / 800.0);
  m.rectMode(CENTER);
  m.translate(ce, ce);
  m.background(ver);

  // cuadrado amarillo 
  m.fill(ama);
  m.rect(0, 0, dp, dp);
  
  // base
  m.push();
  m.pushMatrix();
  m.resetMatrix();
  m.image(displayFractal(int(dp), ver, ama, roj, azu, neg, false), ri * 0.05, ri * 0.05);

  // relleno centro
  m.resetMatrix();
  m.image(displayFractal(int(dn), ama, neg, roj, azu, neg, false), ce - dn / 2.0, ce - dn / 2.0);
  m.image(displayFractal(int(dn), color(1, 0), color(1, 0), color(1, 0), color(1, 0), neg, false), ce - dn / 2.0, ce - dn / 2.0);

  // relleno laterales
  m.resetMatrix();
  PGraphics casoPar = displayFractal(int(dn), color(1, 0), roj, azu, ama, neg, false);
  PGraphics casoImpar = displayFractal(int(dn), color(1, 0), azu, ama, roj, neg, false);
  m.popMatrix();
  m.pop();
  
  // ciclo rotacion
  float aux = dn * sqrt(3) / 3.0;
  for (byte i = 0; i < 6; i++) {
    
    // posicion
    m.push();
    m.pushMatrix();
    m.resetMatrix();
    m.translate(ce, ce);
    m.rotate(radians(i * 60));
    m.translate(dn, 0);

    // espacios negros
    m.fill(neg);
    m.noStroke();
    m.circle(0, 0, aux);

    // laterales
    if (i % 2 == 0) m.image(casoPar, -dn / 2.0, -dn / 2.0);
    else m.image(casoImpar, -dn / 2.0, -dn / 2.0);
    
    m.popMatrix();
    m.pop();
  }

  // letras
  m.push();
  m.pushMatrix();
  m.resetMatrix();
  m.translate(ce + dn / 432, ce + dn / 432);
  m.fill(neg);
  m.circle(-dp / 2 - dp / 40, -dp / 2 - dp / 40, ri / 38);
  m.textFont(f_port);
  m.textSize(ri / 18.0);
  m.textAlign(CENTER, TOP);
  m.text("BLiPiP BLiPiP BLiPiP BLiPiP BLiPiP", -dp / 900, dp / 2 + dp / 900);
    m.push();
    m.textSize(ri * 2.7 / 17.8);
    m.textAlign(LEFT, TOP);
    m.text("B", -dp / 2 + dp / 44, -dp / 2 + dp / 26);
    m.textAlign(RIGHT, TOP);
    m.text("L", dp / 2 - dp / 32, -dp / 2 + dp / 26);
    m.textAlign(LEFT, BOTTOM);
    m.text("P", -dp / 2 + dp / 44, dp / 2 - dp / 80);
    m.textAlign(RIGHT, BOTTOM);
    m.text("P", dp / 2 - dp / 58, dp / 2 - dp / 80);
    m.pop();
  m.rotate(PI / 2.0);
  m.circle(-dp / 2 - dp / 40, -dp / 2 - dp / 40, ri / 38);
  m.text("BLiPiP BLiPiP BLiPiP BLiPiP BLiPiP", -dp / 900, dp / 2 + dp / 900);
  m.rotate(PI / 2.0);
  m.circle(-dp / 2 - dp / 40, -dp / 2 - dp / 40, ri / 38);
  m.text("BLiPiP BLiPiP BLiPiP BLiPiP BLiPiP", -dp / 900, dp / 2 + dp / 900);
  m.rotate(PI / 2.0);
  m.circle(-dp / 2 - dp / 40, -dp / 2 - dp / 40, ri / 38);
  m.text("BLiPiP BLiPiP BLiPiP BLiPiP BLiPiP", -dp / 900, dp / 2 + dp / 900);
  m.popMatrix();
  m.pop();
  
  m.popMatrix();
  m.pop();
  
  m.endDraw();
  
  return m;
}

// ________________________________________________________

// retorna circulo transparente
// con marco exterior negro
PGraphics displayMarco(int ri, color neg) {
  // - ri = resolucion interna
  // - neg = color negro
  
  float ce = ri * 0.5; // centro circulo principal
  float ra = ri * 0.45; // radio circulo principal
  
  float x = 0.0;
  float y = 0.0;
  
  PGraphics salida = createGraphics(ri, int(ri * 1.25));
  PShape c = createShape();
 
  push();
  pushMatrix();
  
  c.beginShape();
  c.resetMatrix();
  c.fill(neg);
  c.noStroke();
  
  // circulo
  for (int i = 0; i < 361; i++) {

    x = cos(radians(i + 270)) * ra;
    y = sin(radians(i + 270)) * ra;
    c.vertex(ce + x, ce + y);
  }
  
  // borde exterior
  x = ce;
  y = 0;
  c.vertex(x, y); // pto medio sup
  
  x = 0;
  c.vertex(x, y); // esq sup izq

  y = ri * 1.25;
  c.vertex(x, y); // esq inf izq

  x = ri;
  c.vertex(x, y); // esq inf der
  
  y = 0;
  c.vertex(x, y); // esq sup der
  
  x = ce;
  c.vertex(x, y); // pto medio sup
  
  c.endShape(CLOSE);
  
  salida.beginDraw();
  salida.resetMatrix();
  salida.shape(c, 0, 0);
  salida.endDraw();
  
  popMatrix();
  pop();

  return salida;
}

// ________________________________________________________

// retorna forma compuesta de 7 circulos transparentes
// (ordenados como displayFractal) y espacio negativo negro
PGraphics displaySombra(int ri, color neg) {
  // - ri = resolucion interna
  // - neg = color negro

  float ce = ri * 0.5; // centro circulo principal
  float dp = ri * 0.9; // diametro circulo principal
  float ra = dp * 0.5 / 3.0; // radio circulos internos
  
  float x = 0.0;
  float y = 0.0;
  
  float x_t; // auxiliar
  float y_t; // auxiliar
  
  PGraphics salida = createGraphics(ri, int(ri * 1.25));
  PShape c = createShape();

  push();
  pushMatrix();
  
  c.beginShape();
  c.resetMatrix();
  c.fill(neg);
  c.noStroke();
  
  // media vuelta (inf) en circ der
  x_t = ce + dp / 3.0;
  for (int i = 0; i < 181; i++) {

    x = cos(radians(i)) * ra;
    y = sin(radians(i)) * ra;
    c.vertex(x_t + x, ce + y);
  }
  
  // primer sexto (inf der) en circ cen
  for (int i = 0; i < 61; i++) {
    
    x = cos(radians(i)) * ra;
    y = sin(radians(i)) * ra;
    c.vertex(ce + x, ce + y);
  }
  
  // vuelta completa en circ inf der
  x_t = ce + dp / 6.0;
  y_t = ce + ra * sqrt(3);
  for (int i = 0; i < 361; i++) {
    
    x = cos(radians(i + 240)) * ra;
    y = sin(radians(i + 240)) * ra;
    c.vertex(x_t + x, y_t + y);
  }
  
  // segundo sexto (inf) en circ cen
  for (int i = 0; i < 61; i++) {
    
    x = cos(radians(i + 60)) * ra;
    y = sin(radians(i + 60)) * ra;
    c.vertex(ce + x, ce + y);
  }
  
  // vuelta completa en circ inf izq
  x_t = ce - dp / 6.0;
  y_t = ce + ra * sqrt(3);
  for (int i = 0; i < 361; i++) {
    
    x = cos(radians(i + 300)) * ra;
    y = sin(radians(i + 300)) * ra;
    c.vertex(x_t + x, y_t + y);
  }
  
  // tercer sexto (inf izq) en circ cen
  for (int i = 0; i < 61; i++) {
    
    x = cos(radians(i + 120)) * ra;
    y = sin(radians(i + 120)) * ra;
    c.vertex(ce + x, ce + y);
  }
  
  // vuelta completa en circ izq
  x_t = ce - dp / 3.0;
  for (int i = 0; i < 361; i++) {

    x = cos(radians(i)) * ra;
    y = sin(radians(i)) * ra;
    c.vertex(x_t + x, ce + y);
  }
  
  // cuarto sexto (suo izq) en circ cen
  for (int i = 0; i < 61; i++) {
    
    x = cos(radians(i + 180)) * ra;
    y = sin(radians(i + 180)) * ra;
    c.vertex(ce + x, ce + y);
  }
  
  // vuelta completa en circ sup izq
  x_t = ce - dp / 6.0;
  y_t = ce - ra * sqrt(3);
  for (int i = 0; i < 361; i++) {
    
    x = cos(radians(i + 60)) * ra;
    y = sin(radians(i + 60)) * ra;
    c.vertex(x_t + x, y_t + y);
  }
  
  // quinto sexto (sup) en circ cen
  for (int i = 0; i < 61; i++) {
    
    x = cos(radians(i + 240)) * ra;
    y = sin(radians(i + 240)) * ra;
    c.vertex(ce + x, ce + y);
  }
  
  // vuelta completa en circ sup der
  x_t = ce + dp / 6.0;
  y_t = ce - ra * sqrt(3);
  for (int i = 0; i < 361; i++) {
    
    x = cos(radians(i + 300)) * ra;
    y = sin(radians(i + 300)) * ra;
    c.vertex(x_t + x, y_t + y);
  }
  
  // ultimo sexto (sup der) en circ cen
  for (int i = 0; i < 61; i++) {
    
    x = cos(radians(i + 300)) * ra;
    y = sin(radians(i + 300)) * ra;
    c.vertex(ce + x, ce + y);
  }
  
  // media vuelta (sup) en circ der
  x_t = ce + dp / 3.0;
  for (int i = 0; i < 181; i++) {

    x = cos(radians(i + 180)) * ra;
    y = sin(radians(i + 180)) * ra;
    c.vertex(x_t + x, ce + y);
  }
  
  // borde exterior
  x = ri;
  y = ri * 0.5;
  c.vertex(x, y); // inter der
  
  y = 0;
  c.vertex(x, y); // esq sup der

  x = 0;
  y = 0;
  c.vertex(x, y); // esq sup izq

  y = ri * 1.25;
  c.vertex(x, y); // esq inf izq
  
  x = ri;
  c.vertex(x, y); // esq inf der
  
  y = ri * 0.5;
  c.vertex(x, y); // inter der
  
  c.endShape(CLOSE);
  
  salida.beginDraw();
  salida.resetMatrix();
  salida.shape(c, 0, 0);
  salida.endDraw();
  
  popMatrix();
  pop();

  return salida;
}

// ________________________________________________________

// retorna menu inicio (dinamico, cambia valores segun frameCount, hover mouse y mrc)
// se le llama constantemente con pantalla = 1
PGraphics displayMenu(int ri, byte mrc, color roj, color ama, color azu, color neg, PFont f_tex, PFont f_tex_bo) {
  // - ri = resolucion interna
  // - mrc = marca de color seleccionado (-1 si no es ninguno)
  // - roj = color rojo
  // - ama = color amarillo
  // - azu = color azul
  // - neg = color negro
  // - t_tex = tipografia texto
  // - t_tex_bo = tipografia texto resaltado

  float dp = ri * 0.9; // diametro circulo principal
  
  PGraphics u = createGraphics(ri, int(ri * 1.25));

  u.beginDraw();
  u.push();
  u.noStroke();
  u.translate(ri / 2, ri / 2);
  u.textAlign(CENTER, CENTER);

  // rojo
  u.push();
  if (hover(-dp * 0.429, dp * 0.678, -dp * 0.239, dp * 0.797) || mrc == 1) {
    u.fill(roj);
    u.textFont(f_tex_bo);
    u.circle(-dp / 3, dp * 0.783, dp / 35);
  }
  else {
    u.fill(neg, (sin((frameCount + 30) / 15.0) + 1) * 90 + 75);
    u.textFont(f_tex);
    u.push();
    u.fill(roj, 160);
    u.circle(-dp / 3, dp * 0.783, dp / 41);
    u.pop();
  }
  u.textSize(dp / 13);
  u.text("rojo", -dp / 3, dp * 0.719);
  u.pop();

  // amarillo
  u.push();
  if (hover(-dp * 0.189, dp * 0.678, dp * 0.189, dp * 0.797) || mrc == 0) {
    u.fill(ama);
    u.textFont(f_tex_bo);
    u.circle(0, dp * 0.783, dp / 35);
  }
  else {
    u.fill(neg, (sin((frameCount + 20) / 15.0) + 1) * 90 + 75);
    u.textFont(f_tex);
    u.push();
    u.fill(ama, 180);
    u.circle(0, dp * 0.783, dp / 41);
    u.pop();
  }
  u.textSize(dp / 13);
  u.text("amarillo", 0, dp * 0.719);
  u.pop();

  // azul
  u.push();
  if (hover(dp * 0.239, dp * 0.678, dp * 0.432, dp * 0.797) || mrc == 2) {
    u.fill(azu);
    u.textFont(f_tex_bo);
    u.circle(dp / 3, dp * 0.783, dp / 35);
  }
  else {
    u.fill(neg, (sin((frameCount + 10) / 15.0) + 1) * 90 + 75);
    u.textFont(f_tex);
    u.push();
    u.fill(azu, 150);
    u.circle(dp / 3, dp * 0.783, dp / 41);
    u.pop();
  }
  u.textSize(dp / 13);
  u.text("azul", dp / 3, dp * 0.719);
  u.pop();
  
  // instruccion
  u.fill(neg, 100);
  u.textFont(f_tex);
  u.textSize(dp / 22);
  u.text("selecciona un camino", 0, dp * 0.639);
  u.pop();
  
  u.endDraw();
  
  if (mrc == 0 || mrc == 1 || mrc == 2) return u;
  
  // cursor
  if (
  hover(-dp * 0.429, dp * 0.678, -dp * 0.239, dp * 0.797) ||
  hover(-dp * 0.189, dp * 0.678, dp * 0.189, dp * 0.797) ||
  hover(dp * 0.239, dp * 0.678, dp * 0.432, dp * 0.797) ) {
    if (!cursorHand) cursor(HAND);
    cursorHand = true;
    }
  else {
    if (cursorHand) cursor(ARROW);
    cursorHand = false;
  }

  return u;
}

// ________________________________________________________

// retorna botones reiniciar, anterior, izquierda, centro, derecha
PGraphics displayBotones(int ri, byte colAct, byte colAnt, boolean dinamico, color roj, color ama, color azu,  color ver, color bla, PFont f_tex, PFont f_tex_bo) {
  // - ri = resolucion interna
  // - colAct = color actual
  // - dinamico = si es interactuable
  // - roj = color rojo
  // - ama = color amarillo
  // - azu = color azul
  // - bla = color blanco
  // - t_tex = tipografia texto
  // - t_tex_bo = tipografia texto resaltado

  float dp = ri * 0.9; // diametro circulo principal
  
  PGraphics p = createGraphics(ri, int(ri * 1.25));
  
  color roj_op = color(roj, 170);
  color ama_op = color(ama, 198);
  color azu_op = color(azu, 160);
  
  color izq = 0;
  color cen = 0;
  color der = 0;
  color izq_op = 0;
  color cen_op = 0;
  color der_op = 0;
  
  if (colAct == 1) {
    izq = azu;
    cen = roj;
    der = ama;
    izq_op = azu_op;
    cen_op = roj_op;
    der_op = ama_op;
  }
  else if (colAct == 0) {
    izq = roj;
    cen = ama;
    der = azu;
    izq_op = roj_op;
    cen_op = ama_op;
    der_op = azu_op;
  }
  else if (colAct == 2) {
    izq = ama;
    cen = azu;
    der = roj;
    izq_op = ama_op;
    cen_op = azu_op;
    der_op = roj_op;
  }
 
  p.beginDraw();
  p.push();
  p.noStroke();
  p.translate(ri * 0.5, 0);
  
  // reinicio
  if (dinamico && hover(-ri * 0.5, -dp * 0.52, -ri * 0.26, -dp * 0.47)) {
    p.textFont(f_tex_bo);
    p.fill(bla);
    p.push();
    p.fill(ver);
    p.circle(-ri * 0.444, ri * 0.05, dp / 35);
    p.pop();
  }
  else {
    p.textFont(f_tex);
    p.fill(bla, 160);
    p.push();
    p.fill(ver, 150);
    p.circle(-ri * 0.444, ri * 0.05, dp / 41);
    p.pop();
  }
  p.textAlign(LEFT, CENTER);
  p.textSize(ri / 30);
  p.text("inicio", -ri * 0.42, ri * 0.05);
  
  // anterior -> falta implementar
  // if (dinamico && hover(ri * 0.26, -dp * 0.52, ri * 0.5, -dp * 0.47)) {
  //   p.textFont(f_tex_bo);
  //   p.fill(bla);
  //   p.push();
  //   if (colAnt == 0) p.fill(ama);
  //   if (colAnt == 1) p.fill(roj);
  //   if (colAnt == 2) p.fill(azu);
  //    p.circle(ri * 0.444, ri * 0.05, dp / 35);
  //   p.pop();
  // }
  // else {
    p.textFont(f_tex);
    p.fill(bla, 160);
    p.push();
    if (colAnte == 0) p.fill(ama_op);
    if (colAnte == 1) p.fill(roj_op);
    if (colAnte == 2) p.fill(azu_op);
    p.circle(ri * 0.444, ri * 0.05, dp / 41);
    p.pop();
  // }
  p.textAlign(RIGHT, CENTER);
  p.textSize(ri / 30);
  p.text("anterior", ri * 0.408, ri * 0.05);
  
  // boton izquierda
  p.translate(0, ri * 0.5);
  if (dinamico && hover(-res * 0.5, -ri * 0.3, -dp * 0.215, res)) {
    p.fill(izq);
    p.circle(-dp / 3, dp * 0.783, dp / 35);
  }
  else {
    p.fill(izq_op);
    p.circle(-dp / 3, dp * 0.783, dp / 41);
  }
  
  // boton centro
  if (dinamico && hover(-dp * 0.214, -ri * 0.3, dp * 0.214, res)) {
    p.fill(cen);
    p.circle(0, dp * 0.783, dp / 35);
  }
  else {
    p.fill(cen_op);
    p.circle(0, dp * 0.783, dp / 41);
  }
  
  // boton derecha
  if (dinamico && hover(dp * 0.215, -ri * 0.3, res * 0.5, res)) {
    p.fill(der);
    p.circle(dp / 3, dp * 0.783, dp / 35);
  }
  else {
    p.fill(der_op);
    p.circle(dp / 3, dp * 0.783, dp / 41);
  }
  
  p.pop();
  p.endDraw();
  
  if (!dinamico) return p;
  
  // cursor
  if (
  hover(-ri * 0.5, -dp * 0.52, -ri * 0.26, -dp * 0.47) ||
  /*hover(ri * 0.26, -dp * 0.52, ri * 0.5, -dp * 0.47) ||*/
  dist(mouseX - ri / 2, mouseY - ri / 2, -dp / 3, dp * 0.783) < dp / 35 ||
  dist(mouseX - ri / 2, mouseY - ri / 2, 0, dp * 0.783) < dp / 35 ||
  dist(mouseX - ri / 2, mouseY - ri / 2, dp / 3, dp * 0.783) < dp / 35 ) {
    if (!cursorHand) cursor(HAND);
    cursorHand = true;
    }
  else {
    if (cursorHand) cursor(ARROW);
    cursorHand = false;
  }
  
  return p;
}

// ________________________________________________________

// retorna texto vista actual
PGraphics displayTexto(int ri, String tex, color bla, PFont f_tex) {
  // - ri = resolucion interna
  // - tex = texto de la vista
  // - bla = color blanco
  // - f_tex = tipografia texto

  float dp = ri * 0.9; // diametro circulo principal

  PGraphics t = createGraphics(ri, int(ri * 1.25));

  t.beginDraw();
  t.push();
  t.pushMatrix();
  t.fill(bla);
  t.textAlign(CENTER, CENTER);
  t.textFont(f_tex);
  t.textSize(ri / 24.0);

  t.translate(ri * 0.5, ri);
  t.text(tex, -dp * 0.5, 0, dp, dp * 0.16);

  t.pop();
  t.popMatrix();
  t.endDraw();

  return t;
}