/* autogenerated by Processing revision 1292 on 2023-07-23 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import processing.io.*;
import gifAnimation.*;
import deadpixel.command.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class TouchDust extends PApplet {

static final String os = System.getProperty("os.name");
// timeout interval
static final int timeout = 15000;
// screen index
int cur_screen = 0;
int save_screen = -1;
// software polling
long prev_mil = 0;
long counter_prev_mil = 0;
long prev_read_mil = 0;
long prev_filter_mil = 0;
// system font
PFont font_bold, font_regu, font_thai;
// navigation btn
Button menu, cancel;
// save data
static final String properties_file = "data/properties.json";
static final String lifetime_key = "filter_lifetime";
JSONObject properties;

public void setup() {
    // size(1280, 720, JAVA2D);
    /* size commented out by preprocessor */;
    noCursor();
    // setup drawing style
    frameRate(15);
    rectMode(CENTER);
    imageMode(CENTER);
    textAlign(CENTER, CENTER);
    // setup system font
    font_bold = createFont("Fira_Sans/FiraSans-Bold.ttf", 100);
    font_regu = createFont("Fira_Sans/FiraSans-Regular.ttf", 100);
    font_thai = createFont("THSarabunNew/THSarabunNew.ttf", 36);
    // setup screen
    setupPin();
    setupmain();
    select_setBtn();
    mode_setBtn();
    timer_setBtn();
    changefilter_setBtn();
    confirmfilter_setBtn();
    cleanESP_setBtn();
    // setup navigation btn
    menu = new Button(width / 7, PApplet.parseInt(height * 0.85f), 150, 150, 1, 0, "btn/btn_back.jpg");
    cancel = new Button(width / 2, PApplet.parseInt(height * 0.85f), 100, 100, 1, 0, "btn/logo.jpg");
    // load properties file
    properties = loadJSONObject(properties_file);
    if (properties == null) {
        println("not found properties file");
        properties = new JSONObject();
        properties.setInt(lifetime_key, filter_lifetime_max);
        saveJSONObject(properties, properties_file);
    }
}
// pwm fan
static final int level = 9;
int dimming = 7; // Dimming level (0-9)  0 = ON, 9 = OFF
static final String fan_output_path = "/home/pi/Dust_IO/testPWM/fan_output.txt";

public void draw() {
    long cur_mil = millis();
    //timmer for switching to main page
    // if (cur_mil - prev_mil >= timeout & cur_screen != 3) {
    //     prev_mil = cur_mil;
    //     cur_screen = 0;
    // }

    // adaptive fan simulation
    // pm_inValue++;
    // pm_inValue%=260;
    // adaptiveFan();

    //read pm value & write duty cycle every 5 second
    if (cur_mil - prev_read_mil >= 5000) {
        prev_read_mil = cur_mil;
        // read pm value
        readPMvalue();
        // write duty cycle
        String[] data_str = new String[1];
        int duty_value = PApplet.parseInt(map(dimming, 1, level, 40, 0));
        data_str[0] = str(duty_value);
        saveStrings(fan_output_path, data_str);
        
        // clean esp simulation
        // pm_inValue = 100;
        // pm_outValue += 15;
        // pm_outValue %= 100;
        // println("pm_outValue:", pm_outValue);

        // Check ESP Efficiency
        if (isESPdirty()) {
            // save cur_screen
            if (save_screen < 0) save_screen = cur_screen;
            // switch to clean esp screen
            cur_screen = 6;
        } else{
            // load cur_screen
            if (save_screen >= 0) cur_screen = save_screen;
            save_screen = -1;
        }
        adaptiveFan();
    }
    //timmer for sleep
    if (start_count & cur_mil - counter_prev_mil >= 1000) {
        counter_prev_mil = cur_mil;
        // start countdown
        if (time_min > 0) {
            time_min--;
        } else {
            // end countdown
            println("Timer End");
            text_mode = "OFF";
            text_mode_post = "";
            // setduty cycle = 0 & close ESP pin
            dimming = level;
            //if(os.equals("Linux")) pwmFan.set(period, 0);
            if (os.equals("Linux")) {
                GPIO.digitalWrite(pinESP, GPIO.LOW);
            }
            start_count = false;
        }
    }
    //decrease filter lifetime every minute
    if (cur_mil - prev_filter_mil >= 60000) {
        prev_filter_mil = cur_mil;
        decreaseFilterLife();
    }
    // select showing screen
    switch(cur_screen) {
        case 0 :
            main_screen();
            break;
        case 1 :
            screen_select();
            cancel.display();
            break;
        case 2 :
            screen_mode();
            menu.display();
            cancel.display();
            break;
        case 3 :
            screen_timer();
            menu.display();
            cancel.display();
            break;
        case 4 :
            screen_changefilter();
            break;
        case 5 :
            screen_confirmfilter();
            break;
        case 6 :
            screen_cleanESP();
            break;
        default :
        break;
    }
}

public void mousePressed() {
    //reset timmer
    prev_mil = millis();
    // button is clicking
    switch(cur_screen) {
        case 0 :
            btnShutdown.hasPressed();
            if (filter_dirty) btnAlert.hasPressed();
            break;
        case 1 :
            btnMode.hasPressed();
            btnTimer.hasPressed();
            
            cancel.hasPressed();
            break;
        case 2 :
            btnFanPow.hasPressed();
            btnAutoHi.hasPressed();
            btnAutoEco.hasPressed();
            
            menu.hasPressed();
            cancel.hasPressed();
            break;
        case 3 :
            add.hasPressed();
            del.hasPressed();
            set.hasPressed();
            clear.hasPressed();
            
            menu.hasPressed();
            cancel.hasPressed();
            break;
        case 4 :
            btnNext.hasPressed();
            break;
        case 5 :
            btnYes.hasPressed();
            btnNo.hasPressed();
            break;
        default :
        break;
    }
}

public void mouseReleased() {
    // button action
    switch(cur_screen) {
        case 0 :
            if (btnShutdown.hasReleased()) shutdown_now();
            else if (filter_dirty && btnAlert.hasReleased()) cur_screen = 4;
            else cur_screen = 1;
            break;
        case 1 :
            if (btnMode.hasReleased()) cur_screen = 2;
            if (btnTimer.hasReleased()) cur_screen = 3;
            
            if (cancel.hasReleased()) cur_screen = 0;
            break;
        case 2 :
            controller();
            if (menu.hasReleased()) cur_screen = 1;
            if (cancel.hasReleased()) cur_screen = 0;
            break;
        case 3 :
            calculatetime();
            if (menu.hasReleased()) cur_screen = 1;
            if (cancel.hasReleased()) cur_screen = 0;
            break;
        case 4 :
            if (btnNext.hasReleased()) cur_screen = 5;
            break;
        case 5 :
            if (btnYes.hasReleased()) {
                filter_dirty = false;
                resetFilter();
                cur_screen = 0;
            }
            if (btnNo.hasReleased()) cur_screen = 0;
            break;
        default :
        break;	
    }
}

public void keyPressed() {
    // press ESC for exit app
    if (key == ESC) {
        exit();
    }
}

public void shutdown_now() {
    // linux shutdown command
    if (os.equals("Linux")) dimming = 9;
    if (os.equals("Linux")) GPIO.digitalWrite(pinESP, GPIO.LOW);
    Command cmd = new Command("shutdown now");
    if (cmd.run() == true) {
        String[] output = cmd.getOutput();
        println(output);
    }
}
class Button {
    private PImage image;
    private PImage image_active;
    String text = "";
    private int btn_state = 0;
    private int colour_;
    private int xpos_, ypos_, w_, h_, tsize_;
    int weight = 0;
    PFont font;
    
    // construction with image
    Button(int xpos, int ypos, int w, int h, int tsize, int colour, String file) {
        xpos_ = xpos;
        ypos_ = ypos;
        w_ = w;
        h_ = h;
        tsize_ = tsize;
        colour_ = colour;

        font = createFont("Fira_Sans/FiraSans-Regular.ttf", tsize_);

        image = loadImage(file);
        image_active = loadImage(file);
        image_active.filter(POSTERIZE, 5);
    }
    
    // construction with out image
    Button(int xpos, int ypos, int w, int h, int tsize, int colour) {
        xpos_ = xpos;
        ypos_ = ypos;
        w_ = w;
        h_ = h;
        tsize_ = tsize;
        colour_ = colour;
        
        font = createFont("Fira_Sans/FiraSans-Regular.ttf", tsize_);
    }

    public void setImage(PImage cur_image) {
        image = cur_image;
        image_active = cur_image;
        image_active.filter(POSTERIZE, 5);
    }
    
    public void display() {
        // add stroke in button
        if (weight > 0) {
            noFill();
            strokeWeight(weight);
            stroke(colour_);
            rect(xpos_, ypos_, w_, h_, 8);
        }
        // display image
        if (image != null) {
            if (btn_state ==  1) {
                image(image_active, xpos_, ypos_, w_, h_);
            } else {
                image(image, xpos_, ypos_, w_, h_);
            }
        }
        // display text
        if (btn_state ==  1) fill(128);
        else fill(0);
        textFont(font);
        text(text, xpos_, ypos_ - 3);
    }
    
    public boolean hasPressed() {
        boolean pressed = (mouseX > xpos_ - w_ / 2 & 
            mouseX< xpos_ + w_ / 2 & 
            mouseY> ypos_ - h_ / 2 & 
            mouseY< ypos_ + h_ / 2);
        if (pressed) {
            btn_state = 1;
        }
        return pressed;
    }
    
    public boolean hasReleased() {
        boolean released = (mouseX > xpos_ - w_ / 2 & 
            mouseX< xpos_ + w_ / 2 & 
            mouseY> ypos_ - h_ / 2 & 
            mouseY< ypos_ + h_ / 2);
        if (released) {
            btn_state = 0;
        }
        return released;
    }
}


static final int pinESP = 23;
static final int pinZC = 4;
static final int AC_LOAD = 18;
boolean zcState = false;  // 0 = ready, 1 = processing

public void setupPin() {
  // setup pin of pi
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
boolean esp_dirty = false;
boolean filter_dirty = false;

static final int filter_lifetime_max = 259200;
static final int decrease_step = 1;

static final String python_file_pms = "/home/pi/Dust_IO/TouchDust/pmsRead.py";
static final String python_cmd = "python3 ";

public void readPMvalue() {
    String pythonPath = sketchPath(python_file_pms);
    Command cmd = new Command(python_cmd + pythonPath); 
    if (cmd.run() == true) {
        // peachy
        String[] output = cmd.getOutput();
        println(output);
        String[] value = output[0].split(" ");
        if (!value[0].equals("-1")) pm_inValue = PApplet.parseInt(value[0]);
        if (!value[1].equals("-1")) pm_outValue = PApplet.parseInt(value[1]);
    }
}

public boolean isESPdirty() {
    if (pm_inValue > 20) {
        int diff = (pm_inValue - pm_outValue);
        int percent = (diff * 100) / pm_inValue;
        if (percent < 30) {
            esp_dirty = true;
        }else{
            esp_dirty = false;
        }
    }
    println("ESPdirty:", esp_dirty);
    return esp_dirty;
}

public int getFilterPercent() {
    // load data from properties file
    properties = loadJSONObject(properties_file);
    int filter_lifetime = properties.getInt(lifetime_key);
    int result = (filter_lifetime * 100) / filter_lifetime_max;
    if (result == 0) filter_dirty = true;
    return result;
}

public void decreaseFilterLife() {
    int filter_lifetime = properties.getInt(lifetime_key);
    if (filter_lifetime > 0) {
        filter_lifetime -= decrease_step;
        properties.setInt(lifetime_key, filter_lifetime);
        saveJSONObject(properties, properties_file);
    }
}

public void resetFilter() {
    properties.setInt(lifetime_key, filter_lifetime_max);
    saveJSONObject(properties, properties_file);
}
PImage instuction2;

public void cleanESP_setBtn() {
    instuction2 = loadImage("logo/esp.png");
}

static final String label_cleanESP = "Please clean the ESP";
static final String label_cleanESP_th = "กรุณาทำความสะอาดชุด ESP";

public void screen_cleanESP() {
    background(255);
    image(instuction2, width / 2, height / 2 + 50, 500, 400);
    fill(62, 109, 194);
    textFont(font_regu);
    textSize(50);
    text(label_cleanESP, width / 2, height * 0.1f);
    textFont(font_thai);
    text(label_cleanESP_th, width / 2, height * 0.18f);
}
Button btnYes, btnNo;

public void confirmfilter_setBtn() {
    btnYes = new Button(width / 2 - 130, PApplet.parseInt(height * 0.65f), 150, 50, 30, color(17, 181, 92));
    btnYes.text = "YES";
    btnYes.weight = 5;
    btnNo = new Button(width / 2 + 130, PApplet.parseInt(height * 0.65f), 150, 50, 30, color(122));
    btnNo.text = "NO";
    btnNo.weight = 5;
}

static final String label_confirmfilter = "Have you changed the air filter?";
static final String label_confirmfilter_th = "คุณเปลี่ยนไส้กรองอากาศแล้วใช่หรือไม่";

public void screen_confirmfilter() {
    background(255);
    fill(100);
    textFont(font_regu);
    textSize(60);
    text(label_confirmfilter, width / 2, height * 0.4f);
    textFont(font_thai);
    text(label_confirmfilter_th, width / 2, height * 0.5f);
    btnYes.display();
    btnNo.display();
}  
Button btnNext;
PImage instuction;

public void changefilter_setBtn() {
    btnNext = new Button(width - 125, height - 75, 150, 50, 30, color(128));
    btnNext.text = "NEXT";
    btnNext.weight = 5;

    instuction = loadImage("logo/hepa.jpg");
}

static final String label_changefilter = "Please change the air filter";
static final String label_changefilter_th = "กรุณาเปลี่ยนแผ่นกรองอากาศ";

public void screen_changefilter() {
    background(255);
    image(instuction, width / 2, height / 2 + 50, 500, 400);
    fill(255, 0, 0);
    textFont(font_regu);
    textSize(50);
    text(label_changefilter, width / 2, height * 0.1f);
    textFont(font_thai);
    text(label_changefilter_th, width / 2, height * 0.18f);
    btnNext.display();
}  
PImage[] emoji = new PImage[5];
int gif_i = 0;
// fan state
String text_mode = "AUTO";
String text_mode_post = "Eco";
int text_mode_color = color(0, 176, 80);
// icon
PImage icon_mode, icon_filter, icon_fan;
Button btnShutdown, btnAlert;

public void setupmain() {
    for (int i = 0; i < emoji.length; i++) {
        emoji[i] = loadImage("Emoji/emoji_lvl_" + str(i + 1) + ".jpg");
    }
    icon_mode = loadImage("logo/icon_mode.jpg");
    icon_filter = loadImage("logo/icon_filter.jpg");
    icon_fan = loadImage("logo/icon_fan.jpg");
    
    btnShutdown = new Button(PApplet.parseInt(width - 75), PApplet.parseInt(height - 75), 100, 100, 1, 0, "btn/icon_power.jpg");
    btnAlert = new Button(PApplet.parseInt(width - 75), PApplet.parseInt(height - 200), 100, 100, 1, 0, "btn/alert.png");
}

static final String label_pm = "  PM                μg/m\u00B3";
static final String label_25 = "2.5";
static final String label_mode = "MODE : ";
static final String label_filter = "Filter : ";
static final String label_fan = "FAN LEVEL : ";

public void main_screen() {
    background(255);
    // display emoji
    select_emoji();
    image(emoji[gif_i], width / 2, height * 0.3f, 400, 400);
    // display pm value
    fill(128);
    textFont(font_bold);
    textSize(60);
    text(label_pm, width / 2, height * 0.64f);
    textSize(30);
    text(label_25, width / 2 - 120, height * 0.67f);
    fill(0);
    textSize(90);
    textAlign(RIGHT, CENTER);
    text(pm_inValue, width / 2 + 70, height * 0.62f);
    textAlign(CENTER, CENTER);
    // display mode
    fill(128);
    textFont(font_regu);
    textSize(24);
    text(label_mode + text_mode, width * 0.32f, height * 0.83f);
    textAlign(LEFT, CENTER);
    fill(text_mode_color);
    text(text_mode_post, width * 0.38f, height * 0.83f);
    textAlign(CENTER, CENTER);
    // display filter lifetime
    fill(128);
    text(label_filter, width / 2 - 24, height * 0.83f);
    if (getFilterPercent() <= 10) fill(255, 0, 0);
    textAlign(RIGHT, CENTER);
    text(getFilterPercent() + " %", width / 2 + 75, height * 0.83f);
    textAlign(CENTER, CENTER);
    // display fan speed
    fill(128);
    text(label_fan + str(fan_index), width * 0.65f, height * 0.83f);
    // display icon
    image(icon_mode, width * 0.33f, height * 0.77f, 50, 50);
    image(icon_filter, width / 2, height * 0.77f, 50, 50);
    image(icon_fan, width * 0.65f, height * 0.77f, 50, 50);
    // display button
    btnShutdown.display();
    if (filter_dirty) btnAlert.display();
}

public void select_emoji() {
    gif_i = 0;
    if (pm_inValue > 12) {
        gif_i = 1;
    }
    if (pm_inValue > 35) {
        gif_i = 2;
    }
    if (pm_inValue > 55) {
        gif_i = 3;
    }
    if (pm_inValue > 250) {
        gif_i = 4;
    }
}
Button btnFanPow, btnAutoHi, btnAutoEco;
PImage[] fanPowerImgs = new PImage[5];
int fan_index = 0;
// working mode
static final int mode_high = 1;
static final int mode_eco = 2;
static final int mode_man = 3;
int cur_mode = mode_eco;

public void mode_setBtn() {
    btnFanPow = new Button(width / 2 - 280, PApplet.parseInt(height / 2.3f), 400, 400, 1, 0, "btn/fan_0.jpg");
    btnAutoEco = new Button(width / 2 + 280, height / 4, 250, 250, 1, 0, "btn/mode_eco.jpg");
    btnAutoHi = new Button(width / 2 + 280, PApplet.parseInt(1.8f * height) / 3, 250, 250, 1, 0, "btn/mode_high.jpg");
    
    for (int i = 0; i < fanPowerImgs.length; i++) {
        fanPowerImgs[i] = loadImage("btn/fan_" + str(i) + ".jpg");
    }
}

static final String eco = "ECO";
static final String high = "High Air Quality";

public void screen_mode() {
    background(255);
    
    btnFanPow.setImage(fanPowerImgs[fan_index]);
    btnFanPow.display();
    btnAutoHi.display();
    btnAutoEco.display();
    
    fill(128);
    textFont(font_bold);
    textSize(40);
    text(eco, width / 2 + 280, height / 4 + 110);
    text(high, width / 2 + 280, PApplet.parseInt(2.3f * height) / 3);
}

public void controller() {
    if (btnAutoHi.hasReleased()) {
        cur_mode = mode_high;
        println("Eco Mode: ESP On");
        text_mode = "AUTO";
        text_mode_post = "Hi";
        text_mode_color = color(255, 0, 0);
    }
    if (btnAutoEco.hasReleased()) {
        cur_mode = mode_eco;
        println("Eco Mode: ESP Off");
        text_mode = "AUTO";
        text_mode_post = "Eco";
        text_mode_color = color(0, 176, 80);
    }
    if (btnFanPow.hasReleased()) {
        cur_mode = mode_man;
        println("Manual Mode");
        text_mode = "MANUAL";
        text_mode_post = "";

        dimming -= 2;
        if (dimming < 1) dimming = 7;
    }
    adaptiveFan();
    println(text_mode, text_mode_post, "Fan Level:", str(fan_index));
}


public void adaptiveFan() {
    switch(cur_mode) {
        case mode_high :
            if (pm_inValue > 3 && pm_inValue < 9) {
                dimming = 7;
            }
            if (pm_inValue > 12) {
                dimming = 1;
            }
            if (os.equals("Linux")) GPIO.digitalWrite(pinESP, GPIO.HIGH);
            break;
        case mode_eco :
            if (pm_inValue > 3 && pm_inValue < 9) {
                dimming = 7;
            }
            if (pm_inValue > 12 && pm_inValue < 35) {
                dimming = 5;
            }
            if (pm_inValue > 38 && pm_inValue < 55) {
                dimming = 3;
            }
            if (pm_inValue > 58) {
                dimming = 1;
            }
            if (os.equals("Linux")) GPIO.digitalWrite(pinESP, GPIO.LOW);
            break;
        default :
            break;
    }
    fan_index = (level - dimming) / 2;
}
Button btnMode, btnTimer;

public void select_setBtn() {
    btnMode = new Button(width / 2 - 280, height / 2, 300, 300, 1, 0, "btn/btn_mode.jpg");
    btnTimer = new Button(width / 2 + 280, height / 2, 300, 300, 1, 0, "btn/btn_timer.jpg");
}

public void screen_select() {
    background(255);
    btnMode.display();
    btnTimer.display();
}  
Button add, del, set, clear;
// countdown time in second (max 2,147,483,647 sec = ~68 years)
int time_min;
boolean start_count = false;
// increase countdown time by 15 min per step
static final int time_step = 900;
PImage sleep_timer_img;

static final String lead_zero_format = "%02d";
static final String colon = ":";
static final String time_label = "  HOURS                   MINUTES";

public void timer_setBtn() {
    time_min = 0;
    // sleep timer logo
    sleep_timer_img = loadImage("logo/icon_sleep.jpg");
    // timmer increase & decrease btn
    add = new Button(width / 2 + 350, PApplet.parseInt(height * 0.4f), 120, 120, 1, 0, "btn/plus.png");
    del = new Button(width / 2 - 350, PApplet.parseInt(height * 0.4f), 120, 120, 1, 0, "btn/min.png");
    // set timmer & clear btn
    set = new Button(width / 2 - 150, PApplet.parseInt(height * 0.65f), 200, 70, 36, color(0, 173, 73));
    set.text = "SET";
    set.weight = 5;
    clear = new Button(width / 2 + 150, PApplet.parseInt(height * 0.65f), 200, 70, 36, color(122, 122, 122));
    clear.text = "CLEAR";
    clear.weight = 5;
}

public void screen_timer() {
    background(255);
    // display logo
    image(sleep_timer_img, PApplet.parseInt(width * 0.9f), PApplet.parseInt(height * 0.15f), 228, 180);
    // display btns
    add.display();
    del.display();
    set.display();
    clear.display();
    // digit lead with zero
    String hour = String.format(lead_zero_format, time_min / 3600);
    String min = String.format(lead_zero_format, (time_min / 60) % 60);
    // display time
    fill(55, 179, 73);
    textFont(font_bold);
    textSize(120);
    text(hour, width / 2 - 128, PApplet.parseInt(height * 0.35f));
    text(colon, width / 2, PApplet.parseInt(height * 0.35f));
    text(min, width / 2 + 128, PApplet.parseInt(height * 0.35f));
    // display labels
    fill(157);
    textFont(font_regu);
    textSize(30);
    text(time_label, width / 2, PApplet.parseInt(height * 0.47f));
}

public void calculatetime() {
    if (add.hasReleased()) {
        time_min += time_step;
    }
    if (del.hasReleased()) {
        time_min -= time_step;
        if (time_min < 0) time_min = 0;
    }
    if (set.hasReleased()) {
        start_count = true;
        counter_prev_mil = millis();
    }
    if (clear.hasReleased()) {
        start_count = false;
        time_min = 0;
    }
}


  public void settings() { fullScreen(); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "TouchDust" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
