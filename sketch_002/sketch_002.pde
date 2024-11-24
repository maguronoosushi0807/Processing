PImage pic;
PImage frame;
PImage mapOverlay;
PGraphics map;

int prevX = 0;
int prevY = 0;

int time = 0;
int NOISE_NUM = 100;
int[] noiseX = new int[NOISE_NUM];
int[] noiseY = new int[NOISE_NUM];
color[] noiseC = new color[NOISE_NUM];

void setup(){
  size(1280, 720);
  frameRate(120);
  
  pic = loadImage("img4.jpg");
  frame = createImage(width, height, RGB);
  map   = createGraphics(width/2, height/2);
  mapOverlay = loadImage("map.jpg");
  
  // 初期化
  map.beginDraw();
  map.background(128);
  map.endDraw();
  
  image(pic, 0, 0, width, height);
}

void draw(){
  time++;
  
  map.beginDraw();

  map.noStroke();
  
  /*
  if(time%2==0){
    map.fill(128,64);
    map.rect(-100,-100,width,height);
  }
  */
  
  map.tint(255,100);
  
  applyFastBoxBlur(map, 7);
  map.endDraw();
  
  image(map,0,0);
  
  prevX = mouseX;
  prevY = mouseY;
  
  marvel();
}

void mouseDragged(){
  if(mouseButton==RIGHT){
    map.beginDraw();
    
    map.noStroke();
    
    int diffX = (mouseX-prevX)*8;
    int diffY = (mouseY-prevY)*8;
    map.stroke(128+diffX, 128+diffY, 0);
    map.strokeWeight(40);
    map.line(prevX/2, prevY/2, mouseX/2, mouseY/2);
    
    map.endDraw();
    
    map.beginDraw();
    // map.filter(BLUR, 10);
    map.endDraw();
  
    
    prevX = mouseX;
    prevY = mouseY;
  }
  
  // 疑似ノイズ
  for(int i=0;i<NOISE_NUM;i++){
  }

}


void keyPressed(){
  image(pic,0,0,width,height);
  map.beginDraw();
  map.background(128);
  map.endDraw();
}




void marvel(){
  map.beginDraw();
  map.loadPixels();
  loadPixels();
  for(int y=0;y<height;y++){
    for(int x=0;x<width;x++){
      int i = x+width*y;
      int j = x/2 + width/2 * y/2;
      j = constrain(j, 0, width*height/4-1);
      
      color c = map.pixels[j];
      // 移動先を計算
      int moveX = x + x%2 - ((int)red(c)   - 128);
      int moveY = y + y%2 - ((int)green(c) - 128);
      
      moveX = constrain(moveX,0,width-1);
      moveY = constrain(moveY,0,height-1);
      
      int move = moveX + width * moveY;
      pixels[i] = pixels[move];
    }
  }
  map.endDraw();
  updatePixels();
}






void applyFastBoxBlurAndFade(PGraphics pg, int radius, int steps) {
  if (radius < 1 || steps < 1) return; // 半径やステップ数が無効なら何もしない

  pg.beginDraw();
  pg.loadPixels();
  color[] original = pg.pixels.clone();

  int w = pg.width;
  int h = pg.height;

  // 一時的な配列を用意（中間データ用）
  color[] temp = new color[w * h];

  // 水平方向のブラー
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      float r = 0, g = 0, b = 0;
      int count = 0;

      for (int dx = -radius; dx <= radius; dx++) {
        int nx = x + dx;
        if (nx >= 0 && nx < w) { // 範囲チェック
          color col = original[nx + y * w];
          r += red(col);
          g += green(col);
          b += blue(col);
          count++;
        }
      }

      temp[x + y * w] = color(r / count, g / count, b / count);
    }
  }

  // 垂直方向のブラー
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      float r = 0, g = 0, b = 0;
      int count = 0;

      for (int dy = -radius; dy <= radius; dy++) {
        int ny = y + dy;
        if (ny >= 0 && ny < h) { // 範囲チェック
          color col = temp[x + ny * w];
          r += red(col);
          g += green(col);
          b += blue(col);
          count++;
        }
      }

      // 現在のピクセルの色を計算
      color blurredColor = color(r / count, g / count, b / count);
      color currentColor = pg.pixels[x + y * w];

      // RGB値を128に近づける
      float fadeR = lerp(red(currentColor), 128, 1.0 / steps);
      float fadeG = lerp(green(currentColor), 128, 1.0 / steps);
      float fadeB = lerp(blue(currentColor), 128, 1.0 / steps);

      // 新しいピクセルの色を設定
      pg.pixels[x + y * w] = color(fadeR, fadeG, fadeB);
    }
  }

  pg.updatePixels();
  pg.endDraw();
}





void applyGaussianBlur(PGraphics img, int radius) {
  img.loadPixels();
  
  int w = img.width;
  int h = img.height;

  // ガウシアンカーネルの計算
  float[] kernel = new float[radius * 2 + 1];
  float sigma = radius / 3.0; // 標準偏差 (σ)を半径に基づいて計算
  float sum = 0.0;
  
  for (int i = 0; i < kernel.length; i++) {
    int x = i - radius;
    kernel[i] = exp(-0.5 * (x * x) / (sigma * sigma)) / (sqrt(2 * PI) * sigma);
    sum += kernel[i];
  }

  // カーネルを正規化
  for (int i = 0; i < kernel.length; i++) {
    kernel[i] /= sum;
  }

  // 水平方向にブラー
  color[] horizontalBlurred = new color[img.pixels.length];
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      float r = 0, g = 0, b = 0;
      for (int dx = -radius; dx <= radius; dx++) {
        int nx = constrain(x + dx, 0, w - 1); // 範囲内に制限
        color c = img.pixels[nx + y * w];
        r += red(c) * kernel[dx + radius];
        g += green(c) * kernel[dx + radius];
        b += blue(c) * kernel[dx + radius];
      }
      horizontalBlurred[x + y * w] = color(r, g, b);
    }
  }

  // 垂直方向にブラー
  color[] finalBlurred = new color[img.pixels.length];
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      float r = 0, g = 0, b = 0;
      for (int dy = -radius; dy <= radius; dy++) {
        int ny = constrain(y + dy, 0, h - 1); // 範囲内に制限
        color c = horizontalBlurred[x + ny * w];
        r += red(c) * kernel[dy + radius];
        g += green(c) * kernel[dy + radius];
        b += blue(c) * kernel[dy + radius];
      }
      finalBlurred[x + y * w] = color(r, g, b);
    }
  }

  // 最終的なブラー結果を画像に適用
  img.pixels = finalBlurred;
  img.updatePixels();
}







// ボックスブラー関数
void applyFastBoxBlur(PGraphics pg, int radius) {
  if (radius < 1) return; // 半径が0以下なら何もしない

  pg.beginDraw();
  pg.loadPixels();
  color[] original = pg.pixels.clone();
  
  int w = pg.width;
  int h = pg.height;

  // 一時的な配列を用意（処理の中間データ用）
  color[] temp = new color[w * h];

  // 水平方向のブラー
  for (int y = 0; y < h; y++) {
    for (int x = 0; x < w; x++) {
      float r = 0, g = 0, b = 0;
      int count = 0;

      for (int dx = -radius; dx <= radius; dx++) {
        int nx = x + dx;
        if (nx >= 0 && nx < w) { // 範囲チェック
          color col = original[nx + y * w];
          r += red(col);
          g += green(col);
          b += blue(col);
          count++;
        }
      }

      temp[x + y * w] = color(r / count, g / count, b / count);
    }
  }

  // 垂直方向のブラー
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      float r = 0, g = 0, b = 0;
      int count = 0;

      for (int dy = -radius; dy <= radius; dy++) {
        int ny = y + dy;
        if (ny >= 0 && ny < h) { // 範囲チェック
          color col = temp[x + ny * w];
          r += red(col);
          g += green(col);
          b += blue(col);
          count++;
        }
      }

      pg.pixels[x + y * w] = color(r / count, g / count, b / count);
    }
  }

  pg.updatePixels();
  pg.endDraw();
}
