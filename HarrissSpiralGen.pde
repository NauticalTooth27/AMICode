/*
 * Author: Ryan Polhemus
 * Creates a Harriss spiral with a set number of iterations
 * Each iteration takes a rectangle with a ratio of 1.32472 between its sides, and divides it into two similar rectangles and a square
 * The arcs are drawn inside of the squares, to the bordering "blue" rectangles 
 * (the blue rectangle is the vertical one in the first iteration, and the orange one is the horizontal one, visible if you turn on squares)
 * Inspiration from this thread: http://community.wolfram.com/groups/-/m/t/430342
 */

float ratioA = 0.56984; //Ratio of blue section to whole side
float ratioB = 0.43016; //Ratio of orange section to whole side
int iter = 1; 

//Edit these
int maxIter = 12;
int iterTime = 1500;
boolean showSquares = true;
color backgroundColor   = color(255, 255, 255); //white; default 255, 255, 255
color majorColor        = color(0, 0, 255); //blue; default 0, 0, 255
color minorColor        = color(255, 184, 0); //orange; default 255, 184, 0

void setup()
{
  colorMode(RGB);
  size(1400,1500);
  background(200,200,200);
  //HarrissSpiral(0, showSquares); 
}

void draw()
{
  if(iter < maxIter)
  {
    HarrissSpiral(1, showSquares);
    waitTime(iterTime);
    iter++;
    print(iter);
  }
}

void waitTime(int mSecs)
{
  int start = millis();
  while(millis() < start + mSecs){}
}

void HarrissSpiral(int rep, boolean squares)
{
  int scale = 5; //Scale of fractal
  PVector upperLeft = new PVector(100,100); //Starting upper left corner of fractal
  translate(upperLeft.x,upperLeft.y);       //All iterations start with origin centered at top left of box
  
  HarrissSpiralStep(new PVector(0,0), new PVector((232.4718 * scale), (175.4878 * scale)), rep, squares);
}

void HarrissSpiralStep(PVector p, PVector q, int rep, boolean squares)
{
  //if(p.dist(q) > rep) //Other option for base case -> distance between vectors.. untested, should work in theory
  if(rep < iter)
  {
    float xLength = q.x-p.x;
    float yLength = q.y-p.y;
    
    float blueShort = xLength * ratioA; //Short side of blue rectangle
    float orangeShort = yLength * ratioB; //Short side of orange rectangle
    
    if(squares)
    {
      fill(backgroundColor);
      rect(p.x,p.y,xLength,yLength); //Fill entire current rectangle white
      
      fill(majorColor);
      rect(p.x,p.y,blueShort,yLength); //Fill blue rectangle
      
      
      fill(minorColor);
      rect(p.x+blueShort, p.y, xLength-blueShort, orangeShort); //Fill orange rectangle
    }
    
    if(rep != 0)
    {
      //Generate quarter circle
      noFill();
      strokeWeight(5);
      float side = yLength - orangeShort;
      arc(blueShort - side/2, q.y - side/2, side * sqrt(2), side * sqrt(2), -PI/4, PI/4);
      
      strokeWeight(5);
      arc(blueShort/2, q.y - blueShort/2, blueShort * sqrt(2), blueShort * sqrt(2), PI/4, 3*PI/4);
      
      
      strokeWeight(1);
    }
    
    rep++; //Incrementing before recursing
    
    translate(blueShort, 0); //Move origin to upper left of orange box
    HarrissSpiralStep(new PVector(p.x, p.y), new PVector(q.x-blueShort,p.y+orangeShort), rep, squares); //Next iteration for orange box
    translate(-blueShort,yLength);                                                                      //Move origin to bottom left of blue box, after rotation to be upper right
    rotate(-PI/2);                                                                                      //Rotate coordinate system, so origin is now in the upper left of blue box
    HarrissSpiralStep(new PVector(0,0), new PVector(yLength, blueShort), rep, squares);                 //Next iteration for blue box
    rotate(PI/2);                                                                                       //Here down resets coordinate system
    translate(blueShort,-yLength);
    translate(-blueShort, 0);
  }
}
