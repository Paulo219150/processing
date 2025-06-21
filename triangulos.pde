int cx, cy, r1=10;
float a=PI/6, e=1;
Triangle[] triangulos = new Triangle[8];

void setup () {
  fullScreen();
  colorMode(HSB, 360, 100, 100);
  cx = width/2;
  cy = height/2;
  noFill();
  frameRate(60);
  print(cx,cy);
  
  for (int i = (triangulos.length -1); i > 0; i--) {
    float escale = pow(-2,i);
    triangulos[i] = new Triangle(escale);
  }
}

class Triangle {
  float e,ang,h;
  float[] x = new float[3];
  float[] y = new float[3];
  
  Triangle(float e) {
    this. e = e;
    atualizar();
  }
  
  void atualizar() {
    x[0] = cx + r1 * e * (cos(ang + 3*a));
    y[0] = cy + r1 * e * (sin(ang + 3*a));
    x[1] = cx + r1 * e * (cos(ang + 7*a));
    y[1] = cy + r1 * e * (sin(ang + 7*a));
    x[2] = cx + r1 * e * (cos(ang + 11*a));
    y[2] = cy + r1 * e * (sin(ang + 11*a));
  }
  
  void colorir() {
  fill(h,66,50);
  h = 180 - 180*sin(ang);
  }
  
  
  void desenhar() {
    beginShape();
    for (int i =0; i < 3; i++) {
      vertex (x[i], y[i]);
    }
    endShape(CLOSE);
  }  
}

void draw() {
  background(0);
  
  for (int i = (triangulos.length -1); i > 0; i--) {
  float sentido = i % 2 == 0 ? 1 : -1;
      triangulos[i].ang += sentido * 0.025;
  }
  for (int i = (triangulos.length -1); i > 0; i--) {
      triangulos[i].atualizar();
      triangulos[i].colorir();
      triangulos[i].desenhar();    
  }
}  
