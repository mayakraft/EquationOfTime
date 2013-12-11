int WIDTH = 1024;
int HEIGHT = 512;
int centerX1 = (int)(WIDTH*.5);
int centerY1 = (int)(WIDTH*.5);
int SIZE = 10;
int count = 0;

float longitude = 45.559636;
float latitude = -122.691397;

float zenith, azimuth;

int hour = 0;
int minute = 0;
int day = 343;
int xOffset = 50;

void setup(){
  size((int)(WIDTH/2.+xOffset*2),HEIGHT);
  stroke(0);
  strokeWeight(0); 
  fill(255);  
  background(255);
}

void update(){
  solarPositionAtLatitude(latitude, longitude, day, hour, minute, 0);
}

void drawYearCurve(){
  int segments = 12;
  int jump = 2;
    solarPositionAtLatitude(latitude, longitude, day, 1*jump, minute, 0);
  float azimuth0 = azimuth;
  float zenith0 = zenith;
  for(int i = 1; i <= segments+1; i++){
    fill(242,229,129);
    if( (i) % 6 == 1)
      fill(242,24,129);   
    if( day > 250 )
      fill(42,224,29);   
    solarPositionAtLatitude(latitude, longitude, day, (i%12)*jump, minute, 0);
    if(i < segments+1){
      ellipse(xOffset + (azimuth)/720*WIDTH+WIDTH/4., HEIGHT-((zenith)/PI*HEIGHT), SIZE, SIZE);
      line(xOffset + (180+azimuth0)/720*WIDTH, HEIGHT-((zenith0)/PI*HEIGHT), 
           xOffset + (180+azimuth)/720*WIDTH, HEIGHT-((zenith)/PI*HEIGHT) );
       azimuth0 = azimuth;
       zenith0 = zenith;
    }
    else{
       ellipse(xOffset + (azimuth)/720*WIDTH+WIDTH/4., HEIGHT-((zenith)/PI*HEIGHT), SIZE, SIZE);
     line(xOffset + (180+azimuth0)/720*WIDTH, HEIGHT-((zenith0)/PI*HEIGHT), 
           xOffset + (180+azimuth)/720*WIDTH, HEIGHT-((zenith)/PI*HEIGHT) );
       azimuth0 = azimuth;
       zenith0 = zenith;
    }
  }
}
void draw(){
  
//  update();
  // draw
  background(255);
  strokeWeight(1); 
  line(0,HEIGHT/2.,WIDTH,HEIGHT/2.);
  strokeWeight(SIZE*.1);
//  fill(0);

//  textSize(32);
//  text(year, 10, 30); 
  
  drawYearCurve();
  
  day+=2;
  if(day >= 365.25){
    day = 0;
  }
//  minute+=3;
//  if(minute >= 60){
//    hour++;
//    minute = 0;
//    if(hour >= 24) hour = 0;
//  }

//  fill(colors[3*zindex[i]+0],colors[3*zindex[i]+1],colors[3*zindex[i]+2]);
//  if(centerX1 - planetsY[zindex[i]]*ZOOM < WIDTH)  // prevent overlap from the 1st screen to the 2nd
//    ellipse(centerX1 - planetsX[zindex[i]]*ZOOM, centerY1 + planetsY[zindex[i]]*ZOOM, SIZE, SIZE);
//  ellipse(centerX2 - planetsX[zindex[i]]*ZOOM, centerY2 + planetsZ[zindex[i]]*ZOOM, SIZE, SIZE);
}

// longitude is in degrees, 
void solarPositionAtLatitude(float latitude, float longitude, int day, int hour, int minute, int second){
    int timezone = 1;
    float y = 2*PI/356 * (day-1 + (hour-12)/24.);
    float eqtime = 229.18 * (0.000075 + 0.001868*cos(y) - 0.032077*sin(y) - 0.014615*cos(2*y) - 0.040849 * sin(2*y) );
    float decl = 0.006918 - 0.399912*cos(y) + 0.070257 * sin(y) - 0.006758 * cos(2*y) + 0.000907 * sin(2*y) - 0.002697 * cos(3*y) + 0.00148 * sin(3*y);
    float time_offset = eqtime - 4 * longitude + 60 * timezone;
    float tst = hour * 60 + minute + second / 60. + time_offset;  // in minutes
    float ha = tst/4. - 180;
    float zenithRight = (sin(latitude*PI/180.) * sin(decl) + cos(latitude*PI/180.) * cos(decl) * cos(ha*PI/180.));
    zenith = acos( zenithRight );
    float azimuthRight = (sin(latitude*PI/180.) * cos(zenith) - sin(decl) ) 
                                      /
                      (cos(latitude*PI/180.) * sin(zenith) );
//    if(hour >= 14 || hour <= 1)
//      azimuth = 180+acos(-azimuthRight)/PI*360.;
//    else 
      azimuth = 180-acos( -azimuthRight )/PI*365.;
      //if( (hour/2.) % 6 == 1)
      if( hour/2. == 1)
        println(sin(latitude*PI/180.) + " * " + cos(zenith) + " - " +  sin(decl) + " / " + cos(latitude*PI/180.) + " * " +  sin(zenith));
//        println(sin(latitude*PI/180.) + " * " + sin(decl) + " + " + cos(latitude*PI/180.) + " * " + cos(decl) + " * " +  cos(ha*PI/180.));
//      println(hour + "    " + zenithRight + "    " + acos(zenithRight)/PI*360. + "   ::    " + -azimuthRight + "    " + acos(-azimuthRight)/PI*360.);
      
      if(count%10 == 0)
      {
        if(zenithRight < -PI/2. || zenithRight > PI/2.)
          println("ZENITH" + zenithRight);
        if(azimuthRight < -PI/2. || azimuthRight > PI/2.)
          println("AZIMUTH  " + azimuthRight);
//          println(day + " Azimuth: " + azimuth + "      Zenith: " + zenith);
      //    println(day + 
      }
//      count++;
//      println(ha + "        " + tst/4.);
//      if(hour == 14)
//        println("ZENITH" + zenithRight + "      AZIMUTH  " + azimuthRight);
}

void mouseWheel(MouseEvent event) {

}

void mouseClicked(){

}

