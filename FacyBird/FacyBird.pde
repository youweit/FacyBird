import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

int width = 1000;
int height = 683;

int camera_width = 320;
int camera_height = 240;
boolean bGameStarted = true;
boolean bGameOver = false;

MainState mainState;
CalibrateState calibrateState;

void setup() {

  size(width, height);
  mainState = new MainState(this);
  calibrateState = new CalibrateState(this);
  mousePressed();
}

void draw() {
  if(calibrateState.isCalibrate()){
    if(!mainState.isStart())
      mainState.setCalibrate(calibrateState.getStartPoint(), calibrateState.getStopPoint());
     mainState.draw();
  }else{
    calibrateState.draw();
  }
  
}

//opencv capture event
void captureEvent(Capture c) {
  c.read();
}

void mouseClicked() {
  
  calibrateState.mouseClicked();
  if(mainState.isGameOver()){
    mainState = new MainState(this);
  }
}

