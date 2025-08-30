int[] x = new int[100];
int[] y = new int[100];
boolean[][] vivo = new boolean[x.length][y.length];
boolean[][] verificarVivos = new boolean[x.length][y.length];

void setup() {
  size(1000, 1000);
  frameRate(1);
  colorMode(HSB, 360, 100, 100);
  tabuleiroInicial();
}

void draw() {
  tabuleiroFuturo();
  tabuleiroAtual();
}

void tabuleiroInicial() {
  for(int i = 1; i < x.length -1; i++) {
    x[i] = i*10;
    for(int j = 1; j < y.length -1; j++) {
      y[j] = j*10;
      float vida;
      vida = random(1);
      if(vida <= 0.9) {
        vivo[i][j] = false;
        fill(0, 0, 20);
      } else {
        vivo[i][j] = true;
        fill(0, 0, 100);
        }
      rect(x[i], y[j], 10, 10);
    }
  }
}

void tabuleiroAtual() {
  for(int i = 1; i < x.length-1; i++) {
    for(int j = 1; j < y.length-1; j++) {
      if(vivo[i][j] == true) {
        fill(0, 0, 100);
        rect(x[i], y[j], 10, 10);
      } else {
        fill(0, 0, 20);
        rect(x[i], y[j], 10, 10);
        }
      vivo[i][j] = verificarVivos[i][j];
    }
  }
}

void tabuleiroFuturo() {
  int[][] populacao = new int[x.length][y.length];
  for(int i = 1; i < x.length-1; i++) {
    for(int j = 1; j < y.length-1; j++) {
      if(vivo[i-1][j]) populacao[i][j] += 1;
      if(vivo[i+1][j]) populacao[i][j] += 1;
      if(vivo[i][j-1]) populacao[i][j] += 1;
      if(vivo[i][j+1]) populacao[i][j] += 1;
      
      if(populacao[i][j] == 2 || populacao[i][j] == 3) {
        verificarVivos[i][j] = true;
      } else {
        verificarVivos[i][j] = false;
        }
    }
  }
}
