gifButton btnMode, btnTimer;

void select_setBtn() {
  String[] files;
  files = new String[] { 
    "btn/blue.gif", "btn/sky.gif", "btn/purple.gif"
  };
  btnMode = new gifButton(this, width/2-200, height/2, 300, 300, 45, color(255,255,255), files);
  btnMode.text = "MODE";
  btnTimer = new gifButton(this, width/2+200, height/2, 300, 300, 45, color(255,255,255), files);
  btnTimer.text = "TIMER";
}

void screen_select() {
  background(0);
  btnMode.display();
  btnTimer.display();
}
