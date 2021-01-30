PImage emoji;
PImage emoji_1;
PImage emoji_2;
PImage emoji_3;
PImage emoji_4;
PImage emoji_5;

int banner_position[] = new int[2];
int banner_size[] = new int[2];

void set_banner() {
  banner_size[0] = video_size[0];
  banner_size[1] = height - video_size[1];
  banner_position[0] = video_position[0];
  banner_position[1] = banner_size[1]/2;
}
