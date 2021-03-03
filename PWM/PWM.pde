import deadpixel.command.*;

static final String BASH = platform == WINDOWS? "cmd /C " : "bash -c ";

void setup() {

  // On Mac OSX or Linux

  String pythonPath = sketchPath("setPWM.py");
  String pin = " 12";
  String duty = " 50";

  Command cmd = new Command("python " + pythonPath + pin + duty); 
  if ( cmd.run() == true ) {
    // peachy
    String[] output = cmd.getOutput(); 
    println(output);
  } 

  // The Windows equivalent:
  // String pythonPath = sketchPath("myBatchFile.bat");   
  // Command cmd = new Command("cmd.exe /c " + pythonPath);
}

void draw() {
}
