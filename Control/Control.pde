import g4p_controls.*;
import processing.io.*;

GImageToggleButton btnESP;
GCustomSlider sdrFan;
GLabel labelESP, labelFan;

PWM pwmFan;
int period = 1000; // 1 kHz
int pinESP = 24;

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

  GPIO.pinMode(pinESP, GPIO.OUTPUT);
  pwmFan = new PWM("pwmchip0/pwm0"); // GPIO pin 18
  createLabels();
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
    println("duty value:" + duty);
    pwmFan.set(period, duty);
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
