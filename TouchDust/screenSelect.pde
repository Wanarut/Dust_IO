gifButton btnMode, btnTimer;
Button btnShutdown;

void select_setBtn() {
  btnMode = new gifButton(this, width/2-200, height/2, 300, 300, 45, color(255,255,255), "btn/blue.gif", "btn/purple.gif");
  btnMode.text = "MODE";
  btnTimer = new gifButton(this, width/2+200, height/2, 300, 300, 45, color(255,255,255), "btn/blue.gif", "btn/purple.gif");
  btnTimer.text = "TIMER";
  btnShutdown = new Button(int(width*0.8), int(height*0.9), 220, 80, 35, color(200, 200, 200));
  btnShutdown.text = "Shutdown";
  
}

void screen_select() {
  background(0);
  btnMode.display();
  btnTimer.display();
  btnShutdown.display();
}  
