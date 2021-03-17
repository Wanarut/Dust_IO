gifButton btnMode, btnTimer;

void select_setBtn() {
  btnMode = new gifButton(this, width/2-200, height/2, 300, 300, 45, color(255,255,255), "btn/blue.gif", "btn/purple.gif");
  btnMode.text = "MODE";
  btnTimer = new gifButton(this, width/2+200, height/2, 300, 300, 45, color(255,255,255), "btn/blue.gif", "btn/purple.gif");
  btnTimer.text = "TIMER";
}

void screen_select() {
  background(0);
  btnMode.display();
  btnTimer.display();
}
