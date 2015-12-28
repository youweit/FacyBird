class CalibrateState {
  private Capture video;
  private OpenCV opencv;
  
  private int videoX;
  private int videoY;
  
  private int VIDEO_SCALE = 2;
  private int startPoint = 0;
  private int stopPoint = 0;
  
  private PApplet mInstance; 
  
  private ArrayList<Integer> dy;
  private int average = 0;
  private boolean isCalibrate = false;

  
  
  CalibrateState(PApplet instance) {
    mInstance = instance;
    
    video = new Capture(mInstance, camera_width, camera_height);
    opencv = new OpenCV(mInstance, camera_width, camera_height);
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
    dy = new ArrayList<Integer>();
    videoX = (width - camera_width * VIDEO_SCALE)/4;
    videoY = (height - camera_height * VIDEO_SCALE)/4;
    print(videoX);
    background(0);
    video.start();
  }


  void draw() {
    clear();
    scale(VIDEO_SCALE);
    opencv.loadImage(video);

    image(video, videoX, videoY);

    noFill();
    stroke(0, 255, 0);
    strokeWeight(3);
    Rectangle[] faces = opencv.detect();
    //println(faces.length);

    for (int i = 0; i < faces.length; i++) {
      if (dy.size() <= 5) {
        dy.add(faces[i].y);
      } else {
        dy.remove(0);
        dy.add(faces[i].y);
      }

      for (Integer a : dy) {
        average = average + a;
      }
      average /= dy.size();
      rect(faces[i].x+videoX, faces[i].y+videoY, faces[i].width, faces[i].height);
    }


    pushStyle();
    
    rectMode(CORNER);
    textAlign(CENTER);
    fill(255);
    textSize(18);
    if (startPoint == 0)
      text("Calibrating, please stare straight and click mouse.", 10, 10, width/2, 40);
    else if (stopPoint  == 0)
      text("Calibrating, Heads up and click mouse.", 10, 10, width/2, 40);
    popStyle();
  }


  void mouseClicked() {
    print("startPoint = ", startPoint);
    if (startPoint == 0) {
      if (average != 0)
        startPoint = average;
    } else if (stopPoint  == 0) {
      if (average != 0) {
        stopPoint = average;
        isCalibrate = true;
      }
    }
  };

  boolean isCalibrate() {
    return isCalibrate;
  }

  int getStartPoint() {
    return startPoint;
  }

  int getStopPoint() {
    return stopPoint;
  }
}

