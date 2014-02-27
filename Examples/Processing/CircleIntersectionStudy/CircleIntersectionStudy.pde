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

Circle a;
Circle b;
Circle c;

void setup()
{
  size(800, 800);

  float padding = 300;
  float radius = (height - padding * 2.0) / 2.0;

  a = new Circle(new PVector(height / 2.0, padding + radius), radius); 
  b = new Circle(new PVector(height / 2.0, padding + radius), radius / 2);
  c = new Circle(new PVector(height / 2.0, padding), radius / 2);
}

void draw()
{
  background(0);

  b.x = mouseX;
  b.y = mouseY;

  noFill();
  stroke(255);

  // Draw our two large circles.
  ellipse(a.x, a.y, a.getRadius() * 2, a.getRadius() * 2);
  ellipse(b.x, b.y, b.getRadius() * 2, b.getRadius() * 2);
  ellipse(c.x, c.y, b.getRadius() * 2, c.getRadius() * 2);

  // Calculate our intersections.
  PVector[] intersectionsAB = a.getIntersectionsWith(b);

  // If there are any intersections, then draw them.
  if (intersectionsAB != null)
  {
    stroke(255, 255, 0);
    ellipse(intersectionsAB[0].x, intersectionsAB[0].y, 20, 20);
    ellipse(intersectionsAB[1].x, intersectionsAB[1].y, 20, 20);
  }

  // Calculate our intersections.
  PVector[] intersectionsBC = b.getIntersectionsWith(c);

  // If there are any intersections, then draw them.
  if (intersectionsBC != null)
  {
    stroke(0, 255, 0);
    ellipse(intersectionsBC[0].x, intersectionsBC[0].y, 20, 20);
    ellipse(intersectionsBC[1].x, intersectionsBC[1].y, 20, 20);
  }
}

