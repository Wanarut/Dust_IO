int timeout = 15000;
int cur_screen = 0;
int prev_mil = 0;
int counter_prev_mil = 0;
int prev_read_mil = 0;

public void setup() {
  size(1024, 600);
  G4P.setCtrlMode(GControlMode.CENTER);
  rectMode(CENTER);
  imageMode(CENTER);
  textAlign(CENTER, CENTER);
  //frameRate(10);

  setupPin();
  setupGif();
  select_setBtn();
  mode_setBtn();
  timer_setBtn();
}

public void draw() {
  int cur_mil = millis();
  if (cur_mil - prev_mil >= timeout & cur_screen != 3) {
    cur_screen = 0;
    prev_mil = cur_mil;
  }
  if (cur_mil - prev_read_mil >= 5000) {
    //readPMvalue();
    prev_read_mil = cur_mil;
  }
  if (start_count & cur_mil - counter_prev_mil>= 1000) {
    if (time_min>0) {
      time_min--;
      pm_inValue-=10;
    } else {
      println("Timer End");
      text_mode = "OFF";
      text_level = "0";
      //pwmFan.set(period, 0);
      //GPIO.digitalWrite(pinESP, GPIO.LOW);
      start_count = false;
    }
    counter_prev_mil = cur_mil;
  }
  if (cur_screen==0) main_screen();
  if (cur_screen==1) screen_select();
  if (cur_screen==2) screen_mode();
  if (cur_screen==3) screen_timer();
}

void mousePressed() {
  //Set the screen when whatever happens that you want to happen
  prev_mil = millis();
  switch(cur_screen) {
  case 0: 
    {
      break;
    }
  case 1:
    {
      btnMode.hasPressed();
      btnTimer.hasPressed();
      break;
    }
  case 2:
    {
      btnHi.hasPressed();
      btnEco.hasPressed();
      for (int i=0; i<btnPower.length; i++) {
        btnPower[i].hasPressed();
      }
      break;
    }
  case 3:
    {
      add.hasPressed();
      del.hasPressed();
      set.hasPressed();
      clear.hasPressed();
      cancel.hasPressed();
      break;
    }
  }
}

void mouseReleased() {
  switch(cur_screen) {
  case 0: 
    {
      cur_screen = 1;
      break;
    }
  case 1:
    {
      if (btnMode.hasReleased()) {
        cur_screen = 2;
      }
      if (btnTimer.hasReleased()) {
        cur_screen = 3;
      }
      break;
    }
  case 2:
    {
      if (btnHi.hasReleased()) {
        println("Hi Mode: ESP On");
        text_mode = "HI";
        text_level = "4";
        //pwmFan.set(period, 1.0);
        //GPIO.digitalWrite(pinESP, GPIO.HIGH);
      }
      if (btnEco.hasReleased()) {
        println("Eco Mode: ESP Off");
        text_mode = "ECO";
        text_level = "1";
        //pwmFan.set(period, 0.25);
        //GPIO.digitalWrite(pinESP, GPIO.LOW);
      }
      for (int i=0; i<btnPower.length; i++) {
        if (btnPower[i].hasReleased()) {
          int level = i+1;
          println("Fan level " + str(level));
          text_mode = "MANUAL";
          text_level = str(level);
          //pwmFan.set(period, (level*0.25));
        }
      }
      break;
    }
  case 3:
    {
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
      break;
    }
  }
}
