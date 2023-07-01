import gifAnimation.*;

PImage[] emoji = new PImage[5];
Gif emoji_5;
int gif_i = 0;
color circle_c = color(59, 204, 255);
String text_mode = "AUTO";
String text_level = "2";

void setupGif() {
  emoji[0] = loadImage("Emoji/Emoji_1.png");
  emoji[1] = loadImage("Emoji/Emoji_2.png");
  emoji[2] = loadImage("Emoji/Emoji_3.png");
  emoji[3] = loadImage("Emoji/Emoji_4.png");
  emoji[4] = loadImage("Emoji/Emoji_5.png");
  emoji_5 = new Gif(this, "Emoji/water.gif");

  emoji_5.loop();
  
}

void main_screen() {
  background(0);

  if (dirty) {
    image(emoji_5, width/2, height*0.4, 580, 435);
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
  fill(255);
  text("Filter " + filter_lifetime + " %", width/2, height*0.85);
  fill(255);
  text("FAN LEVEL " + text_level, width*0.65, height*0.85);
}

void select_emoji() {
  gif_i = 0;
  circle_c = color(0, 255, 0);
  if (pm_inValue>12) {
    gif_i = 1;
    circle_c = color(36, 202, 220);
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
