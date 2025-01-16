#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
	ofSetWindowShape(WIDTH, HEIGHT);
	ofSetFrameRate(60);

	ofSetBackgroundAuto(false);

	defaultImage.loadImage("default.png");

	// フレームバッファ
	fbo.allocate(WIDTH, HEIGHT, GL_RGBA);
	fbo.begin();
	defaultImage.draw(0, 0, WIDTH, HEIGHT);
	fbo.end();

	// ofPixels表示用
	texture.allocate(WIDTH, HEIGHT, GL_RGBA);

	// マップ
	map.allocate(WIDTH, HEIGHT, GL_RGB);
	map.begin();
	ofBackground(128);
	map.end();

	openCvMap.allocate(WIDTH, HEIGHT);


	printf("begin\n");
}

//--------------------------------------------------------------
void ofApp::update(){
	time++;

	prevX = ofGetMouseX();
	prevY = ofGetMouseY();


	// フェード・ブラー
	map.begin();

	fbo.readToPixels(pixels);
	openCvMap.setFromPixels(pixels);
	openCvMap.blur(30);
	openCvMap.draw(0, 0);

	ofSetColor(128, 32);
	if (time % 30 == 0) {
		ofSetColor(128, 128);
	}

	ofRect(0, 0, WIDTH, HEIGHT);
	map.end();


	// マーブリング
	fbo.readToPixels(pixels);
	int numChannnels = pixels.getNumChannels();
	
	for (int y = 0; y < pixels.getHeight(); y++) {
		for (int x = 0; x < pixels.getWidth(); x++) {
			int i = (x + y * WIDTH) * numChannnels;

			uint8_t r = pixels[i];
			uint8_t g = pixels[i+1];
			uint8_t b = pixels[i+2];


			pixels[i] = r;
			pixels[i+1] = g;
			pixels[i+2] = b;
		}
	}

	texture.loadData(pixels);
}

//--------------------------------------------------------------
void ofApp::draw(){
	// fbo.draw(0,0,WIDTH,HEIGHT);
	// texture.draw(0, 0);
	map.draw(0,0);
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){

}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){
	printf("dragged\n");

	// マップを更新
	map.begin();
	ofNoFill();
	ofSetLineWidth(40);
	ofSetColor(abs(x - prevX), abs(y - prevY), 128);
	ofDrawLine(prevX, prevY, x, y);
	map.end();

	prevX = x;
	prevY = y;
}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}