///////////////////////////////////////////////////////////
//
// FUNCIONES DE ANIMACION
//
// animaAgrSal -> anima imagen que sale, de normal a grande
// animaAgrEnt -> anima imagen que entra, de chica a normal
// animaMarco -> anima aparicion del marco negro
// animaApar -> anima aparicion (general)
// animaDesv -> anima desvanecimiento (general)
//
///////////////////////////////////////////////////////////

// ________________________________________________________

// agrandar imagen que sale
// y sombra de inv a vis
void animaAgrSal(PGraphics imgIn, PGraphics imgFi, int ri, byte sig, float t, boolean sm) {
  // - imgIn = imagen que sale
  // - imgFi = imagen de la sombra
  // - ri = resolucion interna
  // - sig = siguiente posicion
  // - t = estado del movimiento
  // - sm = salida menu (si es primer movimiento)

  float ce = ri * 0.5;
  float dp = ri * 0.9;
  float prc = map(t, 0, velMov, 1.0, 0);
  float opa = map(t, 0, velMov, 255, 0);
  float cos = cos(radians(240));
  float sen = sin(radians(240));
  
  if (!sm) {
    PGraphics aux = createGraphics(ri, ri);
    aux.beginDraw();
    aux.image(imgIn, ri * 0.05, ri * 0.05, dp, dp);
    aux.endDraw();
    imgIn = aux;
  }
  
  if (opa < 0) opa = 0;

  pushMatrix();
  
  translate(ce, ce);
  
  if (sig == 0) {
    
    scale(1 + 2 * prc);
    
    image(imgIn, -ce, -ce, ri, ri);
    
    push();
    tint(255, opa);
    image(imgFi, -ce, -ce, ri, ri * 1.25);
    pop();
  }
  else if (sig == 1) {
    translate(cos * (dp / 3), 
    sen * (dp / 3));
    
    translate(-cos * (dp / 3) * prc,
    -sen * (dp / 3) * prc);
    
    scale(1 + 2 * prc);
    
    image(imgIn, -ce - cos * (dp / 3), -ce -sen * (dp / 3), ri, ri);
    
    push();
    tint(255, opa);
    image(imgFi, -ce - cos * (dp / 3), -ce -sen * (dp / 3), ri, ri * 1.25);
    pop();
  }
  else if (sig == 2) {
    translate(-cos * (dp / 3), 
    sen * (dp / 3));
    
    translate(cos * (dp / 3) * prc,
    -sen * (dp / 3) * prc);
    
    scale(1 + 2 * prc);
    
    image(imgIn, -ce + cos * (dp / 3), -ce -sen * (dp / 3), ri, ri);
    
    push();
    tint(255, opa);
    image(imgFi, -ce + cos * (dp / 3), -ce -sen * (dp / 3), ri, ri * 1.25);
    pop();
  }

  popMatrix();
}

// ________________________________________________________

// agrandar imagen que entra
// y opacidad de inv a vis
void animaAgrEnt(PGraphics imgFi, int ri, byte sig, float t) {
  // - imgFi = imagen que entra (aparece y se agranda)
  // - ri = resolucion interna
  // - sig = siguiente posicion
  // - t = estado del movimiento
  // - sm = salida menu (si es primer movimiento)
  
  float ce = ri * 0.5;
  float dp = ri * 0.9;
  float prc = map(t, 0, velMov, 0, 1.0);
  float opa = map(t, 0, velMov, 255, 0);
  float cos = cos(radians(240));
  float sen = sin(radians(240));
  
  PGraphics aux = createGraphics(ri, ri);
  aux.beginDraw();
  aux.image(imgFi, ri * 0.05, ri * 0.05, dp, dp);
  aux.endDraw();
  imgFi = aux;

  pushMatrix();
  translate(ce, ce);
  
  if (sig == 0) {
    
    scale(1 - (2 / 3.0) * prc);
    
    push();
    tint(253, opa);
    image(imgFi, -ce, -ce, ri, ri);
    pop();
  }
  else if (sig == 1) {

    translate(cos * (dp / 3) * prc,
    sen * (dp / 3) * prc);
    
    scale(1 - (2 / 3.0) * prc);
    
    push();
    tint(253, opa);
    image(imgFi, -ce, -ce, ri, ri);
    pop();
  }
  else if (sig == 2) {

    translate(-cos * (dp / 3) * prc,
    sen * (dp / 3) * prc);
    
    scale(1 - (2 / 3.0) * prc);
    
    push();
    tint(253, opa);
    image(imgFi, -ce, -ce, ri, ri);
    pop();
  }
  
  popMatrix();
}

// ________________________________________________________

// entrada marco del primero movimiento
void animaMarco(PGraphics img, int ri, float t) {
  // - img = imagen marco
  // - ri = resolucion interna
  // - t = estado del movimiento

  float prc = map(t, 0, velMov, 0, 1.0);

  pushMatrix();
  resetMatrix();
  translate(ri * 0.5, ri * 0.5);
  scale(1 + prc);
  image(img, -img.width * 0.5, -img.width * 0.5);
  popMatrix();
}

// ________________________________________________________

// aparecer imagen (opa de inv a vis)
void animaApar(PGraphics img, float t) {
  // - img = imagen que entra
  // - ri = resolucion interna
  // - t = estado del movimiento

  float opa = map(t, 0, velMov, 255, 0);
  if (opa < 0) opa = 0;

  push();
  tint(255, opa);
  image(img, 0, 0);
  pop();
}

// ________________________________________________________

// desvanecer imagen (opa de vis a inv)
void animaDesv(PGraphics img, float t) {
  // - img = imagen que sale
  // - ri = resolucion interna
  // - t = estado del movimiento

  float opa = map(t, 0, velMov, -255 * 2, 255);
  if (opa < 0) opa = 0;

  push();
  tint(255, opa);
  image(img, 0, 0);
  pop();
}
