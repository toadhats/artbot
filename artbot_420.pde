import java.util.Random;

Random generator;
float t; // used for the noise function

void setup() {
  size(800, 800);
  frameRate(120);
  background(240);
  generator = new Random();
  t = 0;
}

void draw() {
  drip();
  color squiggleColour1 = evolvingColour(5);
  color squiggleColour2 = evolvingColour(69);
  squiggle(squiggleColour1, 1);
  squiggle(squiggleColour2, 5);
}// end draw()

void drip() { 
  float sd = 80;
  float mean = 400;
  float xnum = (float) generator.nextGaussian();
  float ynum = (float) generator.nextGaussian();


  float x = sd * xnum + mean;
  float y = sd * ynum + mean;
  //print("(" + x + "," + y + ")");
  
  colorMode(RGB, 255);
  noStroke();
  fill(15, 10);
  ellipse(x, y, 16, 16);
} // end drip()

void squiggle(color colour, int offset) {
  float nx = noise(t + offset);
  float ny = noise(t + offset + 10000);
  // Using map() to customize the range of Perlin noise
  float x = map(nx, 0, 1, 0, width);
  float y = map(ny, 0, 1, 0, height);
  //noStroke();
  stroke(50);
  fill(colour, 200);
  ellipse(x, y, 16, 16);

  t += 0.001;
}

color evolvingColour(int seed) {
  float hue, saturation, brightness;
  hue = noise((t+seed)+50000);
  saturation = noise(t + 1000);
  brightness = noise(t + 10000);
  colorMode(HSB, 1.0);
  return color(hue, saturation, brightness);
  
} // end evolvingColour()