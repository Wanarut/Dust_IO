import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.io.*; 
import deadpixel.command.*; 
import gifAnimation.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class TouchDust extends PApplet {

String os = System.getProperty("os.name");

int timeout = 15000;
int cur_screen = 0;
int prev_mil = 0;
int counter_prev_mil = 0;
int prev_read_mil = 0;

public void setup() {
  //size(1024, 600, JAVA2D);
  
  noCursor();
  frameRate(15);
  rectMode(CENTER);
  imageMode(CENTER);
  textAlign(CENTER, CENTER);

  setupPin();
  setupGif();
  select_setBtn();
  mode_setBtn();
  timer_setBtn();
}

int level = 9;
int dimming = 7; // Dimming level (0-9)  0 = ON, 9 = OFF

public void draw() {
  int cur_mil = millis();
  if (cur_mil - prev_mil >= timeout & cur_screen != 3) {
    cur_screen = 0;
    prev_mil = cur_mil;
  }
  if (cur_mil - prev_read_mil >= 5000) {
    readPMvalue();
    prev_read_mil = cur_mil;
    
    String[] data_str = new String[1];
    int duty_value = PApplet.parseInt(map(dimming, 1, 7, 40, 3));
    data_str[0] = str(duty_value);
    saveStrings("/home/pi/Dust_IO/testPWM/fan_output.txt", data_str);
  }
  if (start_count & cur_mil - counter_prev_mil>= 1000) {
    if (time_min>0) {
      time_min--;
      //pm_inValue+=10;
    } else {
      println("Timer End");
      text_mode = "OFF";
      text_level = "0";
      //if(os.equals("Linux")) pwmFan.set(period, 0);
      if(os.equals("Linux")) {
        dimming = 9;
        GPIO.digitalWrite(pinESP, GPIO.LOW);
      }
      start_count = false;
    }
    counter_prev_mil = cur_mil;
  }
  if (cur_screen==0) main_screen();
  else if (cur_screen==1) screen_select();
  else if (cur_screen==2) screen_mode();
  else if (cur_screen==3) screen_timer();
}

public void mousePressed() {
  prev_mil = millis();
  if (cur_screen==1) {
    btnMode.hasPressed();
    btnTimer.hasPressed();
    btnShutdown.hasPressed();
  } else if (cur_screen==2) {
    btnHi.hasPressed();
    btnEco.hasPressed();
    for (int i=0; i<btnPower.length; i++) {
      btnPower[i].hasPressed();
    }
  } else if (cur_screen==3) {
    add.hasPressed();
    del.hasPressed();
    set.hasPressed();
    clear.hasPressed();
    cancel.hasPressed();
  }
}

public void mouseReleased() {
  if (cur_screen==0) cur_screen = 1;
  else if (cur_screen==1) {
    if (btnMode.hasReleased()) cur_screen = 2;
    if (btnTimer.hasReleased()) cur_screen = 3;
    if (btnShutdown.hasReleased()) shutdown_now();
  } else if (cur_screen==2) controller();
  else if (cur_screen==3) calculatetime();
}

public void keyPressed() {
  if (key == ESC) {
    //fan_output.flush();
    //fan_output.close();
    exit();
  }
}
class Button {
  String text = "button";
  private int btn_state = 0;
  private int colour_;
  private int xpos_, ypos_, w_, h_, tsize_;

  Button(int xpos, int ypos, int w, int h, int tsize, int colour) {
    xpos_ = xpos;
    ypos_ = ypos;
    w_ = w;
    h_ = h;
    tsize_ = tsize;
    colour_ = colour;
  }

  public void display() {
    noFill();
    strokeWeight(15);
    stroke(colour_);
    rect(xpos_, ypos_, w_, h_);
    textSize(tsize_);
    if (btn_state==1) fill(128);
    else fill(255);
    text(text, xpos_, ypos_-5);
  }

  public boolean hasPressed() {
    boolean pressed = (mouseX > xpos_-w_/2 & 
      mouseX < xpos_+w_/2 & 
      mouseY > ypos_-h_/2 & 
      mouseY < ypos_+h_/2);
    if (pressed) {
      btn_state = 1;
    }
    return pressed;
  }

  public boolean hasReleased() {
    boolean released = (mouseX > xpos_-w_/2 & 
      mouseX < xpos_+w_/2 & 
      mouseY > ypos_-h_/2 & 
      mouseY < ypos_+h_/2);
    if (released) {
      btn_state = 0;
    }
    return released;
  }
}


int pinESP = 23;
int pinZC = 4;
int AC_LOAD = 18;
boolean zcState = false;  // 0 = ready, 1 = processing

public void setupPin() {
  if(os.equals("Linux")) {
    GPIO.pinMode(pinESP, GPIO.OUTPUT);
    //GPIO.pinMode(AC_LOAD, GPIO.OUTPUT);// Set AC Load pin as output
    //GPIO.pinMode(pinZC, GPIO.INPUT);
    //GPIO.attachInterrupt(pinZC, this, "zcDetectISR", GPIO.RISING);
    
    GPIO.digitalWrite(pinESP, GPIO.HIGH);
  }
}

public void zcDetectISR(int pin) {
  if (dimming < level) {
    int dimtime = (dimming);
    delay(dimtime);
    if(os.equals("Linux")){
      //GPIO.digitalWrite(AC_LOAD, GPIO.HIGH);
    }
    delay(1);
  }
  if(os.equals("Linux")){
    //GPIO.digitalWrite(AC_LOAD, GPIO.LOW);
  }
}
class gifButton {
  private Gif image_off;
  private Gif image_down;
  String text = "button";
  private int btn_state = 0;
  private int colour_;
  private int xpos_, ypos_, w_, h_, tsize_;

  gifButton(PApplet parent, int xpos, int ypos, int w, int h, int tsize, int colour, String file1, String file2) {
    image_off = new Gif(parent, file1);
    image_down = new Gif(parent, file2);
    image_off.loop();
    image_down.loop();
    xpos_ = xpos;
    ypos_ = ypos;
    w_ = w;
    h_ = h;
    tsize_ = tsize;
    colour_ = colour;
  }

  public void display() {
    if (btn_state==1) {
      image(image_down, xpos_, ypos_, w_, h_);
      fill(128);
    } else {
      image(image_off, xpos_, ypos_, w_, h_);
      fill(colour_);
    }
    textSize(tsize_);
    text(text, xpos_, ypos_-5);
  }

  public boolean hasPressed() {
    boolean pressed = (mouseX > xpos_-w_/2 & 
      mouseX < xpos_+w_/2 & 
      mouseY > ypos_-h_/2 & 
      mouseY < ypos_+h_/2);
    if (pressed) {
      btn_state = 1;
    }
    return pressed;
  }

  public boolean hasReleased() {
    boolean released = (mouseX > xpos_-w_/2 & 
      mouseX < xpos_+w_/2 & 
      mouseY > ypos_-h_/2 & 
      mouseY < ypos_+h_/2);
    if (released) {
      btn_state = 0;
    }
    return released;
  }
}


int pm_inValue = 0;
int pm_outValue = 0;
int filter_lifetime = 100;
boolean dirty = false;

public void readPMvalue() {
  String pythonPath = sketchPath("/home/pi/Dust_IO/TouchDust/pmsRead.py");
  Command cmd = new Command("python3 " + pythonPath); 
  if ( cmd.run() == true ) {
    // peachy
    String[] output = cmd.getOutput();
    println(output);
    String[] value = output[0].split(" ");
    if (!value[0].equals("-1")) pm_inValue = PApplet.parseInt(value[0]);
    if (!value[1].equals("-1")) pm_outValue = PApplet.parseInt(value[1]);
  }
}

public void shutdown_now() {
  if(os.equals("Linux")) dimming = 9;
  if(os.equals("Linux")) GPIO.digitalWrite(pinESP, GPIO.LOW);
  Command cmd = new Command("shutdown now");
  if ( cmd.run() == true ) {
    String[] output = cmd.getOutput();
    println(output);
  }
}


PImage[] emoji = new PImage[5];
Gif emoji_5;
int gif_i = 0;
int circle_c = color(59, 204, 255);
String text_mode = "AUTO";
String text_level = "2";

public void setupGif() {
  emoji[0] = loadImage("Emoji/Emoji_1.png");
  emoji[1] = loadImage("Emoji/Emoji_2.png");
  emoji[2] = loadImage("Emoji/Emoji_3.png");
  emoji[3] = loadImage("Emoji/Emoji_4.png");
  emoji[4] = loadImage("Emoji/Emoji_5.png");
  emoji_5 = new Gif(this, "Emoji/water.gif");

  emoji_5.loop();
  
}

public void main_screen() {
  background(0);

  if (dirty) {
    image(emoji_5, width/2, height*0.4f, 580, 435);
    fill(255);
    textSize(40); 
    text("PLEASE\nCLEAN UP", width/2, height*0.4f);
  } else {
    select_emoji();
    image(emoji[gif_i], width/2, height*0.4f, 300, 300);

    strokeWeight(15);
    stroke(circle_c);
    noFill();
    circle(width/2, height*0.4f, 350);
  }

  fill(255);
  textSize(60); 
  text("PM 2.5: " + str(pm_inValue) + " μg/m\u00B3", width/2, height*0.77f);
  textSize(16);
  text("MODE " + text_mode, width*0.35f, height*0.85f);
  fill(255);
  text("Filter " + filter_lifetime + " %", width/2, height*0.85f);
  fill(255);
  text("FAN LEVEL " + text_level, width*0.65f, height*0.85f);
}

public void select_emoji() {
  gif_i = 0;
  circle_c = color(0, 255, 0);
  if (pm_inValue>12) {
    gif_i = 1;
    circle_c = color(36, 202, 220);
  }
  if (pm_inValue>35) {
    gif_i = 2;
    circle_c = color(255, 255, 0);
  }
  if (pm_inValue>55) {
    gif_i = 3;
    circle_c = color(255, 162, 0);
  }
  if (pm_inValue>250) {
    gif_i = 4;
    circle_c = color(255, 59, 59);
  }
}
gifButton btnHi, btnEco;
gifButton[] btnPower = new gifButton[4];

public void mode_setBtn() {
  btnHi = new gifButton(this, width/2-200, PApplet.parseInt(height*0.4f), 300, 300, 80, color(255, 0, 0), "btn/winkle.gif", "btn/purple.gif");
  btnHi.text = "Hi";
  btnEco = new gifButton(this, width/2+200, PApplet.parseInt(height*0.4f), 300, 300, 80, color(0, 255, 0), "btn/blue.gif", "btn/purple.gif");
  btnEco.text = "Eco";
  for (int i=0; i<btnPower.length; i++) {
    btnPower[i] = new gifButton(this, (i+1)*(width/5), PApplet.parseInt(height*0.8f), 75, 75, 40, 255, "btn/white.gif", "btn/purple.gif");
    btnPower[i].text = str(i+1);
  }
}

public void screen_mode() {
  background(0);
  btnHi.display();
  btnEco.display();
  for (int i=0; i<btnPower.length; i++) {
    btnPower[i].display();
  }
}

public void controller() {
  if (btnHi.hasReleased()) {
    println("Hi Mode: ESP On");
    text_mode = "HI";
    text_level = "4";
    dimming = 1;
    if(os.equals("Linux")) GPIO.digitalWrite(pinESP, GPIO.HIGH);
  }
  if (btnEco.hasReleased()) {
    println("Eco Mode: ESP Off");
    text_mode = "ECO";
    text_level = "1";
    dimming = 7;
    if(os.equals("Linux")) GPIO.digitalWrite(pinESP, GPIO.LOW);
  }
  for (int i=0; i<btnPower.length; i++) {
    if (btnPower[i].hasReleased()) {
      int btn_level = i+1;
      println("Fan level " + str(btn_level));
      text_mode = "MANUAL";
      text_level = str(btn_level);
      dimming = level - (btn_level*2);
    }
  }
}
gifButton btnMode, btnTimer;
Button btnShutdown;

public void select_setBtn() {
  btnMode = new gifButton(this, width/2-200, height/2, 300, 300, 45, color(255,255,255), "btn/blue.gif", "btn/purple.gif");
  btnMode.text = "MODE";
  btnTimer = new gifButton(this, width/2+200, height/2, 300, 300, 45, color(255,255,255), "btn/blue.gif", "btn/purple.gif");
  btnTimer.text = "TIMER";
  btnShutdown = new Button(PApplet.parseInt(width*0.8f), PApplet.parseInt(height*0.9f), 220, 80, 35, color(200, 200, 200));
  btnShutdown.text = "Shutdown";
  
}

public void screen_select() {
  background(0);
  btnMode.display();
  btnTimer.display();
  btnShutdown.display();
}  
Button add, del, set, clear, cancel;
int time_min;
boolean start_count = false;

public void timer_setBtn() {
  add = new Button(width/2-300, PApplet.parseInt(height*0.3f), 100, 150, 100, color(255, 255, 255));
  add.text = "+";
  del = new Button(width/2+300, PApplet.parseInt(height*0.3f), 100, 150, 100, color(255, 255, 255));
  del.text = "-";

  time_min = 0;

  set = new Button(width/4-50, PApplet.parseInt(height*0.7f), 220, 80, 50, color(0, 255, 0));
  set.text = "SET";
  clear = new Button(2*width/4, PApplet.parseInt(height*0.7f), 220, 80, 50, color(255, 0, 0));
  clear.text = "CLEAR";
  cancel = new Button(3*width/4+50, PApplet.parseInt(height*0.7f), 220, 80, 50, color(200, 200, 200));
  cancel.text = "CANCEL";
}

public void screen_timer() {
  background(0);
  add.display();
  del.display();
  set.display();
  clear.display();
  cancel.display();

  textSize(100);
  fill(255);
  String hour = str(time_min / 60);
  String min = str(time_min % 60);
  text(hour + " : " + min, width/2, PApplet.parseInt(height*0.3f));
}

public void calculatetime() {
  if (add.hasReleased()) {
    time_min += 30;
  }
  if (del.hasReleased()) {
    time_min -= 30;
    if (time_min<0) time_min=0;
  }
  if (set.hasReleased()) {
    start_count = true;
    counter_prev_mil = millis();
  }
  if (clear.hasReleased()) {
    start_count = false;
    time_min=0;
  }
  if (cancel.hasReleased()) {
    cur_screen = 0;
  }
}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "TouchDust" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
