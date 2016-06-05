color nuit = color(11, 74, 150);
color lever = color(245, 152, 59);
color jour = color(31, 167, 255);
color coucher = color(255, 31, 102);

color c1, c2;

color result = color(nuit);
float angle = 0;
float pourc = 0;
float duree = 1000;
float current = 0;

float previous = 0;

PVector centre; 
PVector sun = new PVector(0, 0);
PVector moon = new PVector(0, 0);
int rayon = 200;
float course = 0;

//nuit = 0
//lever = 1
//jour = 2
//coucher = 3
float moment = 0;

void setup(){
   size(displayWidth, displayHeight);
   ellipseMode(CENTER);
   noStroke();
   
   centre = new PVector(width/2, height);
}

void draw(){ 
  
  
  if(millis() > current+duree){
    if(moment < 7){
    moment++;
    } else {
      moment = 0;
      println("NEW LEVER "+millis());
    }
    current = floor(millis()/1000)*1000;
  }
  
  if(moment == 0){
      c1 = nuit;
      c2 = lever;
  } else if (moment == 2) {
      c1 = lever;
      c2 = jour;
  } else if (moment == 4) {
      c1 = jour;
      c2 = coucher;
  } else if (moment == 6) {
      c1 = coucher;
      c2 = nuit;
  }
  
  pourc = map(millis(), current, current+duree, -1, 1);
  
  if(moment %2 == 0) {
    result = lerpColor(c1, c2, pourc);
  } else {
    result = c2;
  }
  
  rendersky(result);
  sunmoon();
}

void rendersky(color c){
  fill(result);
  rect(0, 0, width, height);
}

void sunmoon(){
  //SUN
  course = -map(millis(), 0, duree*3, -1, 1)+1;
  
  if(sin(course) >= 0.9999){
    println("NEW SUNLI "+millis());
  }
  
  fill(255, 50);
  
  sun.x = centre.x + rayon*-cos(course);
  sun.y = centre.y + rayon*-sin(course);
  
  moon.x = centre.x + rayon*cos(course);
  moon.y = centre.y + rayon*sin(course);
  
  ellipse(sun.x, sun.y, 30, 30);
  ellipse(moon.x, moon.y, 300, 300);
}