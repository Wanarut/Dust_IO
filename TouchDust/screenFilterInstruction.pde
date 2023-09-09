Button btnNext;
PImage instuction;

void changefilter_setBtn() {
    btnNext = new Button(width - 125, height - 75, 150, 50, 30, color(128));
    btnNext.text = "NEXT";
    btnNext.weight = 5;

    instuction = loadImage("logo/hepa.jpg");
}

static final String label_changefilter = "Please change the air filter";
static final String label_changefilter_th = "กรุณาเปลี่ยนแผ่นกรองอากาศ";

void screen_changefilter() {
    background(255);
    image(instuction, width / 2, height / 2 + 50, 500, 400);
    fill(255, 0, 0);
    textFont(font_regu);
    textSize(50);
    text(label_changefilter, width / 2, height * 0.1);
    textFont(font_thai);
    text(label_changefilter_th, width / 2, height * 0.18);
    // btnNext.display();
    textAlign(RIGHT);
    text(label_contact_th, width * 0.98, height * 0.97);
    textAlign(CENTER, CENTER);
}  
