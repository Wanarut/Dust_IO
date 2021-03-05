import deadpixel.command.*;

void setup() {

  // On Mac OSX or Linux

  String pythonPath = sketchPath("setPWM.py");
  String pin = " 18";
  String duty = " 50";

  Command cmd = new Command("python " + pythonPath + pin + duty); 
  if ( cmd.run() == true ) {
    // peachy
    String[] output = cmd.getOutput(); 
    println(output);
  }
}

void draw() {
}
