class Wall {
  private HitListener mListener;
  private float initX;
  private float topX;
  private float topY;
  private float w = 50;
  private float velocity;
  private boolean passed = false;
  private float gapSize = 100;
  public boolean startMoving = false;
  public int movingFactor = 1;
  PImage imgPipeUp;
  PImage imgPipeDown;

  Wall(float initialTopX, float initialTopY) {
    initX = initialTopX;
    topX = initialTopX;
    topY = initialTopY;
    velocity = random(-1 * movingFactor, 1 * movingFactor);
    imgPipeUp = loadImage("pipeUp.png");
    imgPipeDown = loadImage("pipeDown.png");
  }

  void setListener(HitListener listener) {
    this.mListener = listener;
  }

  void draw() {
    pushStyle();
    rectMode(CORNERS);
    fill(#000000);

    //print(height);


//    rect(topX, topY, topX+w, height-1);
//    rect(topX, 0, topX+w, topY - 100);
    if (startMoving) {
      if (topY + velocity > height || topY + velocity < 100 + gapSize) {
        velocity *= -1;
      }
      topY += velocity;
    }
    image(imgPipeUp, topX, topY, w, imgPipeUp.height);
    image(imgPipeDown, topX, -imgPipeDown.height + topY - gapSize, w, imgPipeDown.height);
    
    popStyle();

    topX -= 3;

    if (topX < -w) {
      reset();
    }
  }

  void hitTest(Bird b) {
    //this is the bird size
    int alphaGapSizeX = 14;
    int alphaGapSizeY = 8;
    if (rectsCollide(b.x, b.y, b.size - alphaGapSizeX, b.size - alphaGapSizeY, topX, topY, topX+w, height-1) ||
      rectsCollide(b.x, b.y, b.size - alphaGapSizeX, b.size - alphaGapSizeY, topX, 0, topX+w, topY - 100)) {
      mListener.onHitWall();
    } else {
      //not hit.
      if (b.x > (topX + w) && !passed) {
        mListener.onPassWall();
        passed = true;
      }
    }
  }

  boolean rectsCollide(float firstX, float firstY, float firstWidth, float firstHeight, 
  float secondULX, float secondULY, float secondBRX, float secondBRY) {
    float hh = firstHeight/2;
    float hw = firstWidth/2;
    return isInside(firstX - hw, firstY - hh, secondULX, secondULY, secondBRX, secondBRY) ||
      isInside(firstX + hw, firstY - hh, secondULX, secondULY, secondBRX, secondBRY) ||
      isInside(firstX + hw, firstY + hh, secondULX, secondULY, secondBRX, secondBRY) ||
      isInside(firstX - hw, firstY + hh, secondULX, secondULY, secondBRX, secondBRY);
  }

  boolean isInside(float x, float y, float ulX, float ulY, float brX, float brY) {
    return (x >= ulX && x <= brX && y >= ulY && y <= brY);
  }

  void reset() {
    passed = false;
    topX = width + w;
    topY = random(300, height - 100);
    velocity = random(-1 * movingFactor, 1 * movingFactor);
  }
}

