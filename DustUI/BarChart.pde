BarChart hubar;
BarChart tebar;

class BarChart{
  color c;
  int ini_pos[] = new int[2];
  int end_pos[] = new int[2];
  int num_bar;
  int size[] = new int [2];
  boolean vertical;
  
  BarChart(color c, int num_bar, int s, int ini_posx, int ini_posy, int end_posx, int end_posy, boolean vertical) {
    this.c = c;
    this.num_bar = num_bar;
    this.ini_pos[0] = ini_posx;
    this.ini_pos[1] = ini_posy;
    this.end_pos[0] = end_posx;
    this.end_pos[1] = end_posy;
    this.vertical = vertical;
    
    if (vertical) {
      this.size[0] = s;
      this.size[1] = (ini_posy - end_posy)/num_bar;
    }else {
      this.size[0] = (end_posx - ini_posx)/num_bar;
      this.size[1] = s;
    }
  }
  
  void display(int value, int min, int max) {
    float level = float(value)/(max - min);
    level *= num_bar;
    stroke(255);
    strokeWeight(3);
    if (vertical) {
      for(int i = 0; i < num_bar; i++) {
        if (i >= level) break;
        //fill(i*(255/num_bar));
        //fill(red(c), green(c), blue(c));
        fill(i*(red(c)/num_bar), i*(green(c)/num_bar), i*(blue(c)/num_bar));
        rect(ini_pos[0], ini_pos[1] - size[1]*i, size[0], size[1]);
      }
    }else {
      for(int i = 0; i < num_bar; i++) {
        if (i >= level) break;
        fill(i*(red(c)/num_bar), i*(green(c)/num_bar), i*(blue(c)/num_bar));
        rect(ini_pos[0] + size[1]*i, ini_pos[1], size[0], size[1]);
      }
    }
  }
}
