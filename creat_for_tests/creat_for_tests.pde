// Global Variables //<>//
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
  float basespeed; //Base speed
  float finalspeed; // Final speed once multiplied by Creature's mass 
  float mass; // Mass - influenced by arms count and length
  float coeffsize; //Overall size of Creatures
  float theta; // Heading angle vector
  boolean once_tb; //add only once coefficient on mass based on tb (arm size) 
  boolean once_nbb; //add only once coefficient on mass based on nbb (arms count)
  float maxforce; //Max force when applying on main velocity to avoid weird moves
  float widthedge; //Width edge to repell creatures
  float heightedge; // Height edge to repell creatures

  //SNAKE
  int sizeSnake = 5;
  Child[] snake = new Child[sizeSnake];
  float segment;
  Attach anc;


  //CREATURE CLASS STARTS HERE
  Creature() {
    //VARIABLES INIT
    mass = 1; 
    coeffsize = 50;
    basespeed = 10;
    maxforce = 0.5;
    // Init edges with coeffsize
    widthedge = width-coeffsize;
    heightedge = height-coeffsize;

    //Random location starting point
    loc = new PVector(
      random(coeffsize, widthedge), 
      random(coeffsize, heightedge)
      );

    //Velocity and acceleration initialization
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);

    //Random first target
    target = new PVector(
      random(coeffsize, widthedge), 
      random(coeffsize, heightedge)
      );

    //Direction and steering initialization
    dir = new PVector(0, 0);
    st  = new PVector(0, 0);

    //Finalspeed initialization - default one with mass = 1 
    finalspeed = basespeed*mass;

    // Init once booleans
    once_tb = false; // ONCE TB
    once_nbb = false; // ONCE NBB

    // SNAKE INIT 
    segment = coeffsize*0.5;
    for (int i = 0; i < sizeSnake; i++) {
      snake[i] = new Child(loc.x+(i*2), loc.y+(i*2));
    }
    anc = new Attach(loc.x, loc.y, int(segment/10));
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

      beginShape();
      curveVertex(loc.x, loc.y);
      for (int j = 0; j < sizeSnake; j++) {

        if (j == 0) {
          anc = new Attach(loc.x, loc.y, int(segment));
        } else {
          anc = new Attach(snake[j-1].loc.x, snake[j-1].loc.y, int(segment));
        }
        anc.connect(snake[j]);
        anc.constrainLength(snake[j], segment*0.99, segment*1.01, 0.8);
        snake[j].applyForce(snake[j].acc);
        snake[j].update();
        curveVertex(snake[j].loc.x, snake[j].loc.y);
      }
      endShape();

      break;
    case 2:
      maxforce = 1;
      float du = dir.mag();

      float r = coeffsize*2;
      float amp = 10;
      PVector oscillate = new PVector(r*cos(TWO_PI * (frameCount/amp)), r*sin(TWO_PI * (frameCount/amp)));

      if (du < coeffsize*2) {
        dir.normalize();
        float ralenti = map(du, 0, coeffsize*2, 0, finalspeed);  
        dir.mult(ralenti);
      } else {
        dir.add(oscillate);
        dir.normalize();
        dir.mult(finalspeed);
      }

      if (du <= coeffsize/2) {
        target = new PVector(
          random(coeffsize, widthedge), 
          random(coeffsize, heightedge)
          ); 
        //ellipse(target.x, target.y, 100, 100);
      }
      pushMatrix();
      translate(loc.x, loc.y);
      rotate(theta);
      line(-coeffsize/4, -coeffsize/2, -coeffsize/4, coeffsize/2);
      line(coeffsize/4, -coeffsize/2, coeffsize/4, coeffsize/2);
      popMatrix();
      break;
    case 3:
      strokeCap(ROUND);
      maxforce = 0.4;
      float ddd = dir.mag();
      dir.normalize();
      if (ddd < coeffsize*2) {
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
      maxforce = 1;
      nogo = PVector.sub(out, vel);
      nogo.limit(maxforce*2);
      applyForce(nogo);
    }

    return this;
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acc.add(f);
  }
}

// THANKS Daniel Shiffman for his Spring class - https://github.com/shiffman/The-Nature-of-Code-Examples/blob/master/chp03_oscillation/NOC_3_11_spring/Spring.pde
class Attach {
  PVector anchor; 
  PVector ext; // extremity

  float len; // Length
  float k = 0.5; // Spring constant

  Attach(float x, float y, int l) {
    anchor = new PVector(x, y);
    len = l;
  }

  void connect(Child c) {
    PVector force = PVector.sub(c.loc, anchor);
    float d = force.mag();
    float stretch = d - len;

    // Calculate force according to Hooke's Law
    // F = k * stretch
    force.normalize();
    force.mult(-1 * k * stretch);
    c.applyForce(force);
  }

  // Constrain the distance between bob and anchor between min and max
  void constrainLength(Child c, float minlen, float maxlen, float inert) {
    PVector dir = PVector.sub(c.loc, anchor);
    float d = dir.mag();
    // Is it too short?
    if (d < minlen) {
      dir.normalize();
      dir.mult(minlen);
      // Reset location and stop from moving (not realistic physics)
      c.loc = PVector.add(anchor, dir);
      c.vel.mult(inert);
      // Is it too long?
    } else if (d > maxlen) {
      dir.normalize();
      dir.mult(maxlen+(d-maxlen)/2);
      // Reset location and stop from moving (not realistic physics)
      c.loc = PVector.add(anchor, dir);
      c.vel.mult(inert);
    }
  }
}

class Child {
  PVector loc;
  PVector vel;
  PVector acc;
  float mass = 10;
  float fri = 0.99;

  Child(float x, float y) {
    loc = new PVector(x, y);
    vel = new PVector();
    acc = new PVector();
  }

  // Standard Euler integration
  void update() { 
    vel.add(acc);
    vel.mult(fri);
    loc.add(vel);
    acc.mult(0);
  }

  void applyForce(PVector force) {
    PVector f = force.get();
    f.div(mass);
    acc.add(f);
  }
}

Creature macreature;
Creature macreature2;
Creature macreature3;
Creature macreature4;

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
  macreature4 = new Creature();
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

  macreature4
    .corps(duo)
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