// =============================================================================
//
// Copyright (c) 2014 Christopher Baker <http://christopherbaker.net>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// =============================================================================

// The interactive object manager keeps track of gui interactions.
// We add objects to the manager to keep track of them.
InteractiveObjectManager manager;

// These are square handles.
BezierAnchorPointHandle anchorPoint0;
BezierAnchorPointHandle anchorPoint1;

// These are round handles.
BezierControlPointHandle controlPoint0;
BezierControlPointHandle controlPoint1;

void setup()
{
  size(600, 600);
  smooth();

  // Initialize the manager.  Passing "this" allows the 
  // manager to automatically listen to mouse and keyboard events.
  manager = new InteractiveObjectManager(this);

  // Initialize the anchor points.
  anchorPoint0 = new BezierAnchorPointHandle(new PVector(width * 0.25, height * 0.25), 10);
  anchorPoint1 = new BezierAnchorPointHandle(new PVector(width * 0.75, height * 0.75), 10);

  // Add the points to the manager.
  manager.add(anchorPoint0);
  manager.add(anchorPoint1);

  // Initialize the control points.
  controlPoint0 = new BezierControlPointHandle(new PVector(width * 0.5, height * 0.25), 5);
  controlPoint1 = new BezierControlPointHandle(new PVector(width * 0.5, height * 0.75), 5);

  // Add the points to the manager.
  manager.add(controlPoint0);
  manager.add(controlPoint1);
}

void draw()
{
  background(0);

  // Make get a timer
  float time = (millis() % 2000) / 2000.0f;
  
  // This will take t from 0 -> 1 -> 0
  float t = sin(time * PI);
  
  // Just draw the stroked line.
  noFill();
  stroke(255, 200);

  // Demo a function for drawing dashed lines.
  dashedLine(controlPoint0, anchorPoint0, 6, 4);
  dashedLine(controlPoint1, anchorPoint1, 6, 4);

  stroke(255, 200);
  
  // Draw the bezier curve using the helper function.
  bezier(anchorPoint0, controlPoint0, anchorPoint1, controlPoint1);

  // We make our own bezier point method that will allow us to 
  // calculate a bezier point using PVectors, which is a bit cleaner.
  PVector p = bezierPoint(anchorPoint0, controlPoint0, anchorPoint1, controlPoint1, t);

  // Just draw outlines.
  stroke(255);
  noFill();
  
  // Push the matrix for drawing the rotating point.
  pushMatrix();
  
  // Translate the object.
  translate(p.x, p.y);
  
  // Map the rotation 0 -> 1 mapped to -2PI->2PI
  float rotation = map(t, 0, 1, - TWO_PI, TWO_PI);
  
  // Rotate the object.
  rotate(rotation);

  // Map a changing size to the t value.
  float size = map(t, 0, 1, 0, 20);

  // draw the central circle.
  ellipse(0, 0, size, size);

  // change color based on position
  color rayColor = lerpColor(color(255, 0, 0, 180), color(255, 255, 0, 255), t);

  stroke(rayColor);
  
  int numRays = 8;
  for (int i = 0; i < numRays; i++)
  {
    // Push a new matrix just for the arm.
    pushMatrix();
    
    // Rotate to draw each "arm".
    rotate(i / (float) numRays * TWO_PI); 
    
    // Move out away from the center circle.
    translate(size + 2, 0);
    
    // Draw the arm.
    line(0, 0, size, 0);
    
    // Move to the end of the arm.
    translate(size + 5, 0);
    
    // Draw a little circle at the end of the arm.
    ellipse(0, 0, 3, 3);
    
    // Pop the matrix that was used to isolate the arm.
    popMatrix();
  }

  // Pop the point rotation.
  popMatrix();

  
  // Draw all of the interactive objects managed by the interactive object manager.
  manager.draw();
}  

// Our custom function to make it a little easier to draw a bezier curve.
void bezier(PVector anchorPoint0, PVector controlPoint0, PVector anchorPoint1, PVector controlPoint1)
{
  bezier(anchorPoint0.x, anchorPoint0.y, controlPoint0.x, controlPoint0.y, controlPoint1.x, controlPoint1.y, anchorPoint1.x, anchorPoint1.y);
}

// Combine two operations into one simple operation.
PVector bezierPoint(PVector anchorPoint0, PVector controlPoint0, PVector anchorPoint1, PVector controlPoint1, float t)
{
  float x = bezierPoint(anchorPoint0.x, controlPoint0.x, controlPoint1.x, anchorPoint1.x, t);
  float y = bezierPoint(anchorPoint0.y, controlPoint0.y, controlPoint1.y, anchorPoint1.y, t);
  return new PVector(x, y);
}

// Draw a dashed line.
void dashedLine(PVector p0, PVector p1, float dashLength, float blankLength)
{
  // What is the total distance between the two points?
  float distance = PVector.dist(p0, p1);

  float position = distance; // we will slowly remove this position until it is 0.

  // Count the number of dashes / blanks.
  int dashCount = 0;

  // Keep moving forward until we have moved the full distance.
  while (position > 0)
  {  
    // If the dash count is event, then ...
    if (dashCount % 2 == 0)
    {
      // Check to see if we will go to far if we make this move.
      if ((position - dashLength) > 0) 
      {
        // Get the first point by lerping between the two input points p0 and p1
        PVector _p0 = PVector.lerp(p0, p1, position / distance);

        // Remove the dash length from the current position.
        position -= dashLength;

        // Get the first point by lerping between the two input points p0 and p1 @ new location.
        PVector _p1 = PVector.lerp(p0, p1, position / distance);

        // Draw the line using the two points.
        line(_p0.x, _p0.y, _p1.x, _p1.y);
      }
      else 
      {
        // The next line would have gone too far.
        break;
      }
    }
    // The dash count was odd, meaning it's a blank.
    else
    {
      // Check to see if we will go to far if we make this move.
      if ((position - blankLength) > 0) 
      {
        // Move along, but don't draw anything.
        position -= blankLength;
      }
      else 
      {
        break;
      }
    }
    // Increment the dash count.
    dashCount++;
  }
}

