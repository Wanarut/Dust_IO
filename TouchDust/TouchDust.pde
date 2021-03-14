import g4p_controls.*;

long timeout = 15000;
int cur_screen = 0;
long prev_mil = 0;

public void setup() {
  size(1024, 600);
  G4P.setCtrlMode(GControlMode.CENTER);
  rectMode(CENTER);
  imageMode(CENTER);
  textAlign(CENTER, CENTER);

  setupPin();
  setupGif();
  select_setBtn();
  mode_setBtn();
  timer_setBtn();
}

public void draw() {
  long cur_mil = millis();
  if (cur_mil - prev_mil >= timeout) {
    cur_screen = 0;
  }
  switch(cur_screen) {
  case 0:
    {
      main_screen();
      break;
    }
  case 1:
    {
      screen_select();
      break;
    }
  case 2:
    {
      screen_mode();
      break;
    }
  case 3:
    {
      screen_timer();
      break;
    }
  }
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
        println("Hi Mode");
      }
      if (btnEco.hasReleased()) {
        println("Eco Mode");
      }
      for (int i=0; i<btnPower.length; i++) {
        if (btnPower[i].hasReleased()) {
          println("Fan level " + str(i+1));
        }
      }
      break;
    }
  case 3:
    {
      if (add.hasReleased()) {
        time_min += 30;
        time_min %= 60;
        if (time_min==0) {
          time_hour++;
          time_hour%=24;
        }
      }
      if (del.hasReleased()) {
        if (time_min==0) {
          time_hour--;
          if (time_hour < 0) time_hour=23;
          time_hour%=24;
        }
        time_min += 30;
        time_min %= 60;
      }
      if (set.hasReleased()) {
      }
      if (clear.hasReleased()) {
      }
      if (cancel.hasReleased()) {
        cur_screen = 0;
      }
      break;
    }
  }
}
