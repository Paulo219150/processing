int x0 = 250, y0 = 250, d = 50, xf = 750, yf = 750;
int clique = 0, a;
int[] tipoLinha = new int[4];
int[] x = new int[8];
int[] y = new int[8];

// esse int[] estava me dando dor de cabeça pq nao sabia que precisava de [], perguntei pro gpt
void coordenadas (int[] tipoLinha) {
  for(int i = 0; i < 4; i++) {
    if(x[i+4] <= 250 || x[i] <= 250) {
      x[i] = x0+d;
      x[i+4] = x0+d;
    }
    if(x[i+4] >= 750 || x[i] >= 750) {
      x[i] = xf-d;
      x[i+4] = xf-d;
    }
    if(y[i+4] <= 250 || y[i] <= 250) {
      y[i] = y0+d;
      y[i+4] = y0+d;
    }
    if(y[i+4] >= 750 || y[i] >= 750) {
      y[i] = yf-d;
      y[i+4] = yf-d;
    }
    
    if(tipoLinha[i] == 0) {
      x[i]=x[i+4];
      y[i] = y[i+4];
      x[i+4] = x[i];
      y[i+4] = y[i]-d;
    }
    if(tipoLinha[i] == 1) {
      x[i]=x[i+4];
      y[i] = y[i+4];
      x[i+4] = x[i];
      y[i+4] = y[i]+d;
    }
    if(tipoLinha[i] == 2) {
      x[i]=x[i+4];
      y[i] = y[i+4];
      x[i+4] = x[i]+d;
      y[i+4] = y[i]+d;
    }
    if(tipoLinha[i] == 3) {
      x[i]=x[i+4];
      y[i] = y[i+4];
      x[i+4] = x[i]-d;
      y[i+4] = y[i]-d;
    }
    if(tipoLinha[i] == 4) {
      x[i]=x[i+4];
      y[i] = y[i+4];
      x[i+4] = x[i]-d;
      y[i+4] = y[i]+d;
    }
    if(tipoLinha[i] == 5) {
      x[i]=x[i+4];
      y[i] = y[i+4];
      x[i+4] = x[i]+d;
      y[i+4] = y[i]-d;
    }
    if(tipoLinha[i] == 6) {
      x[i]=x[i+4];
      y[i] = y[i+4];
      x[i+4] = x[i]-d;
      y[i+4] = y[i];
    }
    if(tipoLinha[i] == 7) {
      x[i]=x[i+4];
      y[i] = y[i+4];
      x[i+4] = x[i]+d;
      y[i+4] = y[i];
    }
    
    line(x[i], y[i], x[i+4], y[i+4]);
  }
}


void setup() {
  size(1000,1000);
  frameRate(60);
  colorMode(HSB,360,100,100);
}

void draw() {
  fill(220,33,100);
  strokeWeight(3);
}

void mouseClicked() {
  clique = clique + 1;
  println(clique);
  
  x[0]=x[1]=x[2]=x[3]=500;
  y[0]=y[1]=y[2]=y[3]=500;
  
  if(clique == 1) {
    rect(250,250,500,500);
    line(x[0], y[0], x[4]= x[0], y[4]= y[0]-d);
    line(x[2], y[2], x[6]= x[2], y[6]= y[2]+d);
    line(x[1], y[1], x[5]= x[1]+d, y[5]= y[1]);
    line(x[3], y[3], x[7]= x[3]-d, y[7]= y[3]);
  }
  
  if(clique > 1) {
    for (int i = 0; i < 4; i++) {
      tipoLinha[i] = int(random(8));
    }
    coordenadas(tipoLinha);
  }
}
