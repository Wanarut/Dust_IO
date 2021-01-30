/*
Volume and Position
Press ENTER, SPACE and CURSOR KEYS
*/

import VLCJVideo.*;

VLCJVideo video;

int video_position[] = new int[2];
int video_size[] = new int[2];

void keyPressed() {
  if(key == ' ') {
    video.pause();
  }
  if(keyCode == ENTER) {
    if(video.isPlaying()) video.stop();
    else video.play();
  }
  if(keyCode == UP) {
    video.setVolume(video.volume() + 10);
  }
  if(keyCode == DOWN) {
    video.setVolume(video.volume() - 10);
  }
  if(keyCode == LEFT) {
    video.setTime(video.time() - 5000);
  }
  if(keyCode == RIGHT) {
    video.setTime(video.time() + 5000);
  }
  if(key == 'm') {
    video.setMute(!video.isMute());
  }
}

void set_video_dimention() {
  video_position[0] = width/2;
  video_position[1] = int((height/2) + (height*0.1));
  video_size[0] = int(width*0.8);
  video_size[1] = int(height*0.8);
}
