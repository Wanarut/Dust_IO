import gifAnimation.*;
Gif[] emoji = new Gif[6];
Gif cur_emoji;
color colour = color(0, 150, 0);

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
    cur_emoji = emoji[0];
    image(cur_emoji, width/2, height*0.4, 300, 300);

    strokeWeight(15);
    stroke(colour);
    noFill();
    circle(width/2, height*0.4, 350);
  }

  fill(255);
  textSize(60); 
  text("PM 2.5: " + str(pmValue) + " μg/m\u00B3", width/2, height*0.77);
  textSize(16);
  text("MODE AUTO H", width*0.35, height*0.85);
  fill(255, 0, 0);
  text("Filter " + filter_percent + " %", width/2, height*0.85);
}
