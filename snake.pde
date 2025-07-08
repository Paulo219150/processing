int z = 25;
int[] a = new int[z];
int[] b = new int[z];
int[] y = new int[z*z];
int[] x = new int[z*z];
int velX = 40, velY = 40;
int comprimento = 1;
boolean direita, esquerda, cima, baixo;
Jogador j = new Jogador();

class Jogador {
  boolean colidiu = false;
  
  void desenhar() {
    for(int i = comprimento; i > 0; i--) {
      fill(250,180,180);
      rect(x[i], y[i], 40, 40);
    }
  }
  
  void mover() {
    for (int i = comprimento; i > 0; i--) {
      x[i] = x[i - 1];
      y[i] = y[i - 1];
    }
    
    if(colidiu) noLoop();
    
    if(baixo) y[0] +=velY;
    if(cima) y[0] -=velY;
    if(direita) x[0] +=velX;
    if(esquerda) x[0] -=velX;
    
    if (x[0] < 0) x[0] = 960;
    if (x[0] > 960) x[0] = 0;
    if (y[0] < 0) y[0] = 960;
    if (y[0] > 960) y[0] = 0;
    
    for (int i = comprimento -1; i > 0; i--) {
      if(x[0] == x[i+1] && y[0] == y[i+1]) colidiu = true;
    }
  }
}

void setup() {
  size(1000,1000);
  frameRate(6);
  for(int i = 0; i < z; i++) {
    a[i] = int(random(z));
    b[i] = int(random(z));
  }  
}

void draw() {
  for(int i = 0; i < z; i++) {
    for(int j = 0; j < z; j++) {
      fill(180, 255, 180);
      rect(i*40, j*40, 40, 40);
    }
  }
  for(int i = 0; i < z; i++) {
    fill(200,0,0);
    rect(a[i]*40, b[i]*40, 40, 40);
    if(x[0] == a[i]*40 && y[0] == b[i]*40) {
      comprimento += 1;
      
      a[i] = int(random(z));
      b[i] = int(random(z));
    }
  }
  
  j.mover();
  j.desenhar();
}

void keyPressed() {
  if(keyCode == UP && baixo == false) {
    cima = true;
    baixo = false;
    direita = false;
    esquerda = false;
  }
  if(keyCode == DOWN && cima == false) {
    baixo = true;
    cima = false;
    direita = false;
    esquerda = false;
  }
  if(keyCode == LEFT  && direita == false) {
    esquerda = true;
    direita = false;
    cima = false;
    baixo = false;
  }
  if(keyCode == RIGHT && esquerda == false) {
    direita = true;
    esquerda = false;
    cima = false;
    baixo = false;
  }
}
