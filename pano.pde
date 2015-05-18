// Code for panorama project
// 2009 Colin Owens
// For DMI, Dynamic Media Institute
 
 
import processing.video.*;
 
Movie video;
PImage picker;
PFont fontA;
 
String videoFileName = "Your Movie Here.mov";
 
boolean running = false;
boolean startscreen = false;
boolean horizontal = true;
boolean vertical = false;
 
float videoFullDuration = 0;
float videoFrameDuration = .04;
int videoFrameCount = 0;
//
int videoHeight;
int videoWidth;
//
int finalImageWidth = 900;
int finalImageHeight = 0;
//
int imageCount = 0;
int currentImage = 0;
//
//
int currentLine = 0;
//
int xPosition, yPosition;
//
PImage destinationImage;
//
void setup() {
  video = new Movie(this,videoFileName);
  video.jump(0);
  video.read();
  video.pause();
 
  videoHeight = video.height;
  videoWidth = video.width;
  finalImageHeight = videoHeight;
 
  picker = video;
  picker.save("test.tif");
 
  frame.setResizable(true);
  size(picker.width,picker.height,P2D); 
  //background(0);
  videoFullDuration = video.duration();
  videoFrameCount = floor(videoFullDuration * 24);
  imageCount = ceil(videoFrameCount/finalImageWidth);
  println("Frames:"+videoFrameCount);
  println("Images:"+imageCount);
  println("movie duration:" + video.duration());
  destinationImage = createImage(finalImageWidth,finalImageHeight,RGB);
 
  fontA = loadFont("garamond.vlw");
  textFont(fontA, 32);
}
//
//
void draw() {
  if(!running) {
    video.stop();
    image(picker,0,0);
    fill(0,50);
    noStroke();
    if(horizontal) {
      rect(0,0,mouseX-1,height);
      rect(mouseX+1,0,width,height);
      fill(255,128);
      text("x is " + mouseX + " pixels",32,32);
    }
    if(vertical) {
      rect(0,0,width,mouseY-1);
      rect(0,mouseY+1,width,height);
      fill(255,128);
      text("y is " + mouseY + " pixels",32,32);
    }
  }
  if(running) {
    frame.setSize(finalImageWidth,finalImageHeight);
    videoHeight = video.height;
    videoWidth = video.width;
 
    if(video.time() >= video.duration()) running = false;
 
    println(video.duration() + " " + video.time());
 
    background(0);
    if(running) {
      if(horizontal) {
        if (currentLine < finalImageWidth) {
          currentLine++; 
          float thisFrameTime = (currentLine + (currentImage*finalImageWidth))*videoFrameDuration;
          video.jump(thisFrameTime);
          video.read();
          destinationImage.copy(video,xPosition,0,1,videoHeight,currentLine,0,1,videoHeight);
          image(destinationImage,0,0,finalImageWidth,finalImageHeight);
          image(video,15,15,videoWidth/5,videoHeight/5);
          stroke(255,0,0,128);
          line((xPosition/5)+15,15,xPosition/5+15,videoHeight/5+15);
        } 
        else {
          amen();
        }
      }
      if(vertical) {
        if (currentLine < finalImageHeight) {
          currentLine++; 
          float thisFrameTime = (currentLine + (currentImage*finalImageHeight))*videoFrameDuration;
          video.jump(thisFrameTime);
          video.read();
          destinationImage.copy(video,0,yPosition,videoWidth,1,0,currentLine,videoWidth,1);
          image(destinationImage,0,0,finalImageWidth,finalImageHeight);
          image(video,15,15,videoWidth/5,videoHeight/5);
          stroke(255,0,0,128);
          line(15,(yPosition/5)+15,videoWidth/5+15,yPosition/5+15);
        } 
        else {
          amen();
        }
      }
    }
    else {
      amen();
      println("All panoramas complete");
      delay(2000);
      exit();
    }
  }
}
 
void amen() {
  println("Frame "+currentImage+" Complete.");
  currentImage++;
  currentLine = 0; 
  destinationImage.save("panorama"+currentImage+".tif"); 
  destinationImage = createImage(finalImageWidth,finalImageHeight,RGB);
}
 
void mousePressed() {
  if(horizontal) {
    xPosition = mouseX;
    yPosition = 0;
  }
  if(vertical) {
    xPosition = 0;
    yPosition = mouseY;
  }
  running = true; 
}
 
void keyPressed() {
  if (key == 'h' || key == 'H') {
    horizontal = true; 
    vertical = false;
  }
  if (key == 'v' || key == 'V') {
    vertical = true; 
    horizontal = false;
  }
}
