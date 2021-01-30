PFont PMFont;
PFont NYFont;
PFont UnFont;

int pm_position[] = new int[4];
int ny_position[] = new int[4];
int un_position[] = new int[4];

void set_font() {
  //printArray(PFont.list());
  PMFont = createFont("PibotoLt-Bold", height*0.15, true);
  pm_position[0] = int(banner_position[0]*0.86);
  pm_position[1] = int(banner_position[1]*0.8);
  
  NYFont = createFont("PibotoLt-Regular", height*0.07, true);
  ny_position[0] = (width - video_size[0])/4;
  ny_position[1] = int(height*0.9);
  
  ny_position[2] = 3*ny_position[0] + video_size[0];
  ny_position[3] = ny_position[1];
  
  UnFont = createFont("PibotoLt-Regular", height*0.04, true);
  un_position[0] = int(banner_position[0]);
  un_position[1] = int(banner_position[1]*1.35);
}
