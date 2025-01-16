int SIZE = 128;

int posX[] = new int[SIZE];
int posY[] = new int[SIZE];
int bright[] = new int[SIZE];

void setup(){
  size(1000, 800);
  frameRate(60);
  
  
  int min = 0;
  int max = 255;
  
  float val = 0;
  for(int i=0;i<SIZE;i++){
    bright[i] = int(noise(val) * (max-min)) + min;
    val += 0.6;
  }
  
  
  allocate(width/2, height/2);
}




void draw(){
  background(0);
  
  strokeWeight(24);
  for(int i=0;i<SIZE-1;i++){
    stroke(bright[i]);
    line(posX[i], posY[i], posX[i+1], posY[i+1]);
    
    posX[i] += (int)random(-2, 2);
    posY[i] += (int)random(-2, 2);
  }
  
  if(frameCount%2 == 0){
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
    int rangeX = (int)random(0,400);
    int rangeY = (int)random(0,200);
    int x = (int)random(0, rangeX);
    int y = (int)random(0, rangeY);
    
    
    // 進行方向を決定
    if(posX[i-1] + x > width){
      dirX = 1;
    }else if(posX[i-1] - x < 0){
      dirX = 0;
    }
    
    if(posY[i-1] + y > height){
      dirY = 1;
    }else if(posY[i-1] - y < 0){
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
