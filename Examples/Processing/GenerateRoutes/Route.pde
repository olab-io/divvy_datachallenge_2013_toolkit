class Route extends SimpleLinesMarker
{
  int totalDistance;
  int totalTime;

  public Route()
  {
  }

  public Route(String encodedRoutePoly)
  {
    addLocations(decodePoly(encodedRoutePoly));
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

