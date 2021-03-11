//import processing.io.*;

GImageToggleButton btnESP;
GCustomSlider sdrFan;
GLabel labelESP, labelFan;

//PWM pwmFan;
int period = 1000; // 1 kHz
int pinESP = 24;
int pinZC = 4;
boolean zcState = false;  // 0 = ready, 1 = processing
int mode = 0;

void setupPin() {
  //GPIO.pinMode(pinESP, GPIO.OUTPUT);
  //GPIO.pinMode(pinZC, GPIO.INPUT_PULLUP);
  //GPIO.attachInterrupt(pinZC, this, "zcDetectISR", GPIO.RISING);
  //pwmFan = new PWM("pwmchip0/pwm0"); // GPIO pin 18
}

// Event handler for image toggle buttons
void handleToggleButtonEvents(GImageToggleButton button, GEvent event) {
  if (button == btnESP) {
    int val = button.getState();
    println(button + "   State: " + val);
    //if (val==1) {
    //  GPIO.digitalWrite(pinESP, GPIO.HIGH);
    //} else {
    //  GPIO.digitalWrite(pinESP, GPIO.LOW);
    //}
  }
}

void handleSliderEvents(GValueControl slider, GEvent event) {
  if (event == GEvent.RELEASED) {
    int val = slider.getValueI();
    float duty = val/100.0;
    println("duty value:" + duty);
    zcState = false;
    //pwmFan.set(period, duty);
  }
}

void zcDetectISR(int pin) {
  if (!zcState) {
    zcState = true;
    //pwmFan.set(period, 0);
  }
}
