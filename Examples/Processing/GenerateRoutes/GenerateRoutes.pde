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
import java.util.Collection;
import java.util.Date;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.utils.*;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

ThreadPoolExecutor executor = (ThreadPoolExecutor) Executors.newFixedThreadPool(8);

final static String viaRouteEndpoint = "http://127.0.0.1:5000/viaroute?"; 

//final static String viaRouteEndpoint = "http://router.project-osrm.org/viaroute?"; 


// Station name to ID map.
Map<Integer, Station> stationMap = new HashMap<Integer, Station>();

// OSRM Client
OSRMClient client = new OSRMClient();

// Create a print writer.
PrintWriter output = null;

void setup() 
{
  size(600, 800);
  frameRate(1);

  loadStations();

  // Create a write to write our processed data to a new CSV file.
  // dataPath() places the file inside the data folder.
  output = createWriter(dataPath("routes.csv")); 

  output.println("from_station_id,to_station_id,total_time,total_distance,route_geometry,route_index"); // write header

  ArrayList<Station> stations = new ArrayList<Station>(stationMap.values());

  for (int fromIndex = 0; fromIndex < stations.size(); ++fromIndex)
  {
    Station fromStation = stations.get(fromIndex);

    Location fromStationLocation = new Location(fromStation.getLatitude(), fromStation.getLongitude());

    NamedLocation fsl = client.nearest(fromStationLocation);
    
    println("");
    println(fromStationLocation + "=?" + fsl);

    String fromStationLocationHint = null;

    int hintChecksum = 0;

    println("");
    println("From: " + fromStation.getId());


    for (int toIndex = 0; toIndex < stations.size(); ++toIndex)
    {
      Station toStation = stations.get(toIndex);

      print(".");


      if (fromStation.getId() != toStation.getId())
      {
        Location toStationLocation = new Location(toStation.getLatitude(), toStation.getLongitude());

        String url = viaRouteEndpoint;

        url += toLoc(fromStationLocation);

        if (fromStationLocationHint != null)
        {
          url += ("&hint=" + fromStationLocationHint);
        }

        url += "&" + toLoc(toStationLocation);

        //        url += "&alt=false";
        url += "&instructions=false";
        url += "&output=json";

        if (hintChecksum != 0)
        {
          url += ("&checksum=" + hintChecksum);
        }
 
        JSONObject results = loadJSONObject(url);

//        println("----------------------------------------------------------------------");
//        println(results);
//        println("----------------------------------------------------------------------");

        JSONArray alternativeSummaries = results.getJSONArray("alternative_summaries");
        JSONArray alternativeGeometries = results.getJSONArray("alternative_geometries");

        for (int i = 0; i < alternativeSummaries.size(); ++i)
        {
          
        }

        String routeGeometry = results.getString("route_geometry");
        JSONObject routeSummary = results.getJSONObject("route_summary");
        int totalDistance = routeSummary.getInt("total_distance");
        int totalTime = routeSummary.getInt("total_time");
        String startPointName = routeSummary.getString("start_point");
        String endPointName = routeSummary.getString("end_point");

        JSONObject hintData = results.getJSONObject("hint_data");
        JSONArray hintLocations = hintData.getJSONArray("locations");

        fromStationLocationHint = hintLocations.getString(0); // get start location hint

        hintChecksum = hintData.getInt("checksum");

        if (routeGeometry.length() <= 0)
        {
          // unable to find a route
          output.println(fromStation.getId() + "," + toStation.getId() + ",,," + routeGeometry);
        }  
        else
        {
          output.println(fromStation.getId() + "," + toStation.getId() + "," + totalTime + "," + totalDistance + "," + routeGeometry);
        }
      }
    }
  }
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
}

public void keyPressed() {
  System.out.println(executor.isShutdown() + " " + executor.isTerminated());

  switch (key) {

  case 'q':
    BlockingQueue<Runnable> q = executor.getQueue();
    println("-------- Q --------");
    println("in Q = " + q.size());
    println(" ACTIVE=" + executor.getActiveCount());
    println(" TOTAL COMPLETED: " + executor.getCompletedTaskCount());


    break;

  case '1':

    executor.shutdown();
    break;

  case '2':
    List<Runnable> remaining = executor.shutdownNow();

    for (Runnable l : remaining)
      System.out.println("Remaining: " + l.toString());
    break;

  case '3':

    break;

  case 'a':
//    executor.submit(new MyThread((int) random(7000)));
    break;
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

    if (id == 0)
    {
     println( stationJSON);
      
    }


    // TODO: upate for new data format
    Station station = new Station(id, name, latitude, longitude, capacity, -1, new Date());

    stationMap.put(id, station);
  }
}

