class Button {
    private PImage image;
    private PImage image_active;
    String text = "";
    private int btn_state = 0;
    private color colour_;
    private int xpos_, ypos_, w_, h_, tsize_;
    int weight = 0;
    PFont font;
    
    // construction with image
    Button(int xpos, int ypos, int w, int h, int tsize, color colour, String file) {
        xpos_ = xpos;
        ypos_ = ypos;
        w_ = w;
        h_ = h;
        tsize_ = tsize;
        colour_ = colour;

        font = createFont("Fira_Sans/FiraSans-Regular.ttf", tsize_);

        image = loadImage(file);
        image_active = loadImage(file);
        image_active.filter(POSTERIZE, 5);
    }
    
    // construction with out image
    Button(int xpos, int ypos, int w, int h, int tsize, color colour) {
        xpos_ = xpos;
        ypos_ = ypos;
        w_ = w;
        h_ = h;
        tsize_ = tsize;
        colour_ = colour;
        
        font = createFont("Fira_Sans/FiraSans-Regular.ttf", tsize_);
    }

    void setImage(PImage cur_image) {
        image = cur_image;
        image_active = cur_image;
        image_active.filter(POSTERIZE, 5);
    }
    
    void display() {
        // add stroke in button
        if (weight > 0) {
            noFill();
            strokeWeight(weight);
            stroke(colour_);
            rect(xpos_, ypos_, w_, h_, 8);
        }
        // display image
        if (image != null) {
            if (btn_state ==  1) {
                image(image_active, xpos_, ypos_, w_, h_);
            } else {
                image(image, xpos_, ypos_, w_, h_);
            }
        }
        // display text
        if (btn_state ==  1) fill(128);
        else fill(0);
        textFont(font);
        text(text, xpos_, ypos_ - 3);
    }
    
    boolean hasPressed() {
        boolean pressed = (mouseX > xpos_ - w_ / 2 & 
            mouseX< xpos_ + w_ / 2 & 
            mouseY> ypos_ - h_ / 2 & 
            mouseY< ypos_ + h_ / 2);
        if (pressed) {
            btn_state = 1;
        }
        return pressed;
    }
    
    boolean hasReleased() {
        boolean released = (mouseX > xpos_ - w_ / 2 & 
            mouseX< xpos_ + w_ / 2 & 
            mouseY> ypos_ - h_ / 2 & 
            mouseY< ypos_ + h_ / 2);
        if (released) {
            btn_state = 0;
        }
        return released;
    }
}
