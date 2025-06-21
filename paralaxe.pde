int grid = 10;
int x0 = 50, y0 = 50;
Camada[] c = new Camada[10];

class Camada {
  float n;
  float[][] x;
  float[][] y;
  float[][] vx;
  float[][] vy;
  
  Camada(int n) {
    this.n = n;
    x = new float[n][n];
    y = new float[n][n];
    vx = new float[n][n];
    vy = new float[n][n];
    for(int i = 0; i < n; i++) {
      for(int j = 0; j < n; j++) {
        x[i][j] = x0 + 100*i;
        y[i][j] = y0 + 100*j;
      }
    }
  }
  
  void desenhar() {
    for(int i = 0; i < n; i++) {
      for(int j = 0; j < n; j++) {
        x[i][j] += vx[i][j];
        y[i][j] += vy[i][j];
        if (i == n-1 || j == n-1) {
          float r = 5 + 3*n;
          fill(36*n, 100,100);
          circle(x[i][j], y[i][j], r);
        }
      }
    }
  }
  
  void atualizar() {
    for(int i = 0; i < n; i++) {
      for(int j = 0; j < n; j++) {
        vx[i][j] = (mouseX-pmouseX)*(n/30);
        vy[i][j] = -(pmouseY-mouseY)*(n/30);
      }
    }
  }
}

void setup() {
  colorMode(HSB,360,100,100);
  size(1000,1000);
  frameRate(60);
  for (int n = 0; n < 10; n++) {
    c[n] = new Camada(n);
  }
}

void draw () {
  background(0);
  for (int n = 0; n < 10; n++) {
    c[n].atualizar();
    c[n].desenhar();
  }
}
