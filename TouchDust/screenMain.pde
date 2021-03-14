import gifAnimation.*;
Gif[] emoji = new Gif[6];
Gif cur_emoji;
color circle_c = color(59, 204, 255);

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
    image(emoji[5], width/2, height*0.4, 480*1.2, 360*1.2);
    fill(255);
    textSize(40); 
    text("PLEASE\nCLEAN UP", width/2, height*0.4);
  } else {
    select_emoji();
    image(cur_emoji, width/2, height*0.4, 300, 300);

    strokeWeight(15);
    stroke(circle_c);
    noFill();
    circle(width/2, height*0.4, 350);
  }

  fill(255);
  textSize(60); 
  text("PM 2.5: " + str(pm_inValue) + " μg/m\u00B3", width/2, height*0.77);
  textSize(16);
  text("MODE AUTO H", width*0.35, height*0.85);
  fill(255, 0, 0);
  text("Filter " + filter_percent + " %", width/2, height*0.85);
}

void select_emoji() {
  cur_emoji = emoji[0];
  circle_c = color(59, 204, 255);
  if (pm_inValue>12) {
    cur_emoji = emoji[1];
    circle_c = color(146, 208, 80);
  }
  if (pm_inValue>35) {
    cur_emoji = emoji[2];
    circle_c = color(255, 255, 0);
  }
  if (pm_inValue>55) {
    cur_emoji = emoji[3];
    circle_c = color(255, 162, 0);
  }
  if (pm_inValue>250) {
    cur_emoji = emoji[4];
    circle_c = color(255, 59, 59);
  }
  pm_inValue++;
  pm_inValue%=300;
}