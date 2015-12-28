class Score {
  private int score;
  
  Score(){
  
  
  }
  
  void increase(int value) {
    score = score + value;
  }

  void reset() {
    score = 0;
  }

  void draw() {
    pushStyle();
    rectMode(CORNER);
    textAlign(LEFT);
    fill(255);
    textSize(40);
    text("Score: " + score, 15, 10, width, 80);
    popStyle();
  }
}

