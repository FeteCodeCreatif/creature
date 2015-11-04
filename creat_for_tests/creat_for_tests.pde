Creature macreature;

void setup() {
  size(800, 800);
  stroke(0);
  strokeWeight(4);

  colorMode(HSB, 360, 100, 100, 100);

  rectMode(CENTER);
  macreature = new Creature();
}

void draw() {
  
  background(0, 0, 100, 0);

  macreature
    .corps(atome);

  /*macreature
    .corps(serpent)
    .main(losange)
    .tailledebras(grand) // bosse / patte =  / antenne =  / tentacule = 
    .nombredebras(humain) //humain = 2 / alien = 3 / insecte = 6 / poulpe = 8   
    .couleurs(aquatique) //aquatique = bleus / exotique = rouge/orange / foret = vert / nocturne = violets / soleil = jaunes
    .tete(horrible); // cyclope = 1 / humain = 2 / alien = 3 / horrible = 16 
 */
}