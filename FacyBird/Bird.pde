class Bird {
  private float x;
  private float y;
  private float size = 40;
  private float easing = 0.09;

  private float targetY;

  private float ground = height;// screen height
  private int frame = 0;
  private PImage[] imgBird;

  Bird(float initialX, float initialY) {
    x = initialX;
    y = initialY;
    imgBird = new PImage[3];
    for (int i = 0; i < imgBird.length; i++) {
      imgBird[i] = loadImage("bird"+i+".png");
    }
  }


  void draw() {

    float dy = targetY - y;
    if (abs(dy) > 1) {
      y += dy * easing;
    }
    frame++; 
    pushStyle();
    imageMode(CENTER);
    image(imgBird[frame%3], x, y, imgBird[frame%3].width, imgBird[frame%3].height);
    popStyle();
  }

  void animate() {
  }
  void setY(int value) {
    targetY = value;
  }
  boolean isInScreen() {
    if (y < height && y > 0)
      return true;
    else return false;
  }
}

