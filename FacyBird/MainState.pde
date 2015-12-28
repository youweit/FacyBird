import gab.opencv.*;
import processing.video.*;
import java.awt.*;  
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

class MainState implements HitListener {
  private int HEADUP_THRESHOLD = 30;
  private PImage mBackgroundImage;
  private int WALL_COUNT = 4;
  private int startPoint = 0;
  private int stopPoint = 0;
  private Bird mBird;
  private Wall[] mWall;
  private Score score;

  private Capture video;
  private OpenCV opencv;
  private Minim minim;
  private ArrayList<Integer> dy;

  private ArrayList<PImage> mShotsList;
  private boolean isStart = false;
  private boolean isGameOver = false;

  private int startTime = 0;
  private PApplet mInstance; //Application context
  private int galleryPos = 0;
  private String[] text;
  private int textPos = -1;
  
  //sounds
  private AudioPlayer point;
  private AudioPlayer hit;
  private AudioPlayer wing;
  MainState(PApplet instance) {
    mInstance = instance;
    minim = new Minim(instance);
    mBird = new Bird( 100, height/2);
    mWall = new Wall[WALL_COUNT];
    dy = new ArrayList<Integer>();
    mShotsList = new ArrayList<PImage>();
    point = minim.loadFile("sfx_point.mp3");
    hit = minim.loadFile("sfx_hit.mp3");
    wing = minim.loadFile("sfx_wing.mp3");
    for (int i = 0; i < mWall.length; i++) {
      mWall[i] = new Wall(width / WALL_COUNT * i + 400, random(300, height-100));
      mWall[i].setListener(this);
    }
    score = new Score();
    String[] backgrounds = new String[]{"dayCity.png","nightCity.png"};
    mBackgroundImage = loadImage(backgrounds[(int)random(0, backgrounds.length)]);

    video = new Capture(mInstance, camera_width, camera_height);
    opencv = new OpenCV(mInstance, camera_width, camera_height);
    
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
    startTime = year()+month()+day()+hour()+minute()+second();
    video.start();

    text = new String[] {
      "Don't cry because it's over, smile because it happened.  ― Dr. Seuss", 
      "Never, never, never give up.  — Sir Winston Churchill", 
      "It’s not that I’m so smart, it’s just that I stay with problems longer.  – Albert Einstein", "I am not discouraged because every wrong attempt discarded is a step forward.  – Thomas Edison"
    };
  }

  void draw() {
    clear();

    if (isStart && !isGameOver) {
      if(!wing.isPlaying ()) wing.loop();
      image(mBackgroundImage, 0, 0, mBackgroundImage.width, mBackgroundImage.height);

      mBird.draw();

      for (Wall w : mWall) {
        w.draw();
        if (score.score >= 5) {
          w.startMoving = true;
          w.movingFactor = score.score / 5 >= 15? 15:score.score;
        }
        w.hitTest(mBird);
      }
    } else {
      if(wing.isPlaying ()) wing.pause();
      galleryPos += 3;
      
      for (int i = 0; i < mShotsList.size (); i++) {
        image(mShotsList.get(i), width+i*mShotsList.get(i).width - galleryPos, (height - mShotsList.get(i).height)/2, mShotsList.get(i).width, mShotsList.get(i).height);
      }
      textAlign(CENTER);
      text(text[textPos], 0, height - 130, width, 80);
    }

    if (!mBird.isInScreen()) {
      onHitWall();
    }
    pushStyle();
    scale(0.6);
    opencv.loadImage(video);

    image(video, 10, 10 );
    noFill();
    stroke(0, 255, 0);
    strokeWeight(3);
    popStyle();
    Rectangle[] faces = opencv.detect();
    //println(faces.length);

    for (int i = 0; i < faces.length; i++) {
      //println(faces[i].y);
      //mBird.setY((int)map(faces[i].y, 5, 100, 0, 1000));

      if (dy.size() <= 5) {
        dy.add(faces[i].y);
      } else {
        dy.remove(0);
        dy.add(faces[i].y);
      }
      int average = 0;
      for (Integer a : dy) {
        average = average + a;
      }
      average /= dy.size();
      mBird.setY((int) map(average, stopPoint, startPoint, 200, height - 50));


      if ( average > HEADUP_THRESHOLD) {

        onHeadUp();
      }
      //dy = faces[i].y;

      //saveFrame("data/shots/test.jpg"); 
      rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
    }

    score.draw();
  }

  void onHitWall() {
    isGameOver = true;
    if (textPos == -1) {
      textPos = (int)random(0, text.length);
      hit.rewind();
      hit.play();
    }
  }

  void onPassWall() {
    score.increase(1);

    point.rewind();
    point.play();
    
    //video.read();
    saveImage();
    println("onPassWall");
  }

  void onHeadUp() {
    //println("onHeadsUp");
  }

  void saveImage() {

    PImage pg = video.get(0, 0, 320, 240);

    mShotsList.add(pg);

    pg.save("data/shots/"+year()+month()+day()+hour()+minute()+second()+".png");
  }

  void setCalibrate(int start, int stop) {
    this.startPoint = start;
    this.stopPoint = stop;
    isStart = true;
  }

  boolean isStart() {
    return isStart;
  }

  boolean isGameOver() {
    return isGameOver;
  }
  
  void mouseClicked() {
    
    
  }
}

