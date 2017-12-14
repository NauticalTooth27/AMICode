float ratioA = 0.56984;
float ratioB = 0.43016;
int iter = 8;

void setup()
{
  colorMode(RGB);
  size(2500,2500);
  background(200,200,200);
  HarrissSpiral(iter, true);
}

void draw()
{
  
}

void HarrissSpiral(int eps, boolean squares)
{
  int scale = 8;
  PVector upperLeft = new PVector(100,100);
  translate(upperLeft.x,upperLeft.y);
  
  HarrissSpiralStep(new PVector(0,0), new PVector((232.4718 * scale), (175.4878 * scale)), eps, squares);
  //println("seconds");
  //HarrissSpiralStep(new PVector(upperRight.x, upperRight.y + 300), new PVector(upperRight.x+232.4718, upperRight.y + 475.4878), 1);
}

void HarrissSpiralStep(PVector p, PVector q, int eps, boolean squares)
{
  //if(p.dist(q) > eps)
  if(eps > 0)
  {
    eps--;
    float xLength = q.x-p.x;
    float yLength = q.y-p.y;
    
    float blueShort, orangeShort = 0; //Initializing here, will always be changed in if/else
    
    blueShort = xLength * ratioA; //Terrible name, to change => short side of blue rect 
    orangeShort = yLength * ratioB; //Worse name, to change => short side of orange rect
    
    if(squares)
    {
      fill(255,255,255);
      rect(p.x,p.y,xLength,yLength); //Fill entire current rectangle white
      
      fill(0,0,255);
      rect(p.x,p.y,blueShort,yLength); //Fill blue rectangle
      
      fill(255,184,0);
      rect(p.x+blueShort, p.y, xLength-blueShort, orangeShort); //Fill orange rectangle
    }
    
    if(eps != iter - 1)
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
    
    println("bs: " + blueShort);
    translate(blueShort, 0);
    HarrissSpiralStep(new PVector(p.x, p.y), new PVector(q.x-blueShort,p.y+orangeShort), eps, squares);
    translate(-blueShort,yLength);
    rotate(-PI/2);
    HarrissSpiralStep(new PVector(0,0), new PVector(yLength, blueShort), eps, squares); //Inside blue rect
    rotate(PI/2);
    translate(blueShort,-yLength);
    translate(-blueShort, 0);
  }
}
