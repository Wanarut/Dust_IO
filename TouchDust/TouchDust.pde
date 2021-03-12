import g4p_controls.*;

int screens[] = {0, 1, 2, 3, 4};
int cur_screen = 1;
long prev_mil = 0;
public void setup() {
  size(1024, 600);
  G4P.setCtrlMode(GControlMode.CENTER);

  setupPin();
  setupGif();
  setBtn();
}

public void draw() {
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
  case 3:
  case 4:
  default:
  }
}

void mousePressed() {
  //Set the screen when whatever happens that you want to happen
  prev_mil = millis();
  switch(cur_screen) {
  case 0: 
    {
      cur_screen = 1;
      break;
    }
  case 1:
    {
      btnMode.hasClicked();
      btnTimer.hasClicked();
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
      btnMode.hasReleased();
      btnTimer.hasReleased();
      break;
    }
  }
}

void mouseMoved() {
  switch(cur_screen) {
  case 0: 
    {
      cur_screen = 1;
      break;
    }
  case 1:
    {
      btnMode.hasMoved();
      btnTimer.hasMoved();
      break;
    }
  }
}
