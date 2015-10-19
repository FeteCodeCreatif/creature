Creature c1;
Creature c2;

void setup() {
  size(400, 400);
  stroke(0);

  rectMode(CENTER);

  c1 = new Creature();
  c2 = new Creature();
}

void draw() {

  background(255);
  c1.alaforme("boule");
  c1.avance("touslessens", 5);
  c1.rebondis();
  
  c2.alaforme("carre");
  c2.avance("toudroit", 4);
  c2.passe();
}

class Creature {
  PVector loc;
  PVector vel;
  PVector acc; 
  float topspeed;
  int rad;
  boolean once;

  Creature() {
    loc = new PVector(random(width), random(height));
    vel = new PVector();
    //acc = new PVector(-0.001, 0.01);
    topspeed = 5;
    rad = 10;
  }

  void avance(String move, float v) { //UPDATE
    if(!once){
      vel = new PVector(random(-v, v), random(-v, v));
      once = true;
    }
  
    if (move == "toutdroit") {
      //acc.normalize();
    } else if (move == "serpent") {
    } else if (move == "touslessens") {
      acc = new PVector(random(-1, 1), random(-1, 1));
      acc.normalize();
      vel.add(acc);
    }
    
    
    vel.limit(v);
    loc.add(vel);
  } 

  void alaforme(String forme) { //DISPLAY
    if (forme == "boule") {
      ellipse(loc.x, loc.y, rad, rad);
  } else if (forme == "carre") {
    rect(loc.x, loc.y, rad, rad);
  } else if (forme == "serpent") {
    } else if (forme == "pieuvre") {
    }
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

  void rebondis() {
    if ((loc.x > width) || (loc.x < 0)) {
      if(loc.x > width){ loc.x = width; }
      else if(loc.x < 0) { loc.x = 0; }
      vel.x = vel.x * -1;
      println(vel.x);
    }
    if ((loc.y > height) || (loc.y < 0)) {
      if(loc.y > height){ loc.y = height; }
      else if(loc.y < 0) { loc.y = 0; }
      vel.y = vel.y * -1;
    }
  }
}


  /*
Class Membre {
   
   Membre() {
   }
   
   void update() {
   } 
   
   void display() {
   }
   
   void naissance() {
   }
   }
   
   Class Tete {
   
   Tete() {
   }
   
   void update() {
   } 
   
   void display() {
   }
   
   void naissance() {
   }
   }*/