class gifButton {
  private Gif image_off;
  private Gif image_over;
  private Gif image_down;
  Gif cur_gif;
  String text = "button";
  private int mouse_state = 0;
  private int xpos_, ypos_, w_, h_;
  gifButton(PApplet parent, int xpos, int ypos, int w, int h, String[] file) {
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
  }

  void display() {
    switch(mouse_state){
      case 0: {
        cur_gif = image_off;
        break;
      }
      case 1: {
        cur_gif = image_over;
        break;
      }
      case 2: {
        cur_gif = image_down;
        break;
      }
      default:{
        cur_gif = image_off;
        break;
      }
    }
    rect(xpos_-w_/2, ypos_-h_/2, w_, h_);
    image(cur_gif, xpos_, ypos_, w_, h_);
    textSize(45);
    text(text, xpos_, ypos_);
  }

  boolean hasClicked() {
    boolean clicked = (mouseX > xpos_-w_/2 & 
      mouseX < xpos_+w_/2 & 
      mouseY > ypos_-h_/2 & 
      mouseY < ypos_+h_/2);
    if (clicked) {
      mouse_state = 2;
    }
    return clicked;
  }

  void hasReleased() {
    mouse_state = 0;
  }
  
  void hasMoved(){
    boolean moved = (mouseX > xpos_-w_/2 & 
      mouseX < xpos_+w_/2 & 
      mouseY > ypos_-h_/2 & 
      mouseY < ypos_+h_/2);
    if (moved) {
      mouse_state = 1;
    }else{
      mouse_state = 0;
    }
  }
}
