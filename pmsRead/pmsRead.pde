import deadpixel.command.*;

void setup()
{
  // On Mac OSX or Linux
  String pythonPath = sketchPath("pmsRead.py");
  Command cmd = new Command("python " + pythonPath); 
  if ( cmd.run() == true ) {
    // peachy
    String[] output = cmd.getOutput(); 
    println(output);
  } 

  // The Windows equivalent:
  // String pythonPath = sketchPath("myBatchFile.bat");   
  // Command cmd = new Command("cmd.exe /c " + pythonPath);
}

void draw()
{
}
