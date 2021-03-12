class gifButton {
  private Gif image_off;
  private Gif image_over;
  private Gif image_down;
  private Gif cur_gif;
  String text = "button";
  private int btn_state = 0;
  private color colour_;
  private color cur_color;
  private int xpos_, ypos_, w_, h_, tsize_;
  
  gifButton(PApplet parent, int xpos, int ypos, int w, int h, int tsize, color colour, String[] file) {
    image_off = new Gif(parent, file[0]);
    image_over = new Gif(parent, file[1]);
    image_down = new Gif(parent, file[2]);
    image_off.loop();
    image_over.loop();
    image_down.loop();
    xpos_ = xpos;
    ypos_ = ypos;
    w_ = w;
    h_ = h;
    cur_gif = image_off;
    tsize_ = tsize;
    colour_ = colour;
    cur_color = colour;
  }

  void display() {
    switch(btn_state) {
    case 0: 
      {
        cur_gif = image_off;
        break;
      }
    case 1: 
      {
        cur_gif = image_over;
        break;
      }
    case 2: 
      {
        cur_gif = image_down;
        break;
      }
    default:
      {
        cur_gif = image_off;
        break;
      }
    }
    //rect(xpos_-w_/2, ypos_-h_/2, w_, h_);
    image(cur_gif, xpos_, ypos_, w_, h_);
    textSize(tsize_);
    fill(cur_color);
    text(text, xpos_, ypos_);
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
      cur_color = colour_;
    }
    return released;
  }
}
