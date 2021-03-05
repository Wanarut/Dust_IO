import g4p_controls.*;
import deadpixel.command.*;
import processing.io.*;

GImageToggleButton btnESP;
GCustomSlider sdrFan;
GLabel labelESP, labelFan;

String pythonPath, duty;
String pinFan = " 18";
int pinESP = 24;

public void setup() {
  size(480, 220, JAVA2D);
  G4P.setGlobalColorScheme(GCScheme.ORANGE_SCHEME);
  G4P.setCursor(ARROW);

  btnESP = new GImageToggleButton(this, 10, 10);
  btnESP.tag = "ESP control button ";

  sdrFan = new GCustomSlider(this, 20, 80, 260, 50, "blue18px");
  sdrFan.setShowDecor(false, true, false, true);
  sdrFan.setNumberFormat(G4P.DECIMAL, 3);
  sdrFan.setLimits(0, 0, 100);
  sdrFan.setShowValue(true);

  pythonPath = sketchPath("setPWM.py");
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
    if (val){
      GPIO.digitalWrite(pinESP, GPIO.HIGH);
    }else{
      GPIO.digitalWrite(pinESP, GPIO.LOW);
    }
  }
}

void handleSliderEvents(GValueControl slider, GEvent event) {
  if (event == GEvent.RELEASED) {
    int val = slider.getValueI();
    println("integer value:" + val);
    duty = " " + str(val);
    Command cmd = new Command("python " + pythonPath + pinFan + duty); 
    if ( cmd.run() == true ) {
      // peachy
      String[] output = cmd.getOutput(); 
      println(output);
    }
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
