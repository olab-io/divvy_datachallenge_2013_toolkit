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

import java.util.List;
import java.util.Map;
import java.util.Date;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;

// Station name to ID map.
HashMap<Integer, Station> stationMap = new HashMap<Integer, Station>();

// Our map
UnfoldingMap map;

// Home location
Location chicagoLocation = new Location(41.883, -87.632);



void setup() 
{
  size(600, 800, P2D);
  frameRate(60);

  String mbTilesString = sketchPath("data/blank-1-3.mbtiles");

  //  map = new UnfoldingMap(this);
  map = new UnfoldingMap(this, new MBTilesMapProvider(mbTilesString));
  map.zoomAndPanTo(chicagoLocation, 12);
  MapUtils.createDefaultEventDispatcher(this, map);

  loadStations();
  loadRoutes();
}

void draw()
{
  background(0);
  map.draw();

  ScreenPosition mousePosition = new ScreenPosition(mouseX, mouseY);
  Location mouseLocation = map.getLocation(mousePosition);
}

void keyPressed()
{
  switch(key)
  {
  case 'w':
    break;
  case 's':
    break;
  case 'a':
    break;
  case 'd':
    break;
  }
}

void loadRoutes()
{
  try 
  {
    BufferedReader reader = createReader("mini.csv");    
    // Consume the header line so it isn't processed as if it's data.
    String line = reader.readLine(); 

    // Cycle through the rest of the rows.
    while ( (line = reader.readLine ()) != null) 
    {
      Route route = RouteFromCSV(line);

    map.addMarker(route);
    }

    reader.close();
    reader = null;
  }
  catch(IOException e) 
  {
    e.printStackTrace();
  }
}

void loadStations()
{
  JSONArray stationsJSON = loadJSONArray("stations.json");

  for (int i = 0; i < stationsJSON.size(); i++) {

    JSONObject stationJSON = stationsJSON.getJSONObject(i);

    int id = stationJSON.getInt("id");
    String name = stationJSON.getString("name");
    float latitude = stationJSON.getFloat("latitude");
    float longitude = stationJSON.getFloat("longitude");
    int capacity = stationJSON.getInt("capacity");

    // TODO: upate for new data format
    Station station = new Station(id, name, latitude, longitude, capacity, -1, new Date());

    stationMap.put(id, station);
    StationMarker stationMarker = new StationMarker(station);

    map.addMarker(stationMarker);
  }
}

