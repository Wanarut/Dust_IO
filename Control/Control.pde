import g4p_controls.*;
import processing.io.*;
//PWM pwmFan;

GImageToggleButton btnESP;
GCustomSlider sdrFan;
GLabel labelESP, labelFan;

int period = 1000; // 1 kHz
int pinESP = 23;
int pinZC = 4;
int AC_LOAD = 18;
boolean zcState = false;  // 0 = ready, 1 = processing
int dimming = 3; // Dimming level (0-3)  0 = ON, 3 = OFF

public void setup() {
  size(480, 220, JAVA2D);
  G4P.setGlobalColorScheme(GCScheme.ORANGE_SCHEME);
  G4P.setCursor(ARROW);

  btnESP = new GImageToggleButton(this, 10, 10);
  btnESP.tag = "ESP control button ";

  sdrFan = new GCustomSlider(this, 20, 100, 260, 100, "metallic");
  sdrFan.setShowDecor(false, true, false, true);
  sdrFan.setNumberFormat(G4P.DECIMAL, 1);
  sdrFan.setLimits(0, 0, 100);
  sdrFan.setShowValue(true);
  sdrFan.setNbrTicks(5);

  createLabels();
  
  GPIO.pinMode(pinESP, GPIO.OUTPUT);
  GPIO.pinMode(AC_LOAD, GPIO.OUTPUT);// Set AC Load pin as output
  //GPIO.pinMode(pinZC, GPIO.INPUT_PULLUP);
  //GPIO.attachInterrupt(pinZC, this, "zcDetectISR", GPIO.RISING);
  GPIO.pinMode(pinZC, GPIO.INPUT);
  GPIO.attachInterrupt(pinZC, this, "zcDetectISR", GPIO.RISING);
  //pwmFan = new PWM("pwmchip0/pwm0"); // GPIO pin 18
}

public void draw() {
  background(250, 225, 200);
}

// Event handler for image toggle buttons
public void handleToggleButtonEvents(GImageToggleButton button, GEvent event) {
  if (button == btnESP) {
    int val = button.getState();
    println(button + "   State: " + val);
    if (val==1){
      GPIO.digitalWrite(pinESP, GPIO.HIGH);
    }else{
      GPIO.digitalWrite(pinESP, GPIO.LOW);
    }
  }
}

void handleSliderEvents(GValueControl slider, GEvent event) {
  if (event == GEvent.RELEASED) {
    int val = slider.getValueI();
    float duty = val/100.0;
    dimming = int(map(duty, 0, 1, 3, 0));
    println("dimming:" + dimming);
    
    //println("duty value:" + duty);
    //pwmFan.set(period, duty);
    //zcState = false;
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
  int dimtime = (3*dimming);
  delay(dimtime);
  GPIO.digitalWrite(AC_LOAD, GPIO.HIGH);
  delay(1);
  GPIO.digitalWrite(AC_LOAD, GPIO.LOW);
  
  //if (!zcState) {
  //  zcState = true;
  //  pwmFan.set(period, 0);
  //}
}
