gifButton btnHi, btnEco;
gifButton[] btnPower = new gifButton[4];

void mode_setBtn() {
  btnHi = new gifButton(this, width/2-200, int(height*0.4), 300, 300, 80, color(255, 0, 0), "btn/winkle.gif", "btn/purple.gif");
  btnHi.text = "Hi";
  btnEco = new gifButton(this, width/2+200, int(height*0.4), 300, 300, 80, color(0, 255, 0), "btn/sky.gif", "btn/purple.gif");
  btnEco.text = "Eco";
  for (int i=0; i<btnPower.length; i++) {
    btnPower[i] = new gifButton(this, (i+1)*(width/5), int(height*0.8), 75, 75, 40, 255, "btn/white.gif", "btn/purple.gif");
    btnPower[i].text = str(i+1);
  }
}

void screen_mode() {
  background(0);
  btnHi.display();
  btnEco.display();
  for (int i=0; i<btnPower.length; i++) {
    btnPower[i].display();
  }
}

void controller() {
  if (btnHi.hasReleased()) {
    println("Hi Mode: ESP On");
    text_mode = "HI";
    text_level = "4";
    pwmFan.set(period, 1.0);
    GPIO.digitalWrite(pinESP, GPIO.HIGH);
  }
  if (btnEco.hasReleased()) {
    println("Eco Mode: ESP Off");
    text_mode = "ECO";
    text_level = "1";
    pwmFan.set(period, 0.25);
    GPIO.digitalWrite(pinESP, GPIO.LOW);
  }
  for (int i=0; i<btnPower.length; i++) {
    if (btnPower[i].hasReleased()) {
      int level = i+1;
      println("Fan level " + str(level));
      text_mode = "MANUAL";
      text_level = str(level);
      pwmFan.set(period, (level*0.25));
    }
  }
}
