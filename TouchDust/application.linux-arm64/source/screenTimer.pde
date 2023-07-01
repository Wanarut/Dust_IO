Button add, del, set, clear, cancel;
int time_min;
boolean start_count = false;

void timer_setBtn() {
  add = new Button(width/2-300, int(height*0.3), 100, 150, 100, color(255, 255, 255));
  add.text = "+";
  del = new Button(width/2+300, int(height*0.3), 100, 150, 100, color(255, 255, 255));
  del.text = "-";

  time_min = 0;

  set = new Button(width/4-50, int(height*0.7), 220, 80, 50, color(0, 255, 0));
  set.text = "SET";
  clear = new Button(2*width/4, int(height*0.7), 220, 80, 50, color(255, 0, 0));
  clear.text = "CLEAR";
  cancel = new Button(3*width/4+50, int(height*0.7), 220, 80, 50, color(200, 200, 200));
  cancel.text = "CANCEL";
}

void screen_timer() {
  background(0);
  add.display();
  del.display();
  set.display();
  clear.display();
  cancel.display();

  textSize(100);
  fill(255);
  String hour = str(time_min / 60);
  String min = str(time_min % 60);
  text(hour + " : " + min, width/2, int(height*0.3));
}

void calculatetime() {
  if (add.hasReleased()) {
    time_min += 30;
  }
  if (del.hasReleased()) {
    time_min -= 30;
    if (time_min<0) time_min=0;
  }
  if (set.hasReleased()) {
    start_count = true;
    counter_prev_mil = millis();
  }
  if (clear.hasReleased()) {
    start_count = false;
    time_min=0;
  }
  if (cancel.hasReleased()) {
    cur_screen = 0;
  }
}
