long timeout = 5000;
gifButton btnMode, btnTimer;

void select_screen() {
  background(0);
  long cur_mil = millis();
  if (cur_mil - prev_mil >= timeout) {
    cur_screen = 0;
  }
  btnMode.draw();
}

void setBtn(){
  String[] files;
  files = new String[] { 
    "btn/149b53dcfb58393e2055800180cacaa5.gif", "btn/a177dfc84703c31afa0d501ccf43fe4f.gif", "btn/original.gif"
  };
  btnMode = new gifButton(this, width/2, height/2, files);
}
