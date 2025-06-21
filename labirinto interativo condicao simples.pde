boolean reset, cima, baixo, esquerda, direita, matrizValida = false;
int n = 25;
int p = 0;
int[] x = new int[n];
int[] y = new int[n];
int n1, n2;
int[][] matriz = new int[n][n];

void setup() {
  size(1000, 1000);
  frameRate(60);
  
  for (int i = 0; i < n; i++) {
    x[i] = i;
    y[i] = i;
  }

  do {
    n1 = int(random(n));
    n2 = int(random(n));
    matriz = criarMatriz(n);
  } while (matriz[n1][n2] != 1);
}

int[][] criarMatriz(int n) {
  do {
    matrizValida = false;
    p = 0;

    matriz = new int[n][n];

    for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
        matriz[i][j] = int(random(2));
      }
    }

    for (int s = n2 - 1; s >= 0; s--) {
      p += matriz[n1][s];
    }

    if (p >= n2) {
      matrizValida = true;
    }

  } while (!matrizValida);

  return matriz;
}

void draw() {
  background(0);
  println(n1, n2);

  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      if (matriz[i][j] == 1) fill(255);
      else fill(0);
      rect(i * 40, j * 40, 40, 40);
    }
  }

  if (n2 > 0 && cima && matriz[n1][n2 - 1] == 1) n2 -= 1;
  if (n2 < n - 1 && baixo && matriz[n1][n2 + 1] == 1) n2 += 1;
  if (n1 > 0 && esquerda && matriz[n1 - 1][n2] == 1) n1 -= 1;
  if (n1 < n - 1 && direita && matriz[n1 + 1][n2] == 1) n1 += 1;

  fill(255, 255, 0);
  rect(n1 * 40, n2 * 40, 40, 40);
}

void keyPressed() {
  if (keyCode == UP) cima = true;
  if (keyCode == DOWN) baixo = true;
  if (keyCode == LEFT) esquerda = true;
  if (keyCode == RIGHT) direita = true;
}

void keyReleased() {
  if (keyCode == UP) cima = false;
  if (keyCode == DOWN) baixo = false;
  if (keyCode == LEFT) esquerda = false;
  if (keyCode == RIGHT) direita = false;
}
