void setup(){
   colorMode(HSB, 360, 100, 100);
}

void draw() {

 fondu(0, 0, width, height);


}

void fondu(int x, int y, float w, float h){
float dixieme = millis()/30000;
noiseSeed(10);
float hue = map(noise(dixieme), 0.3, 0.6, 0, 1)*360;
color c = color(hue, 100, 70);

fill(c);
rect(x, y, w, h);

fill(0);
stroke(0);
if(frameCount%60==0){
text(noise(dixieme), 10, 10);
}
}    