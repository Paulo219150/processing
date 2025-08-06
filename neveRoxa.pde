float[] posX = new float [100];
float[] posY = new float [100];
float[] velX = new float [100];
float[] velY = new float [100];

void setup() {
  size(1000,1000);
  frameRate(60); 
  for (int i = 0; i < 100; i++) {
    posX[i] = random(990);
    posY[i] = random(990);
    velX[i] = (random (-100,100))/100;
    velY[i] = (random (-100,100))/100;
  }
}

void draw() {
  background(255);
  for (int i=0; i < 100; i++) {
    posX[i] += velX[i];
    posY[i] += velY[i];
    
    fill(120,60,120);
    ellipse((posX[i]+velX[i]),(posY[i]+velY[i]),10,10);
    if (posX[i]+5>= 1000 || posX[i]-5 <= 0) {
      velX[i] *= -1;
    }
    if (posY[i]+5 >= 1000 || posY[i] - 5 <= 0) {
      velY[i] *= -1;
    }
    if (posX[i]+5 >= (mouseX-40) && posX[i]-5 <= (mouseX+40) && 
    posY[i]+5 >= (mouseY-40) && posY[i]-5 <= (mouseY+40)) {
      velX[i] *= -1;
      velY[i] *= -1;
    }
  }
}
