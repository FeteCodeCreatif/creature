Creature c1;
Creature c2;

void setup() {
  size(400, 400);
  stroke(0);
  strokeWeight(4);

  rectMode(CENTER);

  c1 = new Creature();
  c2 = new Creature();
}

void draw() {

  background(255);
  c1.alaforme("serpent");
  c1.avance("touslessens", 10);
  c1.rebondis();

  c2.alaforme("boule");
  c2.avance("serpent", 4);
  c2.passe();
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