Creature macreature;

void setup() {
  size(400, 400);
  stroke(0);
  strokeWeight(4);

  rectMode(CENTER);


  macreature = new Creature();
  

}

void draw() {
  
  background(255, 255, 255, 0);

  macreature
    .corps("serpent")
    .aubord("rebondis")
    .couleurs("aquatique")
    .tete("horrible")
 
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