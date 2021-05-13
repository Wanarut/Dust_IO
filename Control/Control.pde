import g4p_controls.*;
String os = System.getProperty("os.name");
import processing.io.*;

GImageToggleButton btnESP;
GCustomSlider sdrFan;
GLabel labelESP, labelFan;

int period = 1000; // 1 kHz
int pinESP = 23;
int pinZC = 4;
int AC_LOAD = 18;
boolean zcState = false;  // 0 = ready, 1 = processing
int level = 9;
int dimming = level; // Dimming level (0-9)  0 = ON, 9 = OFF

public void setup() {
println(os);
  size(480, 220, JAVA2D);
  G4P.setGlobalColorScheme(GCScheme.ORANGE_SCHEME);
  noCursor();

  btnESP = new GImageToggleButton(this, 10, 10);
  btnESP.tag = "ESP control button ";

  sdrFan = new GCustomSlider(this, 20, 100, 260, 100, "metallic");
  sdrFan.setShowDecor(false, true, false, true);
  sdrFan.setNumberFormat(G4P.DECIMAL, 1);
  sdrFan.setLimits(0, 0, level);
  sdrFan.setShowValue(true);
  sdrFan.setNbrTicks(10);

  createLabels();
  
  if(os == "Linux"){
    GPIO.pinMode(pinESP, GPIO.OUTPUT);
    GPIO.pinMode(AC_LOAD, GPIO.OUTPUT);// Set AC Load pin as output
    GPIO.pinMode(pinZC, GPIO.INPUT);
    GPIO.attachInterrupt(pinZC, this, "zcDetectISR", GPIO.RISING);
  }
}

public void draw() {
  background(250, 225, 200);
}

// Event handler for image toggle buttons
public void handleToggleButtonEvents(GImageToggleButton button, GEvent event) {
  if (button == btnESP) {
    int val = button.getState();
    println(button + "   State: " + val);
    if (val==1) {
      if(os == "Linux"){
        GPIO.digitalWrite(pinESP, GPIO.HIGH);
      }
    } else {
      if(os == "Linux"){
        GPIO.digitalWrite(pinESP, GPIO.LOW);
      }
    }
  }
}

void handleSliderEvents(GValueControl slider, GEvent event) {
  if (event == GEvent.RELEASED) {
    int val = slider.getValueI();
    dimming = level-val;
    println("fan level:" + val);
  }
}

// Create the labels syaing what-is-what
public void createLabels() {
  labelESP = new GLabel(this, 60, 10, 110, 50);
  labelESP.setText("ESP control");
  labelESP.setTextBold();
  labelESP.setOpaque(true);

  labelFan = new GLabel(this, 60, 50, 110, 50);
  labelFan.setText("Fan control");
  labelFan.setTextBold();
  labelFan.setOpaque(true);
}

void zcDetectISR(int pin) {
  if (dimming < level) {
    int dimtime = (dimming);
    delay(dimtime);
    if(os == "Linux"){
      GPIO.digitalWrite(AC_LOAD, GPIO.HIGH);
    }
    delay(1);
  }
  if(os == "Linux"){
    GPIO.digitalWrite(AC_LOAD, GPIO.LOW);
  }
}
