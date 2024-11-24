#pragma once

#include "ofxOpenCv.h"

#include "ofMain.h"

#define WIDTH  (1280)
#define HEIGHT (720)

#define DISPLACE_X 0
#define DISPLACE_Y 1

class ofApp : public ofBaseApp{
	private:
		ofFbo map;
		ofxCvColorImage openCvMap;

		ofFbo fbo;
		ofPixels pixels;
		ofTexture texture;

		int prevX = 0;
		int prevY = 0;

		uint32_t time = 0;
		ofImage defaultImage;

	public:
		void setup();
		void update();
		void draw();

		void keyPressed(int key);
		void keyReleased(int key);
		void mouseMoved(int x, int y );
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased(int x, int y, int button);
		void mouseEntered(int x, int y);
		void mouseExited(int x, int y);
		void windowResized(int w, int h);
		void dragEvent(ofDragInfo dragInfo);
		void gotMessage(ofMessage msg);
};
