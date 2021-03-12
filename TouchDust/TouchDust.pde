import g4p_controls.*;

long timeout = 15000;
int cur_screen = 0;
long prev_mil = 0;

public void setup() {
  size(1024, 600);
  G4P.setCtrlMode(GControlMode.CENTER);

  setupPin();
  setupGif();
  select_setBtn();
  mode_setBtn();
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
      select_screen();
      break;
    }
  case 2:
    {
      mode_screen();
      break;
    }
  case 3:
    {
      
      break;
    }
  case 4:
    {
      
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
        //cur_screen = 3;
      }
      break;
    }
  case 2:
    {
      btnHi.hasReleased();
      btnEco.hasReleased();
      for (int i=0; i<btnPower.length; i++) {
        btnPower[i].hasReleased();
      }
      break;
    }
  case 3:
    {
      
      break;
    }
  }
}
