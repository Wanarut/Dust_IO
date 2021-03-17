class gifButton {
  private Gif image_off;
  private Gif image_down;
  String text = "button";
  private int btn_state = 0;
  private color colour_;
  private int xpos_, ypos_, w_, h_, tsize_;

  gifButton(PApplet parent, int xpos, int ypos, int w, int h, int tsize, color colour, String file1, String file2) {
    image_off = new Gif(parent, file1);
    image_down = new Gif(parent, file2);
    image_off.loop();
    image_down.loop();
    xpos_ = xpos;
    ypos_ = ypos;
    w_ = w;
    h_ = h;
    tsize_ = tsize;
    colour_ = colour;
  }

  void display() {
    if (btn_state==1) {
      image(image_down, xpos_, ypos_, w_, h_);
      fill(128);
    } else {
      image(image_off, xpos_, ypos_, w_, h_);
      fill(colour_);
    }
    textSize(tsize_);
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
