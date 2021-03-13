gifButton btnHi, btnEco;
gifButton btnPower[] = new gifButton[4];

void mode_setBtn() {
  String[] files;
  files = new String[] { 
    "btn/winkle.gif", "btn/sky.gif", "btn/purple.gif"
  };
  btnHi = new gifButton(this, width/2-200, int(height*0.4), 300, 300, 80, color(255, 0, 0), files);
  btnHi.text = "Hi";
  files = new String[] { 
    "btn/sky.gif", "btn/sky.gif", "btn/purple.gif"
  };
  btnEco = new gifButton(this, width/2+200, int(height*0.4), 300, 300, 80, color(0, 255, 0), files);
  btnEco.text = "Eco";
  files = new String[] { 
    "btn/white.gif", "btn/sky.gif", "btn/purple.gif"
  };
  for (int i=0; i<btnPower.length; i++) {
    btnPower[i] = new gifButton(this, (i+1)*(width/5), int(height*0.8), 75, 75, 40, color(255, 255, 255), files);
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
