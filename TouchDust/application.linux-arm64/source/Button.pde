class Button {
  String text = "button";
  private int btn_state = 0;
  private color colour_;
  private int xpos_, ypos_, w_, h_, tsize_;

  Button(int xpos, int ypos, int w, int h, int tsize, color colour) {
    xpos_ = xpos;
    ypos_ = ypos;
    w_ = w;
    h_ = h;
    tsize_ = tsize;
    colour_ = colour;
  }

  void display() {
    noFill();
    strokeWeight(15);
    stroke(colour_);
    rect(xpos_, ypos_, w_, h_);
    textSize(tsize_);
    if (btn_state==1) fill(128);
    else fill(255);
    text(text, xpos_, ypos_-5);
  }

  boolean hasPressed() {
    boolean pressed = (mouseX > xpos_-w_/2 & 
      mouseX < xpos_+w_/2 & 
      mouseY > ypos_-h_/2 & 
      mouseY < ypos_+h_/2);
    if (pressed) {
      btn_state = 1;
    }
    return pressed;
  }

  boolean hasReleased() {
    boolean released = (mouseX > xpos_-w_/2 & 
      mouseX < xpos_+w_/2 & 
      mouseY > ypos_-h_/2 & 
      mouseY < ypos_+h_/2);
    if (released) {
      btn_state = 0;
    }
    return released;
  }
}
