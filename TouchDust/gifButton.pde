class gifButton {
  private Gif image_off;
  private Gif image_over;
  private Gif image_down;
  Gif cur_gif;
  String text;
  private int mouse_state = 0;
  private int xpos_, ypos_;
  gifButton(PApplet parent,int xpos, int ypos, String[] file) {
    image_off = new Gif(parent, file[0]);
    image_over = new Gif(parent, file[1]);
    image_down = new Gif(parent, file[2]);
    image_off.loop();
    image_over.loop();
    image_down.loop();
    xpos_ = xpos;
    ypos_ = ypos;
  }
  
  void draw(){
    switch(mouse_state){
      case 0: {
        cur_gif = image_off;
      }
      case 1: {
        cur_gif = image_over;
      }
      case 2: {
        cur_gif = image_down;
      }
      default:{
        cur_gif = image_off;
      }
    }
    image(cur_gif, xpos_, ypos_);
  }
}
