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
float bosse = 0;
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
color gris = color(127);

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
  int c; // body
  int m; // hand
  float tb; // Arm size
  int nbb; // Arms count
  color co; // Colors
  int tt; // Tete

  //GLOBALS
  float basespeed; //Base speed
  float finalspeed; // Final speed once multiplied by Creature's mass 
  float mass; // Mass - influenced by arms count and length
  float coeffsize; //Overall size of Creatures
  float theta; // Heading angle vector
  float maxforce; //Max force when applying on main velocity to avoid weird moves
  float widthedge; //Width edge to repell creatures
  float heightedge; // Height edge to repell creatures
  float strokeW; //strokeWeight based on display size
  float loop;

  //INIT BOOLEANS
  boolean once_c; //init for body function to updates from user choices
  boolean once_tb; //add only once coefficient on mass based on tb (arm size) 
  boolean once_nbb; //add only once coefficient on mass based on nbb (arms count)

  //SNAKE
  int sizeSnake;
  Child[] snake;
  float segment;
  Attach anc;

  //ARMS
  Child[] arms;
  Attach att;
  PVector[] epaule;
  float tbl; //TB LENGTH COMPUTED FROM TB VARIABLE

  //WANDER
  float wandertheta;
  PVector vtmp;

  //CREATURE CLASS STARTS HERE
  Creature() {
    nbb = humain;
    tb = patte;
    co = gris;
    m = cercle;
    tt = cyclope;

    loop = 0;

    //VARIABLES INIT
    if (width > height) {
      strokeW = height/180;
      coeffsize = height/15;
      basespeed = height/100;
    } else {
      strokeW = width/180;
      coeffsize = width/15;
      basespeed = width/100;
    }
    strokeWeight(strokeW);

    //INIT MASS AND FORCE MAX
    mass = 1; 
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

    // INIT ONCE BOOLEANS
    once_tb = false; // ONCE ARMS SIZE
    once_nbb = false; // ONCE ARMS COUNT
    once_c = false; // ONCE BODY
  }

  //LET'S MAKE SURE THAT WE READ THE CODE OF THE USER BEFORE TRYING TO RENDER ANYTHING (To avoid arrays out of bounds for example)
  boolean updated() { 
    if (loop <= 2) {
      //armsize influence on coeffspeed / the larger arms = the more speed
      mass += tb/30;
      //arm count influence on coeffspeed / the more arms = the less speed
      mass -= float(nbb/30);

      //Finalspeed initialization - default one with mass = 1 
      finalspeed = basespeed*mass;

      //UPDATE ARM SIZE
      tbl = tb*((coeffsize*coeffsize)/100);

      vtmp = new PVector(0, 0);

      //SNAKE UPDATE
      //sizeSnake = int((3+nbb)/2);
      sizeSnake = nbb+1;
      snake = new Child[sizeSnake];
      segment = (coeffsize*3)/sizeSnake;
      for (int i = 0; i < sizeSnake; i++) {
        snake[i] = new Child(loc.x+(i*2), loc.y+(i*2));
      }
      anc = new Attach(loc.x, loc.y, int(segment/1.1));

      //ATTACH FOR ARMS
      epaule = new PVector[nbb];
      arms = new Child[nbb];
      for (int i = 0; i < nbb; i++) {
        epaule[i] = new PVector(0, 0);
        arms[i] = new Child(0, 0);
      }
      loop++;
      return false;
    } else { 
      return true;
    }
  }

  public Creature corps(int c_) { //decide here global moves / speed pattern / body shape
    if (frameCount%360 == 0) {
      console.log(frameRate);
    }

    c = c_;
    finalspeed = basespeed*mass;
    if (updated()) {
      strokeWeight(strokeW);
      float theta = vel.heading();
      stroke(0, 0, 0);
      noFill();
      dir = PVector.sub(target, loc);
      switch(c) {

      case 0: //ATOME
        maxforce = 1;
        float dd = dir.mag();
        dir.normalize();
        if (dd < coeffsize*2) {
          float ralenti = map(dd, 0, coeffsize*2, 0, finalspeed);  
          dir.mult(ralenti);
        } else {
          dir.mult(finalspeed);
        }

        if (dd <= coeffsize/10) {
          target = new PVector(
            random(coeffsize, widthedge), 
            random(coeffsize, heightedge)
            ); 
          //ellipse(target.x, target.y, 100, 100);
        }
        
        ellipse(loc.x, loc.y, coeffsize, coeffsize);
        
        float angle=TWO_PI/(float)nbb;
        for(int iii=0;iii<nbb;iii++)
        {
          epaule[iii] = new PVector(coeffsize/2*sin(angle*iii)+loc.x, coeffsize/2*cos(angle*iii)+loc.y);
          vtmp = new PVector(0, 0);
          vtmp = arms[iii].loca.get();
          float thetaa = (-angle*iii)+PI/3;
          vtmp.rotate(thetaa);
          vtmp.normalize();
          vtmp.mult(1);
          arms[iii].acce.add(vtmp);
        } 

        
        break;

      case 1: //SERPENT
        maxforce = 0.1;
        float dddd = dir.mag();
        dir.normalize();
        if (dddd < coeffsize*4) {
          target = new PVector(
            random(0, width), 
            random(0, height)
            );
          //rect(target.x, target.y, 100, 100);
        } 
        dir.mult(finalspeed);

        beginShape();
        curveVertex(loc.x, loc.y);
        curveVertex(loc.x, loc.y);
        for (int j = 0; j < sizeSnake; j++) {

          if (j == 0) {
            anc = new Attach(loc.x, loc.y, int(segment/1.1));
          } else {
            anc = new Attach(snake[j-1].loca.x, snake[j-1].loca.y, int(segment));
          }
          anc.connect(snake[j]);
          anc.constrainLength(snake[j], segment*1.01, segment*1.02, 0.65);
          snake[j].applyForce(snake[j].acce);
          snake[j].update();

          curveVertex(snake[j].loca.x, snake[j].loca.y);
          epaule[j] = new PVector(snake[j].loca.x, snake[j].loca.y);
          vtmp = new PVector(0, 0);
          vtmp = vel.get();
          float theta2 = vtmp.heading();
          vtmp.rotate(theta2);
          if (j%2==0) {
            vtmp.rotate(PI/2);
          } else {
            vtmp.rotate(-PI/2);
          }
          vtmp.normalize();
          vtmp.mult(1);
          if(j < sizeSnake-1){
            arms[j].acce.add(vtmp);
          }
        }
        curveVertex(snake[sizeSnake-1].loca.x, snake[sizeSnake-1].loca.y);
        endShape();
        break;

      case 2: //DUO
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

      case 3: //CRISTAL
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
    }
    return this;
  }

  // ARMSIZE
  public Creature taillebras(float tb_) {
    tb = tb_;
    if (updated()) {
    }
    return this;
  }

  //ARMS COUNT
  public Creature nombredebras(int nbb_) {
    nbb = nbb_;
    if (updated()) {
      for (int ii = 0; ii < nbb; ii++) {
        att = new Attach(epaule[ii].x, epaule[ii].y, int(tbl));
        att.connect(arms[ii]);
        att.constrainLength(arms[ii], tbl, tbl, 0.69);
        arms[ii].update();
        strokeWeight(strokeW/2);
        line(epaule[ii].x, epaule[ii].y, arms[ii].loca.x, arms[ii].loca.y);
        ellipse(arms[ii].loca.x, arms[ii].loca.y, 10, 10);
      }
    }  
    return this;
  }

  public Creature main(int m_) {
    m = m_;


    return this;
  }

  public Creature couleurs(color co_) {
    co = co_;

    return this;
  }

  public Creature tete(int te_) {
    tt = te_;

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
  //  float k = 1; // Spring constant

  Attach(float x, float y, int l) {
    anchor = new PVector(x, y);
    len = l;
  }

  void connect(Child c) {
    PVector force = PVector.sub(c.loca, anchor);
    //float d = force.mag();

    // Calculate force according to Hooke's Law
    // F = k * stretch
    force.normalize();
    //force.mult(-1 * k * stretch);
    force.mult(-1 * len);
    c.applyForce(force);
  }

  // Constrain the distance between bob and anchor between min and max
  void constrainLength(Child c, float minlen, float maxlen, float inert) {
    PVector dir = PVector.sub(c.loca, anchor);
    float d = dir.mag();
    // Is it too short?
    if (d < minlen) {
      dir.normalize();
      dir.mult(minlen);
      // Reset location and stop from moving (not realistic physics)
      c.loca = PVector.add(anchor, dir);
      c.velo.mult(inert);
      // Is it too long?
    } else if (d > maxlen) {
      dir.normalize();
      dir.mult(maxlen+(d-maxlen)/2);
      // Reset location and stop from moving (not realistic physics)
      c.loca = PVector.add(anchor, dir);
      c.velo.mult(inert);
    }
  }
}

class Child {
  PVector loca;
  PVector velo;
  PVector acce;
  float masse = 10;
  float fric = 0.99;

  Child(float x, float y) {
    loca = new PVector(x, y);
    velo = new PVector();
    acce = new PVector();
  }

  // Standard Euler integration
  void update() { 
    velo.add(acce);
    velo.mult(fric);
    loca.add(velo);
    acce.mult(0);
  }

  void applyForce(PVector force) {
    PVector f = force.get();
    f.div(masse);
    acce.add(f);
  }
}

Creature macreature;
Creature macreature2;
Creature macreature3;
Creature macreature4;

void setup() {
  size(800, 600);
  stroke(0);
  strokeWeight(4);

  frameRate(30);

  colorMode(HSB, 360, 100, 100, 100);

  ellipseMode(CENTER);
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
    .nombredebras(8)
    .taillebras(tentacule)
    ;

  macreature2
    .corps(serpent)
    .nombredebras(8)
    .taillebras(tentacule)
    ;

  /*macreature3
   .corps(serpent)
   .nombredebras(6)
   .taillebras(antenne)
   ;*/

  /*macreature4
   .corps(serpent)
   .nombredebras(6)
   .taillebras(tentacule)
   ;*/

  /*macreature2
   .corps(cristal)
  /*.taillebras(patte);*/
  ;

  /*macreature3
   .corps(serpent)
   .nombredebras(alien)
   .taillebras(humain);
   ;
   
   macreature4
   .corps(serpent)
   .nombredebras(poulpe)
   .taillebras(bosse);
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