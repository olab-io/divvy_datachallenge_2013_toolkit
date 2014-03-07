
class Route extends SimpleLinesMarker
{
  int totalDistance;
  int totalTime;

  int toStationId;
  int fromStationId;

  public Route()
  {
  }

  public Route(int toStationId, int fromStationId, String encodedRoutePoly)
  {
    addLocations(decodePoly(encodedRoutePoly));
    this.toStationId = toStationId;
    this.fromStationId = fromStationId;
  }

  public void draw(PGraphics pg, List<MapPosition> mapPositions) 
  {  
//    // Make it pulse for no reason in particular.
//    float time = (millis() % 1000) / 1000.0f;
//    float size = sin(time * PI);
//    size *= size; // Square the sin wave to keep it all positive.

    pg.pushStyle();
    pg.stroke(255,127);
    pg.noFill();
    pg.beginShape();
    for (MapPosition position : mapPositions)
    {
        pg.vertex(position.x, position.y);
    }
    pg.endShape();

    pg.popStyle();
  }

  String toString()
  {
    String result = "";

    for (Location location : getLocations())
    {
      result += location;
    }

    return result;
  }
}

