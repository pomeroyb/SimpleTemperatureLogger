//Processing Temperature Visualizer




import processing.serial.*;
Serial mySerial;
PrintWriter output;
int baudRate = 115200; //This should match what is on Arduino

int windowWidth = 900;
int windowHeight = 600;
int xPadding = 40;
int yPadding = 20;
int dataBoxWidth = 500;
int dataBoxHeight = 125;

int milliSeconds;
float lastTemp;

void setup(){
  mySerial = new Serial(this,Serial.list()[0],baudRate);
  output = createWriter( "data.txt" );
  lastTemp = 0.0;
  size(windowWidth, windowHeight);
  background(0);
}

void draw(){
  milliSeconds = millis();
    
  drawAxes();
  drawDataBox();
  displayTime();
  displayData(lastTemp);
  displayNoGraph();
  if(mySerial.available() > 0 ) {
    while (mySerial.available() > 0 ) {
           String val = mySerial.readString();
           
           if ( val != null ) {
               float value = float(val);
               displayData(value);
               output.print( value );
               output.print(",");
               output.println(milliSeconds);
               output.flush();
           }
           
      } 
  } else {
    //displayNoSerial();
  }
  
    
  if (keyPressed) {
     if (key == 's') {
       output.flush(); 
       output.close();
       exit();
     } 
  } 
  
}

void displayNoGraph(){
  textSize(34);
  fill(255,0,0); //DANGER RED
  textAlign(CENTER,CENTER);
  text("No graph implemented yet. :(", windowWidth/2, windowHeight/2);
  
}

void displayNoSerial(){
//  String error = "No connection";
//  fill(255,0,0); //DANGER RED
//  textSize(34);
//  textAlign(CENTER,CENTER);
//  text(error, windowWidth-xPadding-dataBoxWidth/2, yPadding + dataBoxHeight/2);

    String error = "No data";
    fill(255,0,0); //DANGER RED
    textSize(24);
    textAlign(CENTER,CENTER);
    text(error, windowWidth-xPadding-dataBoxWidth/2, yPadding + dataBoxHeight/2);
    

}

void displayTime(){
  String time = "Elapsed time: " + milliSeconds/1000;
    fill(32,32,32);
    textSize(24);
    textAlign(LEFT,BOTTOM);
    text(time, windowWidth-xPadding-dataBoxWidth*0.95, yPadding + dataBoxHeight* 0.95);
}

void displayData(float data){
  textSize(24);
  textAlign(LEFT,CENTER);
  text("Temperature: " + data + " C", windowWidth-xPadding-dataBoxWidth*0.95, yPadding + dataBoxHeight/4);
  lastTemp = data;
 // if(data !=null){
  //  float data_f = float(data);
      
    
    
 // } else {
//    String error = "No data";
//    fill(255,0,0); //DANGER RED
//    textSize(24);
//    textAlign(CENTER,CENTER);
//    text(error, windowWidth-xPadding-dataBoxWidth/4, yPadding + dataBoxHeight/4);
//  }

}

void drawDataBox(){
  fill(224,224,224);
  resetMatrix();
  rect( windowWidth-xPadding-dataBoxWidth , yPadding , dataBoxWidth, dataBoxHeight);
  
}

void drawAxes(){

  fill(200);
  rect( xPadding , yPadding ,windowWidth - xPadding*2, windowHeight - yPadding*2);
  
  strokeWeight(2);
  //Y-Axis
  line(xPadding*2, yPadding*2, xPadding*2, (windowHeight - yPadding*2)-yPadding);
  //X-Axis
  line(xPadding*2, (windowHeight - yPadding*2)-yPadding, (windowWidth - xPadding*2)-xPadding, (windowHeight - yPadding*2)-yPadding);
  
  //X-Axis Label
  int axesLabelSize = 24;
  textSize(axesLabelSize);
  textAlign(CENTER, BOTTOM);
  fill(75, 75, 75);
  text("Time (seconds)", windowWidth/2, windowHeight-yPadding);
  
  //Y-Axis Label
  textAlign(CENTER, BOTTOM);
  translate(xPadding, windowHeight/2);
  rotate(HALF_PI);
  text("Temperature (Celsius)", 0, 0);

}
