int SIZE = 150*3 +1;

int posX[] = new int[SIZE];
int posY[] = new int[SIZE];
int bright[] = new int[SIZE];

PImage img;

void setup(){
  size(1280, 720);
  frameRate(60);
  
  img = loadImage("img.jpg");
  
  int min = 0;
  int max = 255;
  
  float val = 0;
  for(int i=0;i<SIZE;i++){
    bright[i] = int(noise(val) * (max-min)) + min;
    val += 0.4;
  }
  
  
  allocate(width/2, height/2);
}




void draw(){
  background(0);
  // image(img, 0, 0, width, height);
  
  noFill();
  strokeWeight(24);
  
  for(int i=0;i<SIZE-3;i++){
    color c = img.get(posX[i], posY[i]);
    
    stroke(bright[i]);
    stroke(c);
    bezier(posX[i], posY[i], posX[i+1], posY[i+1], posX[i+2], posY[i+2], posX[i+3], posY[i+3]);
    
    int range = 10;
    posX[i] += (int)random(-range, range);
    posY[i] += (int)random(-range, range);
  }
  
  
  if(frameCount%1 == 0){
    swap();
  }
  
}




void allocate(int _x, int _y){
  
  posX[0] = _x;
  posY[0] = _y;
  
  int dirX = 0;
  int dirY = 0;
  
  // reset pos
  for(int i=1;i<SIZE;i++){
    int rangeX = (int)random(0,300);
    int rangeY = (int)random(0,300);
    int x = (int)random(0, rangeX);
    int y = (int)random(0, rangeY);
    
    
    // 進行方向を決定
    if(posX[i-1] + x > width+100){
      dirX = 1;
    }else if(posX[i-1] - x < -100){
      dirX = 0;
    }
    
    if(posY[i-1] + y > height+100){
      dirY = 1;
    }else if(posY[i-1] - y < -100){
      dirY = 0;
    }
    
    
    // 反映
    if(dirX == 0) posX[i] = posX[i-1] + x;
    else          posX[i] = posX[i-1] - x;
    
    if(dirY == 0) posY[i] = posY[i-1] + y;
    else          posY[i] = posY[i-1] - y;
    
  }
  
  return;
}




void swap(){
  /*
  int buf = bright[SIZE-1];
  for(int i=SIZE-1; i>1; i--){
    bright[i] = bright[i-1];
  }
  bright[0] = buf;
  */
  
  
  int buf = bright[0];
  for(int i=0; i< SIZE-1; i++){
    bright[i] = bright[i+1];
  }
  bright[SIZE-1] = buf;
  
  return;
}
