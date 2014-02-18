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

import java.util.Map; // for the Map
import java.util.List; // for the Map
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.Date;
import java.util.TimeZone;

// Station name to ID map.
Map<Integer, Station> stationMap = new HashMap<Integer, Station>();

// A big list of all of the trips loaded into memory.
List<Trip> trips = new ArrayList<Trip>();

void setup()
{
  loadStations(); // load stations in to our station map.
  loadTrips(10000); // Set 10000 to -1 to load all trips.
}

void draw()
{
  // hmmmmm .... what to draw ... :)
}

void loadTrips(int numberOfTripsToLoad)
{
  BufferedReader reader = null;

  // We choose this format because it is easy to import into databases.
  SimpleDateFormat inputDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
  inputDateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));

  try 
  {
    // Create a reader to read our trip data.
    reader = createReader("Divvy_Trips_2013_Preprocessed.csv");    

    // Consume the header
    String line = reader.readLine(); 

    // Keep a count of the lines for progress feedback.
    int lineCount = 0;

    // This while loop reads a new line (delimited by a new line character)
    // until the line is null (meaning the reader has reached the end).
    while ( (line = reader.readLine ()) != null) 
    {
      // Keep a count of the current line.
      lineCount++;

      // Only load a small set of trips.
      if (numberOfTripsToLoad != -1 && lineCount > numberOfTripsToLoad) break;

      // A sanity counter to see if we are making progress.
      // This will print a message every 10000 lines.
      if (lineCount % 10000 == 0) println("Num lines processed: " + lineCount);

      // Create an array of Strings split
      String[] columns = split(line, ",");

      // Parse the raw start time for conversion.
      Date startTime = inputDateFormat.parse(columns[1]);

      // Parse the raw end time for conversion.
      Date endTime = inputDateFormat.parse(columns[2]);

      int bikeId = int(columns[3]);
      int fromStationId = int(columns[4]);

      Station fromStation = stationMap.get(fromStationId); 

      int toStationId = int(columns[5]);

      Station toStation = stationMap.get(toStationId); 

      String userType = columns[6];
      String gender = columns[7];

      int birthYear = int(columns[8]);

      Trip trip = new Trip(startTime, endTime, fromStation, toStation, userType, gender, birthYear);

      trips.add(trip);
    }
  }
  catch (IOException e) 
  {
    e.printStackTrace();
  } 
  catch (ParseException e) 
  {
    e.printStackTrace();
  } 
  finally 
  {
    try 
    {
      reader.close();
    } 
    catch (IOException e) 
    {
      e.printStackTrace();
    }
  }

  println("Number of trips Loaded: " + trips.size());
}


void loadStations()
{
  BufferedReader reader = null;

  try 
  {
    // Create a reader to read our trip data.
    reader = createReader("Divvy_Stations_2013_Preprocessed.csv");    

    // Consume the header line so it isn't processed as if it's data.
    String line = reader.readLine(); 

    // This while loop reads a new line (delimited by a new line character)
    // until the line is null (meaning the reader has reached the end).
    while ( (line = reader.readLine ()) != null) 
    {
      // Create an array of Strings split
      String[] columns = split(line, ",");

      int id = int(columns[0]);
      String name = columns[1];
      float latitude = float(columns[2]);
      float longitude = float(columns[3]);
      int capacity = int(columns[4]);

      Station station = new Station(id, name, latitude, longitude, capacity);

      // Place our station in our station map.
      stationMap.put(id, station);
    }
  }
  catch (IOException e) 
  {
    e.printStackTrace();
  } 
  finally 
  {
    try 
    {
      reader.close();
    } 
    catch (IOException e) 
    {
      e.printStackTrace();
    }
  }

  println("Number of Stations Loaded: " + stationMap.size());
}

