import gifAnimation.*;

Gif[] emoji = new Gif[6];
int gif_i = 0;
color circle_c = color(59, 204, 255);
String text_mode = "AUTO";
String text_level = "2";

void setupGif() {
  emoji[0] = new Gif(this, "emoji/face-yellow-loop-02.gif");
  emoji[1] = new Gif(this, "emoji/face-yellow-loop-36.gif");
  emoji[2] = new Gif(this, "emoji/face-yellow-loop-SAd.gif");
  emoji[3] = new Gif(this, "emoji/face-yellow-loop-34.gif");
  emoji[4] = new Gif(this, "emoji/face-yellow-loop-35.gif");
  emoji[5] = new Gif(this, "emoji/water.gif");

  for (int i=0; i<emoji.length; i++) {
    emoji[i].loop();
  }
}

void main_screen() {
  background(0);

  if (dirty) {
    image(emoji[5], width/2, height*0.4, 580, 435);
    fill(255);
    textSize(40); 
    text("PLEASE\nCLEAN UP", width/2, height*0.4);
  } else {
    select_emoji();
    image(emoji[gif_i], width/2, height*0.4, 300, 300);

    strokeWeight(15);
    stroke(circle_c);
    noFill();
    circle(width/2, height*0.4, 350);
  }

  fill(255);
  textSize(60); 
  text("PM 2.5: " + str(pm_inValue) + " μg/m\u00B3", width/2, height*0.77);
  textSize(16);
  text("MODE " + text_mode, width*0.35, height*0.85);
  fill(255, 0, 0);
  text("Filter " + filter_lifetime + " %", width/2, height*0.85);
  fill(255);
  text("FAN LEVEL " + text_level, width*0.65, height*0.85);
}

void select_emoji() {
  gif_i = 0;
  circle_c = color(59, 204, 255);
  if (pm_inValue>12) {
    gif_i = 1;
    circle_c = color(146, 208, 80);
  }
  if (pm_inValue>35) {
    gif_i = 2;
    circle_c = color(255, 255, 0);
  }
  if (pm_inValue>55) {
    gif_i = 3;
    circle_c = color(255, 162, 0);
  }
  if (pm_inValue>250) {
    gif_i = 4;
    circle_c = color(255, 59, 59);
  }
}
