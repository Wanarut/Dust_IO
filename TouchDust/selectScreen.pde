long timeout = 50000;
gifButton btnMode, btnTimer;

void select_screen() {
  background(0);
  long cur_mil = millis();
  if (cur_mil - prev_mil >= timeout) {
    cur_screen = 0;
  }
  btnMode.display();
  btnTimer.display();
}

void setBtn() {
  String[] files;
  files = new String[] { 
    "btn/blue.gif", "btn/purple.gif", "btn/sky.gif"
  };
  btnMode = new gifButton(this, width/2-200, height/2, 300, 300, files);
  btnMode.text = "MODE";
  btnTimer = new gifButton(this, width/2+200, height/2, 300, 300, files);
  btnTimer.text = "TIMER";
}
