int WIDTH = 800;
int HEIGHT = 400;
int MARGIN = 16;
int SIZE = 16;  // sun size
int count = 0;

float longitude = 40;
float latitude = 30;
int h = 0;
int m = 0;
int d = 343;
float zenith, azimuth;

// debugging
int focus = 0;
boolean goForPrint;

void setup(){
  size((int)(WIDTH+MARGIN*2),HEIGHT);
  stroke(0);
  strokeWeight(0); 
  fill(255);  
  background(255);
}

void update(){
  solarPositionAtLatitude(longitude, latitude, d, h, m, 0);
}

void drawYearCurve(){
  int segments = 12;
  int jump = 2;
    solarPositionAtLatitude(longitude, latitude, d, 1*jump, m, 0);
  float azimuth0 = azimuth;
  float zenith0 = zenith;
  for(int i = 1; i <= segments+1; i++){
    fill(242,229,129);
    solarPositionAtLatitude(longitude, latitude, d, (i%12)*jump, m, 0);
    if(i < segments+1){
      ellipse(MARGIN + (azimuth)/720*WIDTH+WIDTH/4., HEIGHT-((zenith)/PI*HEIGHT), SIZE, SIZE);
      line(MARGIN + (180+azimuth0)/720*WIDTH, HEIGHT-((zenith0)/PI*HEIGHT), 
           MARGIN + (180+azimuth)/720*WIDTH, HEIGHT-((zenith)/PI*HEIGHT) );
       azimuth0 = azimuth;
       zenith0 = zenith;
    }
//    else{
//       ellipse(WIDTH+MARGIN + (azimuth)/720*WIDTH+WIDTH/4., HEIGHT-((zenith)/PI*HEIGHT), SIZE, SIZE);
//     line(MARGIN + (180+azimuth0)/720*WIDTH, HEIGHT-((zenith0)/PI*HEIGHT), 
//           WIDTH+MARGIN + (180+azimuth)/720*WIDTH, HEIGHT-((zenith)/PI*HEIGHT) );
//       azimuth0 = azimuth;
//       zenith0 = zenith;
//    }
  }
}

void drawAnalemmaCurve(int hr){
  int offset = 0;
  if(hr>=24) offset = WIDTH;
  int d = 0;
  int segments = 24;
  int jump = 360/segments;
  float firstAzimuth, firstZenith;
  solarPositionAtLatitude(longitude, latitude, d, hr%24, 0, 0);
  float azimuth0 = firstAzimuth = azimuth;
  float zenith0 = firstZenith = zenith;
  for(int i = 1; i < segments+1; i++){
    solarPositionAtLatitude(longitude, latitude, jump*i, hr%24, 0, 0);
    if(i < segments+1){
      line(offset + MARGIN + (180+azimuth0)/720*WIDTH, HEIGHT-((zenith0)/PI*HEIGHT), 
           offset + MARGIN + (180+azimuth)/720*WIDTH, HEIGHT-((zenith)/PI*HEIGHT) );
       azimuth0 = azimuth;
       zenith0 = zenith;
    }
  }
//    line(MARGIN + (180+azimuth)/720*WIDTH, HEIGHT-((zenith)/PI*HEIGHT), 
//         MARGIN + (180+firstAzimuth)/720*WIDTH, HEIGHT-((firstZenith)/PI*HEIGHT) );
}

void draw(){
//  update();
  background(255);
  strokeWeight(1); 
  line(0,HEIGHT/2.,WIDTH+MARGIN*2,HEIGHT/2.);
//  strokeWeight(.5); 
  for(int i = 0; i <= 13; i++){
//    if(i == focus)
//      stroke(255,0,0);
    drawAnalemmaCurve(i*2);
    if(i == focus)
      stroke(0);
  }
  strokeWeight(SIZE*.1);
  goForPrint = true;
  drawYearCurve();
  fill(0);
  textSize(32);
  text(approximateMonth(d), 10, 30); 
  textSize(14);
  text("N", WIDTH/4*0+MARGIN, HEIGHT*.5-1); 
  text("E", WIDTH/4*1+MARGIN, HEIGHT*.5-1); 
  text("S", WIDTH/4*2+MARGIN, HEIGHT*.5-1); 
  text("W", WIDTH/4*3+MARGIN, HEIGHT*.5-1); 
  textSize(20);
  text("φ: " + latitude, WIDTH/4*0+MARGIN, HEIGHT-5); 
  text("λ: " + longitude, WIDTH/4*1+MARGIN, HEIGHT-5); 
  d+=2;
  if(d >= 360){
    d = 0;
  }
//  minute+=3;
//  if(minute >= 60){
//    hour++;  minute = 0;
//    if(hour >= 24) hour = 0;  }
}

// longitude is in degrees, 
void solarPositionAtLatitude(float longitude, float latitude, int day, int hour, int minute, int second){
    int timezone = 1;
    float y = 2*PI/365 * (day-1 + (hour-12)/24.);
    float eqtime = 229.18 * (0.000075 + 0.001868*cos(y) - 0.032077*sin(y) - 0.014615*cos(2*y) - 0.040849 * sin(2*y) );
    float decl = 0.006918 - 0.399912*cos(y) + 0.070257 * sin(y) - 0.006758 * cos(2*y) + 0.000907 * sin(2*y) - 0.002697 * cos(3*y) + 0.00148 * sin(3*y);
    float time_offset = eqtime - 4 * longitude + 60 * timezone;
    float tst = hour * 60 + minute + second / 60. + time_offset;  // in minutes
    float ha = tst/4. - 180;
    float zenithRight = (sin(latitude*PI/180.) * sin(decl) + cos(latitude*PI/180.) * cos(decl) * cos(ha*PI/180.));
    zenith = acos( zenithRight );
    float top = sin(latitude*PI/180.) * cos(zenith) - sin(decl);
    float bottom = cos(latitude*PI/180.) * sin(zenith);
    float azimuthRight = (top / bottom);
//    if(hour >= 14 || hour < 2)// && day < 250) //&& (day/2)%6 == 1))
      azimuth = 180+acos(-azimuthRight)/PI*360.;
//    else 
//      azimuth = 180-acos( -azimuthRight )/PI*360.;
//    if( (hour/2.) % 6 == 1 && (day < 250 || day > 350) )
//      azimuth = 180-acos( -azimuthRight )/PI*360.;
//    if( (hour == 10 || hour == 22) && (day > 272 && day < 340) ){
//      azimuth = 360+180+acos(-1/azimuthRight + 2)/PI*360.;
//    }
    
    if(goForPrint == true){
      if( hour/2. == focus){
//        println(hour + " " + day + "    " + sin(latitude*PI/180.) + " * " + cos(zenith) + " - " +  sin(decl) + " / " + cos(latitude*PI/180.) + " * " +  sin(zenith) + " ||||| " + (sin(latitude*PI/180.) * cos(zenith) - sin(decl) ) + " / " + (cos(latitude*PI/180.) * sin(zenith) ) + " = " + azimuthRight);
//        println(sin(latitude*PI/180.) + " * " + sin(decl) + " + " + cos(latitude*PI/180.) + " * " + cos(decl) + " * " +  cos(ha*PI/180.));
      //println(hour + " " + day + "    " + -azimuthRight + "    " + acos(-azimuthRight)/PI*360. + "   ::    "  + zenithRight + "    " + acos(zenithRight)/PI*360.);
      
//      if(count%10 == 0)
//      {
//        if(zenithRight < -PI/2. || zenithRight > PI/2.)
//          println("ZENITH" + zenithRight);
//        if(azimuthRight < -PI/2. || azimuthRight > PI/2.)
//          println("AZIMUTH  " + azimuthRight);
////          println(day + " Azimuth: " + azimuth + "      Zenith: " + zenith);
//      //    println(day + 
//      }
        goForPrint = false;
      }
    }
//      count++;
//      println(ha + "        " + tst/4.);
//      if(hour == 14)
//        println("ZENITH" + zenithRight + "      AZIMUTH  " + azimuthRight);
}

String approximateMonth(int day){
  int approx = (int)(day/30.41666);
  String month;
  if(approx == 0) month = "January";
  else if(approx == 1) month = "February";
  else if(approx == 2) month = "March";
  else if(approx == 3) month = "April";
  else if(approx == 4) month = "May";
  else if(approx == 5) month = "June";
  else if(approx == 6) month = "July";
  else if(approx == 7) month = "August";
  else if(approx == 8) month = "September";
  else if(approx == 9) month = "October";
  else if(approx == 10) month = "November";
  else if(approx == 11) month = "December";
  else month = "";
  return month;
}

//void mouseWheel(MouseEvent event) {
//  setLonLat( (mouseX-MARGIN)/(float)(WIDTH)*360-180, (mouseY-MARGIN)/(float)(WIDTH)*180-90 );
//}

void mouseClicked(){
//  focus++;
//  if(focus == 12)
//    focus = 0;
//  println("FOCUS:" + focus);
  setLonLat( (mouseX-MARGIN)/(float)(WIDTH)*360-180, (1-(mouseY)/(float)(HEIGHT))*180-90 );
}

void mouseDragged(){
  setLonLat( (mouseX-MARGIN)/(float)(WIDTH)*360-180, (1-(mouseY)/(float)(HEIGHT))*180-90 );
}

void setLonLat(float lon, float lat){
  println("++++++++++++++ " + lon + "   " + lat );
  latitude = lat;
  longitude = lon;
}
