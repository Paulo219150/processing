int px0=100, py0=500, px1=px0, py1=py0, w=150, h=10;
int cx1=500, cy1=425, cx2=500, cy2=575;
float ang=0;
float distRelx1, distRelx2, distRely1, distRely2;
boolean direita, esquerda, cima, baixo;
Retangulo r2 = new Retangulo(cx1,cy1,h,w,ang);
Retangulo r4 = new Retangulo(cx1,cy1,w,h,ang);
Retangulo r1 = new Retangulo(cx2,cy2,h,w,ang);
Retangulo r3 = new Retangulo(cx2,cy2,w,h,ang);

void setup() {
  size(1000,1000);
  frameRate(60);
}

void keyPressed() {
  if (keyCode == RIGHT) direita = true;
  if (keyCode == LEFT) esquerda = true;
  if (keyCode == UP) cima = true;
  if (keyCode == DOWN) baixo = true;
}

void keyReleased() {
  if (keyCode == RIGHT) direita = false;
  if (keyCode == LEFT) esquerda = false;
  if (keyCode == UP) cima = false;
  if (keyCode == DOWN) baixo = false;
}

class Retangulo {
  float cx, cy, w, h, ang;
  float[] x = new float[4];
  float[] y = new float[4];

  Retangulo(float cx, float cy, float w, float h, float ang) {
    this.cx = cx;
    this.cy = cy;
    this.w = w;
    this.h = h;
    this.ang = ang;
    atualizar();
  }
  
  //funçoes para girar os retangulos
  void atualizar() {
    float c = cos(ang);
    float s = sin(ang);
    x[0] = cx - c * (w/2) + s * (h/2);
    y[0] = cy - s * (w/2) - c * (h/2);
    x[1] = cx + c * (w/2) + s * (h/2);
    y[1] = cy + s * (w/2) - c * (h/2);
    x[2] = cx + c * (w/2) - s * (h/2);
    y[2] = cy + s * (w/2) + c * (h/2);
    x[3] = cx - c * (w/2) - s * (h/2);
    y[3] = cy - s * (w/2) + c * (h/2);
  }

  void desenhar() {
    beginShape();
    for (int i = 0; i < 4; i++) {
      vertex(x[i], y[i]);
    }
    endShape(CLOSE);
  }
}

boolean colidiuComRetangulo(Retangulo r) {
  float dx = px1 - r.cx;
  float dy = py1 - r.cy;

  float localX =  cos(r.ang) * dx + sin(r.ang) * dy;
  float localY = -sin(r.ang) * dx + cos(r.ang) * dy;

  return abs(localX) <= r.w / 2 + 15 && abs(localY) <= r.h / 2 + 15;
}

void draw() {
  background (40,80,120);
  noStroke();
  
  //desenhar e atualizar retangulos
  r1.ang += 0.02;
  r1.atualizar();
  r1.desenhar();
  r2.ang -= 0.02;
  r2.atualizar();
  r2.desenhar();
  r3.ang += 0.02;
  r3.atualizar();
  r3.desenhar();
  r4.ang -= 0.02;
  r4.atualizar();
  r4.desenhar();
  
  fill (0);
  rect (0,0,1000,390);
  rect (0,610,1000,390);
  rect (0,390,50,220);
  rect (950,390,50,220);
  fill (250,80,40);
  rect (50,390,100,220);
  fill (80,250,40);
  rect (850,390,100,220);
  
  if (direita) px1++;
  if (esquerda) px1--;
  if (cima) py1--;
  if (baixo) py1++;
  
  if (px1 -15 <= 50) {
    px1++;
  }
  if (px1 +15 >= 950){
    px1--;
  }
  if (py1 -15 <= 390){
    py1++;
  }
  if (py1 +15 >= 610){
    py1--;
  }
  
  if (colidiuComRetangulo(r1) ||
      colidiuComRetangulo(r2) ||
      colidiuComRetangulo(r3) ||
      colidiuComRetangulo(r4)) {
    px1 = px0;
    py1 = py0;
  }
  
  if (px1 -15 > 850) {
    textSize(64);
    fill(255);
    text("VENCEU", width/2, height/2);
  }
  
  fill (160);
  ellipse (px1,py1,30,30);
}  
