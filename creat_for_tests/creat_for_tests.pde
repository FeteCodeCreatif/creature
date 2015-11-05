// Global Variables
// BODY
int atome = 0;
int serpent = 1;
int duo = 2;
int cristal = 3;
int crystal = 3;

// HAND 
int losange = 0;
int cercle = 1;
int triangle = 2;
int etoile = 3;

//ARM SIZE
int bosse = 0;
int patte = 1;
int antenne = 2;
int tentacule = 3;

//ARM AMOUNT
int humain = 2;
int alien = 3;
int insecte = 6;
int poulpe = 8;

//COLOR PALETTES
color eau = color(220, 100, 100);
color exotique = color(12, 100, 100);
color foret = color(92, 100, 75);
color nuit = color(300, 100, 75);
color soleil = color(50, 100, 100);

//TETE
int cyclope = 1;
int horrible = 16;

//Global Variables end

class Creature {
  //MOVE
  PVector loc; // Position
  PVector vel; // Velocity
  PVector acc; // Acceleration
  PVector target; // Cible
  PVector dir; // Direction
  PVector st; // Steering

  //PARAMETERS
  int c;
  int m;
  float tb;
  float nbb;
  color co;
  int tt;

  //GLOBALS
  float basespeed;
  float finalspeed;
  float mass;
  float coeffsize;
  float theta;
  boolean once_tb;
  boolean once_nbb;
  float maxforce;
  float widthedge;
  float heightedge;

  //CREATURE CLASS STARTS HERE
  Creature() {
    mass = 1;
    coeffsize = 50;
    basespeed = 10;
    maxforce = 0.5;
    widthedge = width-coeffsize;
    heightedge = height-coeffsize;

    loc = new PVector(
      random(coeffsize, widthedge), 
      random(coeffsize, heightedge)
      );
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
    target = new PVector(
      random(coeffsize, widthedge), 
      random(coeffsize, heightedge)
      );
    dir = new PVector(0, 0);
    st  = new PVector(0, 0);
    finalspeed = basespeed*mass;

    once_tb = false; // ONCE TB
    once_nbb = false; // ONCE NBB
  }

  public Creature corps(int c_) { //decide here global moves / speed pattern / body shape
    c = c_;
    finalspeed = basespeed*mass;
    float theta = vel.heading();

    stroke(0, 0, 0);
    noFill();
    /*if(frameCount%60 == 0){
     console.log(finalspeed); 
     }*/

    dir = PVector.sub(target, loc);


    switch(c) {
    case 0:
      maxforce = 1;
      float dd = dir.mag();
      dir.normalize();
      if (dd < coeffsize*2) {
        float ralenti = map(dd, 0, coeffsize*2, 0, finalspeed);  
        dir.mult(ralenti);
      } else {
        dir.mult(finalspeed);
      }

      if (dd <= 0.25) {
        target = new PVector(
          random(coeffsize, widthedge), 
          random(coeffsize, heightedge)
          ); 
        //ellipse(target.x, target.y, 100, 100);
      }

      ellipse(loc.x, loc.y, coeffsize, coeffsize);
      break;
    case 1: //SERPENT
      maxforce = 1;
      if (frameCount%10 == 0) {
        target = new PVector(
          random(coeffsize, widthedge), 
          random(coeffsize, heightedge)
          );
        //rect(target.x, target.y, 100, 100);
      } 
      dir.mult(finalspeed);

      
      rect(loc.x, loc.y, coeffsize/2, coeffsize/2);
      
      

      break;
    case 2:


      break;
    case 3:
      
      float ddd = dir.mag();
      dir.normalize();
      if (ddd < coeffsize) {
        target = new PVector(
          random(coeffsize, widthedge), 
          random(coeffsize, heightedge)
          );
        //rect(target.x, target.y, 100, 100);
      } 
      dir.mult(finalspeed);

      
      pushMatrix();
      translate(loc.x, loc.y);
      rotate(theta+PI/2);
      
      beginShape();
      float tmp = coeffsize*0.15;
      vertex(-tmp*3, -tmp*2.5);
      vertex(tmp*3, -tmp*1.5);
      vertex(tmp*2, tmp*5);
      vertex(0, tmp*7.5);
      
      /*vertex(loc.x-tmp*3, loc.y-tmp*2.5);
      vertex(loc.x+tmp*3, loc.y-tmp*1.5);
      vertex(loc.x+tmp*2, loc.y+tmp*5);
      vertex(loc.x, loc.y+tmp*7.5);*/
      endShape(CLOSE);
      popMatrix();
      break;
    }

    //TARGET FOR TEST PURPOSE
    //stroke(0, 100, 100);
    //point(target.x, target.y);

    st = PVector.sub(dir, vel); 
    st.limit(maxforce);

    applyForce(st);
    vel.add(acc);
    vel.limit(finalspeed);
    loc.add(vel);
    acc.mult(0);

    rebondis();
    return this;
  }

  // ARMSIZE and 
  public Creature taillebras(int tb_) {
    tb = float(tb_);

    //armsize influence on coeffspeed / the larger arms = the more speed
    if (!once_tb) { 
      mass += tb/3;
      once_tb = true;
    }


    return this;
  }

  public Creature nombrebras(int nbb_) {
    nbb = float(nbb_);

    //arm count influence on coeffspeed / the more arms = the less speed
    if (!once_nbb) { 
      mass -= nbb/3;
      once_nbb = true;
    }

    return this;
  }

  void passe() {

    if (loc.x > width) {
      loc.x = 0;
    } else if (loc.x < 0) {
      loc.x = width;
    }

    if (loc.y > height) {
      loc.y = 0;
    } else if (loc.y < 0) {
      loc.y = height;
    }
  }

  public Creature rebondis() {
    PVector nogo;
    PVector out = new PVector(0, 0);
    //REPULSIVE WALLS
    //stroke(0, 100, 100);
    //rect(width/2, height/2, widthedge, heightedge);
    if (((this.loc.x < coeffsize &&  this.vel.x < coeffsize)
      || (this.loc.x > width + coeffsize && this.vel.x > 0))
      || ((this.loc.y < -coeffsize && this.vel.y < 0)
      || (this.loc.y > height + coeffsize && this.vel.y > 0))) {
      if ((this.loc.x < coeffsize &&  this.vel.x < coeffsize)
        || (this.loc.x > width + coeffsize && this.vel.x > 0)) {
        out = new PVector(finalspeed, vel.y);
      }
      if ((this.loc.y < -coeffsize && this.vel.y < 0)
        || (this.loc.y > height + coeffsize && this.vel.y > 0)
        ) {
        out = new PVector(vel.x, finalspeed);
      }
      nogo = PVector.sub(out, vel);
      nogo.limit(maxforce*1.5);
      applyForce(nogo);
    }

    return this;
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acc.add(f);
  }
}


Creature macreature;
Creature macreature2;
Creature macreature3;

void setup() {
  size(600, 600);
  stroke(0);
  strokeWeight(4);

  frameRate(30);

  colorMode(HSB, 360, 100, 100, 100);

  rectMode(CENTER);
  macreature = new Creature();
  macreature2 = new Creature();
  macreature3 = new Creature();
}

void draw() {

  background(0, 0, 100, 0);
  macreature
    .corps(atome)
  /*.taillebras(tentacule)
   .nombrebras(poulpe)*/
    ;

  macreature2
    .corps(cristal)
  /*.taillebras(patte);*/
    ;

  macreature3
    .corps(serpent)
  /*.taillebras(patte);*/
    ;

  /*macreature
   .corps(serpent)
   .main(losange)
   .tailledebras(grand) // bosse / patte =  / antenne =  / tentacule = 
   .nombredebras(humain) //humain = 2 / alien = 3 / insecte = 6 / poulpe = 8   
   .couleurs(aquatique) //aquatique = bleus / exotique = rouge/orange / foret = vert / nocturne = violets / soleil = jaunes
   .tete(horrible); // cyclope = 1 / humain = 2 / alien = 3 / horrible = 16 
   */
}