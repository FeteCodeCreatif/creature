color nuit = color(11, 74, 150);
color lever = color(245, 152, 59);
color jour = color(31, 167, 255);
color coucher = color(255, 31, 102);

color c1, c2;

color result = color(nuit);
float angle = 0;
float pourc = 0;
float duree = 2000;
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
   size(800, 400);
   ellipseMode(CENTER);
   noStroke();
   
   centre = new PVector(width/2, height);
}

void draw(){ 
  
  
  if(millis() > current+duree){
    if(moment < 8){
    moment++;
    } else {
      moment = 1;
      println("LEVER "+millis());
      println("      "+current);
    }
    current = floor(millis()/1000)*1000;
  }
  
  if(moment == 1){
      c1 = nuit;
      c2 = lever;
  } else if (moment == 3) {
      c1 = lever;
      c2 = jour;
  } else if (moment == 5) {
      c1 = jour;
      c2 = coucher;
  } else if (moment == 7) {
      c1 = coucher;
      c2 = nuit;
  }
  
  pourc = map(millis(), current, current+duree, -1, 1);
  
  if(moment %2 == 0 || moment == 0) {
    result = c2;
  } else {
    result = lerpColor(c1, c2, pourc);
  }
  
  rendersky(result);
  sunmoon();
}

void rendersky(color c){
  fill(c);
  rect(0, 0, width, height);
}

void sunmoon(){
  //SUN
  course = -map(millis(), 0, duree*8, -1, 1)+PI/3;
  
  if(sin(course) >= 0.99999){
    //println("SUNLI "+millis());
  }
  
  fill(255, 50);
  
  sun.x = centre.x + rayon*-cos(course);
  sun.y = centre.y + rayon*-sin(course);
  
  moon.x = centre.x + rayon*cos(course);
  moon.y = centre.y + rayon*sin(course);
  
  ellipse(sun.x, sun.y, 30, 30);
  ellipse(moon.x, moon.y, 300, 300);
}