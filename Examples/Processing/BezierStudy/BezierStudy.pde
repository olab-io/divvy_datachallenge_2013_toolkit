InteractiveObjectManager manager;

BezierAnchorPointHandle anchorPoint0;
BezierAnchorPointHandle anchorPoint1;

BezierControlPointHandle controlPoint0;
BezierControlPointHandle controlPoint1;

float t = 0;
float dt = 0.01;


void setup()
{
  size(600, 600);
  smooth();

  manager = new InteractiveObjectManager(this);

  anchorPoint0 = new BezierAnchorPointHandle(new PVector(width * 0.25, height * 0.25), 10);
  anchorPoint1 = new BezierAnchorPointHandle(new PVector(width * 0.75, height * 0.75), 10);

  manager.add(anchorPoint0);
  manager.add(anchorPoint1);

  controlPoint0 = new BezierControlPointHandle(new PVector(width * 0.5, height * 0.25), 5);
  controlPoint1 = new BezierControlPointHandle(new PVector(width * 0.5, height * 0.75), 5);

  manager.add(controlPoint0);
  manager.add(controlPoint1);
}

void draw()
{
  background(0);

  if (t > 1 || t < 0) 
  {
    dt *= -1;
  }

  t += dt; // Move time forward

  noFill();
  stroke(255, 200);

  dashedLine(controlPoint0, anchorPoint0, 6, 4);
  dashedLine(controlPoint1, anchorPoint1, 6, 4);

  stroke(255, 200);
  bezier(anchorPoint0, controlPoint0, anchorPoint1, controlPoint1);

  bezier(anchorPoint0, controlPoint0, anchorPoint1, controlPoint1);

  PVector p = bezierPoint(anchorPoint0, controlPoint0, anchorPoint1, controlPoint1, t);

  stroke(255);
  noFill();

  // Make it pulse for no reason in particular.
  float time = (millis() % 1000) / 1000.0f;
  float pulser = sin(time * PI);
  float size = map(pulser, -1, 1, 3, 10);

  pushMatrix();
  translate(p.x, p.y);
  rotate(map(t, -1, 1, - TWO_PI, TWO_PI));
  
  ellipse(0, 0, size, size);

  int numRays = 8;

  color rayColor = lerpColor(color(255, 255, 0), color(255, 180, 0, 180), pulser);

  stroke(rayColor);
  
  for (int i = 0; i < numRays; i++)
  {
    pushMatrix();
    rotate(i / (float) numRays * TWO_PI); 
    translate(size + 2, 0);
    line(0, 0, size, 0);
    translate(size + 5, 0);
    ellipse(0, 0, 4, 4);
    popMatrix();
  }

  popMatrix();


  manager.draw();
}  

void bezier(PVector anchorPoint0, PVector controlPoint0, PVector anchorPoint1, PVector controlPoint1)
{
  bezier(anchorPoint0.x, anchorPoint0.y, controlPoint0.x, controlPoint0.y, controlPoint1.x, controlPoint1.y, anchorPoint1.x, anchorPoint1.y);
}

PVector bezierPoint(PVector anchorPoint0, PVector controlPoint0, PVector anchorPoint1, PVector controlPoint1, float t)
{
  float x = bezierPoint(anchorPoint0.x, controlPoint0.x, controlPoint1.x, anchorPoint1.x, t);
  float y = bezierPoint(anchorPoint0.y, controlPoint0.y, controlPoint1.y, anchorPoint1.y, t);

  return new PVector(x, y);
}

void dashedLine(PVector p0, PVector p1, float dashLength, float blankLength)
{
  float distance = PVector.dist(p0, p1); // this is the distance between the points

  float position = distance; // we will slowly 

  int dashCount = 0;

  while (position > 0)
  {  
    if (dashCount % 2 == 0)
    {
      if ((position - dashLength) > 0) 
      {
        PVector _p0 = PVector.lerp(p0, p1, position / distance);

        position -= dashLength;

        PVector _p1 = PVector.lerp(p0, p1, position / distance);

        line(_p0.x, _p0.y, _p1.x, _p1.y);
      }
      else 
      {
        break;
      }
    }
    else
    {
      // blank 
      if ((position - blankLength) > 0) 
      {
        position -= blankLength;
      }
      else 
      {
        break;
      }
    }
    dashCount++;
  }
}

