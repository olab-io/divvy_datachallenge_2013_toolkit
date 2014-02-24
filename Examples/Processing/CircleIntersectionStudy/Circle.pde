// This class represents a Circle and can do some math
// with those circles.   
public class Circle extends PVector
{
  float _radius;

  public Circle(PVector position, float radius)
  {
    super(position.x, position.y, position.z); // Call the PVector super constructor
    _radius = radius;
  }

  void setRadius(float radius)
  {
    _radius = radius;
  }

  float getRadius()
  {
    return _radius;
  }

  // Returns null if there are no intersections.
  // Otherwise, returns an array of two PVectors.
  public PVector[] getIntersectionsWith(Circle other)
  {
    // Reference http://paulbourke.net/geometry/circlesphere/tvoght.c
    float x0 = x;
    float y0 = y;

    float x1 = other.x;
    float y1 = other.y;

    float r0 = _radius;
    float r1 = other._radius;

    float a, dx, dy, d, h, rx, ry;
    float x2, y2;

    // dx and dy are the vertical and horizontal distances between
    // the circle centers.
    dx = x1 - x0;
    dy = y1 - y0;

    // Determine the straight-line distance between the centers.
    d = (float)Math.hypot(dx, dy);

    // Check for solvability. 
    if (d > (r0 + r1))
    {
      // no solution. circles do not intersect. 
      return null;
    }
    if (d < abs(r0 - r1))
    {
      // no solution. one circle is contained in the other 
      return null;
    }

    // 'point 2' is the point where the line through the circle
    //  intersection points crosses the line between the circle
    //  centers.  

    // Determine the distance from point 0 to point 2. 
    a = ((r0*r0) - (r1*r1) + (d*d)) / (2.0 * d) ;

    // Determine the coordinates of point 2.
    x2 = x0 + (dx * a/d);
    y2 = y0 + (dy * a/d);

    // Determine the distance from point 2 to either of the intersection points.
    h = sqrt((r0*r0) - (a*a));

    // Now determine the offsets of the intersection points from point 2.
    rx = -dy * (h/d);
    ry = dx * (h/d);

    PVector[] intersections = new PVector[2];

    intersections[0] = new PVector(x2 + rx, y2 + ry);
    intersections[1] = new PVector(x2 - rx, y2 - ry);

    return intersections;
  }
}

