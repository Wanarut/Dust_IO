Button btnNext;
PImage instuction;

void changefilter_setBtn() {
    btnNext = new Button(width - 125, height - 75, 150, 50, 30, color(128));
    btnNext.text = "NEXT";
    btnNext.weight = 5;

    instuction = loadImage("logo/hepa.jpg");
}

void screen_changefilter() {
    background(255);
    image(instuction, width / 2, height / 2 + 50, 500, 400);
    fill(255, 0, 0);
    textSize(50);
    text("Please change the air filter", width / 2, height * 0.1);
    textFont(font_thai);
    text("กรุณาเปลี่ยนแผ่นกรองอากาศ", width / 2, height * 0.18);
    btnNext.display();
}  
