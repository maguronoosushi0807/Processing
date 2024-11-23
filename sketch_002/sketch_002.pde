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
  
  for(int i=0;i<2200*height;i++){
    color c = mapOverlay.pixels[i];
    int r = int(red(c) - 128) / 10 + 128;
    int g = int(green(c) - 128) / 10 + 128;
    int b = 128;
    mapOverlay.pixels[i] = color(r,g,b);
  }
  
  // 初期化
  map.beginDraw();
  map.background(128);
  map.endDraw();
  
  image(pic, 0, 0, width, height);
  
  for(int i=0;i<NOISE_NUM;i++){
    noiseX[i] = (int)random(0,width);
    noiseY[i] = (int)random(0,height);
    
    int r = (int)random(110,150);
    int g = (int)random(110,150);
    
    noiseC[i] = color(r, g, 128);
  }
  
}

void draw(){
  time++;
  
  map.beginDraw();

  map.noStroke();
  /*
  for(int i=0;i<NOISE_NUM;i++){    
    noiseX[i] += noise(time/100+i)*4-2;
    noiseY[i] += noise(time/100+i)*4-2;
    
    if(noiseX[i]<0) noiseX[i] = width;
    if(noiseX[i]>width) noiseX[i] = 0;
    
    if(noiseY[i]<0) noiseY[i] = height;
    if(noiseY[i]>height) noiseY[i] = 0;
    
    map.fill(noiseC[i],40);
    map.circle(noiseX[i],noiseY[i],200);
  }
  */
  
  map.fill(128,17);
  map.rect(-100,-100,width,height);
  
  map.tint(255,100);
  // map.image(mapOverlay,0,0);
  
  applyGaussianBlur(map, 7);
  map.endDraw();
  
  // image(map, 0, 0, width, height);
  // image(map,0,0);
  
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
    map.strokeWeight(20);
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




void marvel(){
  map.beginDraw();
  map.loadPixels();
  loadPixels();
  for(int y=0;y<height;y++){
    for(int x=0;x<width;x++){
      int i = x+width*y;
      int j = x/2 + width/2 * y/2;
      // j = i/2;
      j = constrain(j, 0, width*height/4-1);
      
      color c = map.pixels[j];
      // 移動先を計算
      int moveX = x + x%2 - ((int)red(c)   - 128)/ 8;
      int moveY = y + y%2 - ((int)green(c) - 128)/ 8;
      
      moveX = constrain(moveX,0,width-1);
      moveY = constrain(moveY,0,height-1);
      
      int move = moveX + width * moveY;
      pixels[i] = pixels[move];
    }
  }
  // map.updatePixels();
  map.endDraw();
  updatePixels();
}






// 8近傍
void updatePixelsIfSurrounded(PGraphics graphics){
  graphics.beginDraw();
  graphics.loadPixels();  // PGraphicsのピクセルデータをロード
  
  PImage img = createImage(graphics.width, graphics.height, RGB);
  img.set(0, 0, graphics.get());  // PGraphicsの内容をPImageにコピー
  
  // ピクセルの変更をPImageに対して行う
  for (int y = 1; y < img.height - 1; y++) {  // 1行目と最終行を除く
    for (int x = 1; x < img.width - 1; x++) {  // 1列目と最終列を除く
      int i = x + y * img.width;  // 現在のピクセルのインデックス

      // 周囲8ピクセルのインデックスを取得
      int[] surroundingPixels = new int[8];
      surroundingPixels[0] = (x - 1) + (y - 1) * img.width;  // 左上
      surroundingPixels[1] = x + (y - 1) * img.width;        // 上
      surroundingPixels[2] = (x + 1) + (y - 1) * img.width;  // 右上
      surroundingPixels[3] = (x - 1) + y * img.width;        // 左
      surroundingPixels[4] = (x + 1) + y * img.width;        // 右
      surroundingPixels[5] = (x - 1) + (y + 1) * img.width;  // 左下
      surroundingPixels[6] = x + (y + 1) * img.width;        // 下
      surroundingPixels[7] = (x + 1) + (y + 1) * img.width;  // 右下

      boolean allSurroundingAreGray = true;

      // 周囲8つのピクセルが(128, 128, 128)かチェック
      for (int j = 0; j < 8; j++) {
        color surroundingColor = img.pixels[surroundingPixels[j]];
        if (red(surroundingColor) == 128 || green(surroundingColor) == 128 || blue(surroundingColor) == 128) {
          allSurroundingAreGray = false;
          break;  // 1つでも違う色があればループを抜ける
        }
      }

      // すべての周囲のピクセルが(128, 128, 128)なら現在のピクセルも(128, 128, 128)に設定
      if (allSurroundingAreGray) {
        img.pixels[i] = color(128, 128, 128);
      }
    }
  }

  img.updatePixels();  // 変更を反映
  graphics.beginDraw();
  graphics.image(img, 0, 0);  // 更新されたPImageをPGraphicsに描画
  graphics.endDraw();
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
