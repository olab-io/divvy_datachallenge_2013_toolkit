// via http://jeffreysambells.com/2010/05/27/decoding-polylines-from-google-maps-direction-api-with-java
private List<Location> decodePoly(String encoded) 
{
  List<Location> poly = new ArrayList<Location>();
  int index = 0, len = encoded.length();
  int lat = 0, lng = 0;

  while (index < len) {
    int b, shift = 0, result = 0;
    do {
      b = encoded.charAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } 
    while (b >= 0x20);
    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    shift = 0;
    result = 0;
    do {
      b = encoded.charAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } 
    while (b >= 0x20);
    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;

    //      Location p = new Location((int) (((double) lat / 1E5) * 1E6), (int) (((double) lng / 1E5) * 1E6));
    Location p = new Location(lat / 1E6, lng / 1E6);
    poly.add(p);
  }

  return poly;
}


public Route RouteFromCSV(String csv)
{
  println(csv);

  // Create an array of Strings split
  String[] columns = PApplet.split(csv, ",");

  if (columns.length < 3 || columns[0].length() <= 0 && columns[1].length() <= 0)
  {
    return new Route(0, 0, "");
  }

  int fromStationId = Integer.parseInt(columns[0]); // The station id.
  int toStationId = Integer.parseInt(columns[1]); // The station id.

  int totalTime = 0;
  int totalDistance = 0;

  String encodedPolyline = columns[4];

  if (encodedPolyline.length() > 0 && columns[2].length() > 0 && columns[3].length() > 0 )
  {
    totalTime = Integer.parseInt(columns[2]);
    totalDistance = Integer.parseInt(columns[3]);
  }

  return new Route(totalTime, totalDistance, encodedPolyline);
}

