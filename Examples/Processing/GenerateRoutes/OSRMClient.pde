class OSRMClient
{
  final static String baseURL = "http://127.0.0.1:5000"; 
  final static String nearestEndpoint = baseURL + "/nearest?"; 
  final static String locateEndpoint = baseURL + "/locate?"; 
  final static String viarouteEndpoint = baseURL + "/viaroute?";


  // Find the nearest location
  NamedLocation nearest(Location location) 
  {
    JSONObject results = loadJSONObject(nearestEndpoint + toLoc(location));

    JSONArray loc = results.getJSONArray("mapped_coordinate");

    float latitude = loc.getFloat(0);
    float longitude = loc.getFloat(1);

    return new NamedLocation(results.getString("name"), latitude, longitude);
  }

  // Find the nearest node
  Location locate(Location location) 
  {
    JSONObject results = loadJSONObject(locateEndpoint + toLoc(location));

    JSONArray loc = results.getJSONArray("mapped_coordinate");

    float latitude = loc.getFloat(0);
    float longitude = loc.getFloat(1);

    return new Location(latitude, longitude);
  }

  Route getRoute(List<Location> viaPoints)
  {
    String url = viarouteEndpoint;
    for (int i = 0; i < viaPoints.size(); ++i)
    {
      url += toLoc(viaPoints.get(i));

      if (i < viaPoints.size() - 1)
      {
        url += "&";
      }
    }

    url += "&alt=false";
    url += "&instructions=false";
    url += "&output=json";

    JSONObject results = loadJSONObject(url);

    println(results);

    String routeGeometry = results.getString("route_geometry");

    JSONObject routeSummary = results.getJSONObject("route_summary");

    int totalDistance = routeSummary.getInt("total_distance");
    int totalTime = routeSummary.getInt("total_time");
    String startPointName = routeSummary.getString("start_point");
    String endPointName = routeSummary.getString("end_point");

    JSONObject hintData = results.getJSONObject("hint_data");

    int hintChecksum = hintData.getInt("checksum");



    println(totalDistance);
    println(totalTime);


    return new Route(routeGeometry);
  }
}

