class Button {
  String text = "button";
  private int btn_state = 0;
  private color colour_;
  private int cur_color;
  private int xpos_, ypos_, w_, h_, tsize_;
  
  Button(int xpos, int ypos, int w, int h, int tsize, color colour) {
    xpos_ = xpos;
    ypos_ = ypos;
    w_ = w;
    h_ = h;
    tsize_ = tsize;
    colour_ = colour;
    cur_color = 255;
  }

  void display() {
    noFill();
    strokeWeight(15);
    stroke(colour_);
    rect(xpos_, ypos_, w_, h_);
    textSize(tsize_);
    fill(cur_color);
    text(text, xpos_, ypos_-5);
  }

  boolean hasPressed() {
    boolean pressed = (mouseX > xpos_-w_/2 & 
      mouseX < xpos_+w_/2 & 
      mouseY > ypos_-h_/2 & 
      mouseY < ypos_+h_/2);
    if (pressed) {
      btn_state = 2;
      cur_color = 128;
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
      cur_color = 255;
    }
    return released;
  }
}
