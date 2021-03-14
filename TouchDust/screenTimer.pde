Button add, del, set, clear, cancel;
int time_hour, time_min;

void timer_setBtn() {
  add = new Button(width/2-300, int(height*0.3), 100, 150, 100, color(255,255,255));
  add.text = "+";
  del = new Button(width/2+300, int(height*0.3), 100, 150, 100, color(255,255,255));
  del.text = "-";
  
  time_hour = 0;
  time_min = 0;
  
  set = new Button(width/4-50, int(height*0.7), 220, 80, 50, color(0,255,0));
  set.text = "SET";
  clear = new Button(2*width/4, int(height*0.7), 220, 80, 50, color(255,0,0));
  clear.text = "CLEAR";
  cancel = new Button(3*width/4+50, int(height*0.7), 220, 80, 50, color(200,200,200));
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
  text(str(time_hour) + " : " + str(time_min), width/2, int(height*0.3));
}