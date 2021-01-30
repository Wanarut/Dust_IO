void setup(){
  GPIO.pinMode(ESPpin, GPIO.OUTPUT);
  GPIO.pinMode(UVpin, GPIO.OUTPUT);
  GPIO.pinMode(FANpin, GPIO.OUTPUT);
  // List all the available serial ports
  printArray(Serial.list());
  // Open the port you are using at the rate you want:
  myPort = new Serial(this, "/dev/ttyACM0", 4800);
  
  surface.setTitle("Dustkiller");
  surface.setResizable(true);
  
  //size(1920, 1080, P2D);
  fullScreen(P2D);
  background(0);
  // Load and play the video in a loop
  
  video = new VLCJVideo(this);
  video.open("/home/pi/DustUI/data/Duskiller StartUp Challenge New.mp4");
  video.setRepeat(true);
  video.play();
  video.setVolume(100); //setVolume only works AFTER play()
  
  emoji_1 = loadImage("emoji/level1.png");
  emoji_2 = loadImage("emoji/level2.png");
  emoji_3 = loadImage("emoji/level3.png");
  emoji_4 = loadImage("emoji/level4.png");
  emoji_5 = loadImage("emoji/level5.png");
  
  imageMode(CENTER);
  rectMode(CENTER);
  ellipseMode(CENTER);
  
  responsive();
}

void draw() {
  background(0);
  //if(width*0.8 != video_size[0] || height*0.8 != video_size[1]) {
  //  responsive();
  //}
  if(width*0.8 != video_size[0]) {
    responsive();
  }
  
  hubar.display(humidity, 0, 100);
  tebar.display(temperature, 0, 100);
  
  fill(0);
  noStroke();
  rect(banner_position[0], banner_position[1], video_size[0], banner_size[1]);
  
  image(video, video_position[0], video_position[1], video_size[0], video_size[1]);
  
  pm_display();
  
  //humidity++;
  //humidity%=100;
  //temperature++;
  //temperature%=100;
  //PM2_5++;
  //PM2_5%=500;
}

void responsive() {
    set_video_dimention();
    set_banner();
    set_font();
    
    hubar = new BarChart(color(145, 215, 255), 30, int(width*0.15), ny_position[0], ny_position[1] - int(height*0.1), ny_position[0], 0, true);
    tebar = new BarChart(color(255, 145, 145), 30, int(width*0.15), ny_position[2], ny_position[1] - int(height*0.1), ny_position[2], 0, true);
}
