public class StationMarker extends SimplePointMarker 
{
  Station _station;

  public StationMarker(Station station) {
    super(new Location(station.getLatitude(), station.getLongitude()));
    _station = station;
  }

  public void draw(PGraphics pg, float x, float y) 
  {  
    // Make it pulse for no reason in particular.
    float time = (millis() % 1000) / 1000.0f;
    float size = sin(time * PI);
    size *= size; // Square the sin wave to keep it all positive.

    pg.pushStyle();
    pg.noStroke();
    pg.fill(255, 255, 0, 100);
    pg.ellipse(x, y, 40*size + 5, 40*size + 5);
    pg.fill(255, 100);
    pg.ellipse(x, y, 30*size, 30*size);
    pg.popStyle();
  }
}

