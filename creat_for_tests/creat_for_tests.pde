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
  PVector loc;
  PVector vel; 

  //PARAMETERS
  int c_;
  int main;
  int taillebras;
  int nbbras;
  color couleur;
  int tete;

  //GLOBALS
  float basespeed;
  float coeffsize;
  float theta;

  Creature() {
    loc = new PVector(0, 0);
    vel = new PVector(0, 0);
    basespeed = 20;
    coeffsize = 50;
  }

  public Creature corps(int c_) { //DISPLAY
    c = c_;
    switch(c_) {
    case 0:
      if (vel.mag() < 0.1) {
        PVector tmp = new PVector(random(-basespeed, basespeed), random(-basespeed, basespeed));
        vel.add(tmp);
      }
      vel.mult(0.95);
      loc.add(vel);
      ellipse(loc.x, loc.y, coeffsize, coeffsize);
      break;
    case 1:

      break;
    case 2:

      break;
    case 3:

      break;
    }
    rebondis();
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
    if ((this.loc.x < 0 &&  this.vel.x < 0) 
      || (this.loc.x > width && this.vel.x > 0))
      if ((this.loc.x < 20 &&  this.vel.x < 0)
        || (this.loc.x > width - 20 && this.vel.x > 0)
        )
        this.vel.x *= -0.95;

    if ((this.loc.y < 0 && this.vel.y < 0)
      || (this.loc.y > height && this.vel.y > 0))
      if ((this.loc.y < 20 && this.vel.y < 0)
        || (this.loc.y > height - 20 && this.vel.y > 0)
        )
        this.vel.y *= -0.95;

    return this;
  }
}


Creature macreature;

void setup() {
  size(800, 800);
  stroke(0);
  strokeWeight(4);

  frameRate(30);

  colorMode(HSB, 360, 100, 100, 100);

  rectMode(CENTER);
  macreature = new Creature();
}

void draw() {
  
  background(0, 0, 100, 0);
  macreature.corps(atome);
 
  /*macreature
    .corps(serpent)
    .main(losange)
    .tailledebras(grand) // bosse / patte =  / antenne =  / tentacule = 
    .nombredebras(humain) //humain = 2 / alien = 3 / insecte = 6 / poulpe = 8   
    .couleurs(aquatique) //aquatique = bleus / exotique = rouge/orange / foret = vert / nocturne = violets / soleil = jaunes
    .tete(horrible); // cyclope = 1 / humain = 2 / alien = 3 / horrible = 16 
 */
}