boolean introducao = true;
boolean direita, esquerda, ataque, defesa, dash, dodge;
boolean frente, atras, corrida, esquiva, espada, escudo;
int cooldownDash = 0, cooldownCorrida = 0, cooldownDodge = 0, cooldownEsquiva = 0;
int cooldownAtaque = 0, cooldownEspada = 0;
Quadrado[] q = new Quadrado[2];
String A = "No fim dos tempos, Gwyn terá a última luta\ncontra a humanidade.\nUse WASD CONTROL e TAB para Gwyn.\nUse CIMA BAIXO ESQUERDA DIREITA ENTER e DELETE\npara a humanidade.\nAperte SHIFT para continuar";

void setup() {
  size (1000,1000);
  frameRate(60);
  q[0] = new Quadrado(100,875,50,40);
  q[1] = new Quadrado(900,875,50,40);  
}

class Quadrado {
  boolean colidiu = false;
  boolean venceu = false;
  color Color;
  int l = 40;
  int cx, cy, c;
  int[] x = new int[4];
  int[] y = new int[4];
  
  Quadrado (int cx, int cy, int c, int l) {
    this.cx = cx;
    this.cy = cy;
    this.c = c;
    this.l = l;
    atualizar();
  }
  
  void vida() {
    if (l <= 40) fill(0,255,0);
    if (l < 30) fill(255,255,0);
    if (l < 20) fill (255,0,0);
    
    rect(cx-20,cy-40,l,10);
    
    if (l <= 0) l = 0;
  }
  
  void atualizar() {
    x[0] = cx - c/2;
    y[0] = cy - c/2;
    x[1] = cx + c/2;
    y[1] = cy - c/2;
    x[2] = cx + c/2;
    y[2] = cy + c/2;
    x[3] = cx - c/2;
    y[3] = cy + c/2;
  }
  
  void desenhar() {
    fill(Color);
    beginShape();
    for (int i = 0; i < 4; i++) {
      vertex(x[i], y[i]);
    }
    endShape(CLOSE);
  }
}

void keyPressed() {
  if (keyCode == SHIFT) introducao = false;
  if (keyCode == BACKSPACE && ataque == false && defesa == false) dash = true;
  if (keyCode == ENTER && ataque == false && defesa == false) dodge = true;
  if (keyCode == RIGHT && ataque == false && defesa == false) direita = true;
  if (keyCode == LEFT && ataque == false && defesa == false) esquerda = true;
  if (keyCode == UP && defesa == false
  && dash == false && dodge == false) ataque = true;
  if (keyCode == DOWN && ataque == false
  && dash == false && dodge == false) defesa = true;

  if (keyCode == TAB && espada == false && escudo == false) corrida = true;
  if (keyCode == CONTROL && espada == false && escudo == false) esquiva = true;
  if (key == 'd' && espada == false && escudo == false) atras = true;
  if (key == 'a' && espada == false && escudo == false) frente = true;
  if (key == 'w' && escudo == false
  && corrida == false && esquiva == false) espada = true;
  if (key == 's' && espada == false
  && corrida == false && esquiva == false) escudo = true;  
}

void keyReleased() {
  if (keyCode == BACKSPACE) dash = false;
  if (keyCode == ENTER) dodge = false;
  if (keyCode == RIGHT) direita = false;
  if (keyCode == LEFT) esquerda = false;
  if (keyCode == UP) ataque = false;
  if (keyCode == DOWN) defesa = false;  

  if (keyCode == TAB) corrida = false;
  if (keyCode == CONTROL) esquiva = false;
  if (key == 'd') atras = false;
  if (key == 'a') frente = false;
  if (key == 'w') espada = false;
  if (key == 's') escudo = false;  
}

void draw() {
  PFont fonte;
  fonte = loadFont("Skia-Regular-32.vlw");
  textFont(fonte);
  if (introducao == true) {
    background(30);
    text(A,50,100);
  }
  
  if (introducao == false) {
  background(160);
  fill(200,150,50);
  triangle(480,280,520,280,500,350);
  fill(250,250,100);
  circle(500,200,220);
  fill(20);
  circle(500,200,200);
  fill(50);
  rect(0,900,1000,100);
  
  strokeWeight(3);
  
  if (q[0].l <= 0) {
    q[0].venceu = false;    
    q[1].venceu = true;
    textSize(32);
    fill(255);
    text("HUMANIDADE GANHOU", 400, 500);
    return;
  }
  if (q[1].l <= 0) {
    q[0].venceu = true;
    q[1].venceu = false;
    textSize(32);
    fill(255);
    text("GWYN GANHOU", 350, 500);
    return;
  }
  
  int novaPos0 = q[0].cx + 50;
  
  if (q[0].cx + 25 >= q[1].cx - 25 ||
      escudo == true && q[0].cx+25 == q[1].cx-55) {
    q[0].colidiu = true;
  } else {
    q[0].colidiu = false;
    }
    
  if (direita && q[0].colidiu == false) q[0].cx++;
  
  if (dash && cooldownDash >= 120 && abs(novaPos0 - q[1].cx) > 50 && q[0].colidiu == false) {
    cooldownDash = 0;
    q[0].cx +=50;
  }
  
  if (esquerda) q[0].cx--;
  
  if (dodge && cooldownDodge >= 60) {
    cooldownDodge = 0;
    q[0].cx -=25;
  }
  
  if (q[0].cx <= 25) q[0].cx = 25;
  
  if (ataque && cooldownAtaque >= 60) {
    if (q[0].cx+50 >= q[1].cx-55 && escudo == true) {
      ataque = false;
    } else {
      cooldownAtaque = 0;
      line(q[0].cx, q[0].cy, q[0].cx+50, q[0].cy);
      if (q[0].cx+50 > q[1].cx-25) {
        q[1].l = (q[1].l-(int(random(1,9))));
      }
    }
  }
  
  if (defesa && q[0].cx+55 <= q[1].cx-25) {
    line(q[0].cx+55, q[0].cy+25, q[0].cx+55, q[0].cy-30);  
  } else {
    defesa = false;
    }
    
  q[0].Color = color(250,250,160);
  q[0].vida();
  q[0].atualizar();
  q[0].desenhar();  
  
  int novaPos1 = q[1].cx - 50;
  
  if (q[1].cx-25 <= q[0].cx+25 ||
      defesa == true && q[1].cx-25 == q[0].cx+55) {
    q[1].colidiu = true;
  } else {
    q[1].colidiu = false;
    }
  
  cooldownDash++;
  cooldownDodge++;
  cooldownAtaque++;
  cooldownCorrida++;
  cooldownEsquiva++;
  cooldownEspada++;  
  
  if (frente && q[1].colidiu == false) q[1].cx--; 
  
  if (corrida && cooldownCorrida >= 120 && abs(novaPos1 - q[0].cx) > 50 && q[0].colidiu == false) {
    cooldownCorrida = 0;
    q[1].cx -=50;
  }  
  
  if (atras) q[1].cx++;
  
  if (esquiva && cooldownEsquiva >= 60) {
    cooldownEsquiva = 0;
    q[1].cx +=25;
  }  
  
  if (q[1].cx >= 975) q[1].cx = 975;
  
  if (espada && cooldownEspada >= 60) {
    if (q[1].cx-50 <= q[0].cx+55 && defesa == true) {
      espada = false;
    } else {
      cooldownEspada = 0;
      line(q[1].cx, q[1].cy, q[1].cx-50, q[1].cy);
      if (q[1].cx-50 < q[0].cx+25) {
        q[0].l = (q[0].l-(int(random(1,9))));
      }
    }
  }  
  
  if (escudo && q[1].cx-55 >= q[0].cx+25) {
    line(q[1].cx-55, q[1].cy+25, q[1].cx-55, q[1].cy-30);
  } else {
    escudo = false;
    }  
  
  q[1].Color = color(70,10,70);
  q[1].vida();
  q[1].atualizar();
  q[1].desenhar();  
  }
}  
