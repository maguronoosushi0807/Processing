PImage img;
PImage buf;

void setup(){
  size(1280,720);
  
  img = loadImage("img.jpg");             // 画像読み出し
  buf = createImage(width, height, RGB);  // バッファ作成
  
  image(img, 0, 0);
}

void draw(){
  // 画像を表示

  // バッファを取得
  loadPixels();
  
  // 画像処理
  for(int y=0;y<height;y++){
    for(int x=0;x<width;x++){
      int i = x + y*width;
      color c = pixels[i];
      
      int x2 = constrain(x+(int)(green(c)-64)/32,0,width-1);
      int y2 = constrain(y+(int)(blue(c)-64)/32, 0, height-1);
      int i2 = x2 + y2*width;
      buf.pixels[i2] = c;
      
    }
  }
  
  // バッファを更新
  buf.updatePixels();
  
  // バッファを表示
  image(buf, 0, 0);
}
