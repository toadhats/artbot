import java.util.Random;

color BGCOL = color(40);
Random generator;
float t; // global "timeline", mainly used for the noise function. *MUST be incremented in the draw function.*

boolean pause;

/** Input **/
int mouseWheel;

// Toggling a pause, keep the draw loop wrapped in a conditional
void mouseClicked() {

  if (pause) {
    pause = false;
  } else {
    pause = true;
  }
} // end mouseClicked()

void mouseWheel(MouseEvent event) {

  if (event.getCount() + mouseWheel >= 0 && event.getCount() + mouseWheel <= 255) { // ignore input that would take us out of bounds 
    mouseWheel = (mouseWheel + event.getCount()) % 256;
  } // end if
  println(mouseWheel);
} // end mouseWheel()


/**
 #KEYS#
 
 Backspace = Clear screen
 Shift + s = Save current image to file
 **/
void keyPressed() {
  println("" + key);
  switch (key) {
  case BACKSPACE:
    background(BGCOL); // BACKSPACE clears the screen
    break;
  case 'S':
    export();
    break;
  default:
    break;
  }
}

void setup() {
  pause = false;
  size(800, 800);
  frameRate(120);
  background(BGCOL);
  generator = new Random();
  t = 0;

  // Draw once, background.
} // end setup()

/**
 So far the idea is just to sloppily rewrite this section for each different image/idea, 
 code as art? The individual functions are the serious part.
 **/
void draw() {
  surface.setTitle(int(frameRate) + " fps");

  if (!pause) {
    //fade(10);
    //drip();
    //color squiggleColour1 = evolvingColour(5);
    //color squiggleColour2 = evolvingColour(69);
    //squiggle(squiggleColour1, 1);
    //squiggle(squiggleColour2, 5);

    float increment = frameCount * 0.01; // this is incrementing btw
    colorMode(HSB, 255);
    signal(color(frameCount % 256, 185, 200, 85), (mouseWheel + 1) * 0.001, increment);



    t += 0.001; // moved this to the end of the whole draw loop since multiple functions share it
  } // end pause condition
}// end draw()

/**
 Distributes shapes (circles) evenly around a centre point using a Gaussian distribution.
 **/
void drip() { 
  float sd = 80;
  float mean = 400;
  float xnum = (float) generator.nextGaussian();
  float ynum = (float) generator.nextGaussian();


  float x = sd * xnum + mean;
  float y = sd * ynum + mean;

  colorMode(RGB, 255);
  noStroke();
  fill(15, 10);
  ellipse(x, y, 16, 16);
} // end drip()

/** 
 Kinda 'scribbles' randomly, as if with a permanent marker. Looks cool with evolving colour.
 The offset allows multiple squigglers to be instantiated without giving each its own
 t value for the perlin noise function. Without different offsets, they'd follow the same path,
 which is generally not what I want. Each call draws a single point along the path, so call in a
 loop
 **/
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
} // end squiggle();

/**
 Draws a squiggly line across the page. Like a squiggler, but the x moves from
 left to right, while the y value is randomized over time via perlin noise. Draws
 one whole line per call, unlike the squiggler. 
 
 Uses its x-coord as a t value, which means we're basically graphing the 
 perlin function.Offset determines what 'part' of the perlin space we're 
 graphing. Scale controls the speed through perlin space, ie 'jaggedness'.
 **/
void signal(color colour, float scale, float offset) {
  for (int x = 0; x <= width; x++) {
    float ny = noise((x * scale) + offset);
    float y = map(ny, 0, 1, 0, height); // Todo: constrain the line to a range so its more squiggle than scribble
    noStroke();
    fill(colour, 200);
    ellipse(x, y, 8, 8);
  } // end for
} // end signal




/** #COLOUR FUNCTIONS# **/

/** 
 Transitions between colours in a Perlin noise pattern
 Specifying the seed is basically the only way to influence 
 the colours you'll get
 **/
color evolvingColour(int seed) {
  float hue, saturation, brightness;
  hue = noise((t+seed)+50000);
  saturation = noise(t + 1000);
  brightness = noise(t + 10000);
  colorMode(HSB, 1.0);
  return color(hue, saturation, brightness);
} // end evolvingColour()

/** #UTILITY FUNCTIONS# **/

/** 
 Draws a semitransparent background, which fades everything on 
 screen by a given amount
 **/
void fade(int amount) {
  fill(BGCOL, amount);
  rect(0, 0, width, height);
}// end fade

void export() {
  save("img/"+timestamp()+".png");
  println("Saved to img/");
}// end export()

String timestamp() {
  String timestamp = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
  return timestamp;
}// End timestamp