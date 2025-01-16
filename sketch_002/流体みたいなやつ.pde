PImage pic;
PImage frame;
PGraphics map;

int prevX = 0;
int prevY = 0;

void setup(){
  size(1280, 720);
  frameRate(60);
  
  pic = loadImage("img.png");
  frame = createImage(width, height, RGB);
  map   = createGraphics(width/2, height/2);
  
  // image(pic, 0, 0, width, height);
}

void draw(){
  map.beginDraw();
  // map.filter(BLUR,10);
  applyBoxBlur(map, 10);
  map.endDraw();
  
  tint(255, 64);
  image(map, 0, 0, width, height);
  
  prevX = mouseX;
  prevY = mouseY;
  
  marvel();
}

void mouseDragged(){
  map.beginDraw();
  map.stroke(255, 0, 0);
  map.strokeWeight(20);
  map.line(prevX/2, prevY/2, mouseX/2, mouseY/2);
  map.endDraw();
  
  map.beginDraw();
  // map.filter(BLUR, 10);
  map.endDraw();

  
  prevX = mouseX;
  prevY = mouseY;
}

void marvel(){
  map.beginDraw();
  map.loadPixels();
  loadPixels();
  for(int y=0;y<height;y++){
    for(int x=0;x<width;x++){
      int i = x+width*y;
      // int j = x/2 + width*y/2;
      int j = constrain(i/4, 0, width*height/4);
      
      // 移動先を計算
      color c = map.pixels[j];
      int moveX = x + x%2 + (int)red(c);
      int moveY = y + y%2 + (int)green(c);
      
      
      moveX = constrain(moveX,0,width-1);
      moveY = constrain(moveY,0,height-1);
      
      int move = moveX + width * moveY;
      pixels[i] = pixels[move];
    }
  }
  map.endDraw();
  updatePixels();
}



void applyBoxBlur(PGraphics img, int radius) {
  img.loadPixels();
  color[] original = img.pixels.clone(); // 元のピクセルを保持
  
  int w = img.width;
  int h = img.height;
  
  // 水平方向のブラー
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      float r = 0, g = 0, b = 0;
      int count = 0;
      
      for (int dx = -radius; dx <= radius; dx++) {
        int nx = constrain(x + dx, 0, w - 1);
        color col = original[nx + y * w];
        r += red(col);
        g += green(col);
        b += blue(col);
        count++;
      }
      img.pixels[x + y * w] = color(r / count, g / count, b / count);
    }
  }
  
  img.updatePixels();
  img.loadPixels();
  original = img.pixels.clone(); // 水平方向後の結果を保持
  
  // 垂直方向のブラー
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      float r = 0, g = 0, b = 0;
      int count = 0;
      
      for (int dy = -radius; dy <= radius; dy++) {
        int ny = constrain(y + dy, 0, h - 1);
        color col = original[x + ny * w];
        r += red(col);
        g += green(col);
        b += blue(col);
        count++;
      }
      img.pixels[x + y * w] = color(r / count, g / count, b / count);
    }
  }
  
  img.updatePixels();
}
