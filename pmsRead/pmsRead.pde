import deadpixel.command.*;

void setup()
{
  // On Mac OSX or Linux
  String pythonPath = sketchPath("pmsRead.py");
  Command cmd = new Command("python3 " + pythonPath); 
  if ( cmd.run() == true ) {
    // peachy
    String[] output = cmd.getOutput(); 
    println(output[0].split(" "));
  } 

  // The Windows equivalent:
  // String pythonPath = sketchPath("myBatchFile.bat");   
  // Command cmd = new Command("cmd.exe /c " + pythonPath);
}

void draw()
{
}
