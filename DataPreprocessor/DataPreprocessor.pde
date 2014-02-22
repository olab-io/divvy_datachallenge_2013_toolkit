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

//import java.util.Map; // for the Map
import java.util.Collections;
import java.util.Comparator;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.Date;
import java.util.TimeZone;
//
void setup() {

  HashMap<Integer, Station> stationsMap = new HashMap<Integer, Station>();

  BufferedReader reader = null;
  PrintWriter output = null;

  String line;

  // This is the date format in stations.
  SimpleDateFormat stationDateFormat = new SimpleDateFormat("MM/dd/yy"); 
  stationDateFormat.setTimeZone(TimeZone.getTimeZone("America/Chicago"));

  println("Processing stations ...");

  ArrayList<Station> stations = new ArrayList<Station>();

  try 
  {
    // Create a reader to read our trip data.
    reader = createReader("Divvy_Stations_Trips_2013/Divvy_Stations_2013.csv");    

    // Create a write to write our processed data to a new CSV file.
    // dataPath() places the file inside the data folder.
    output = createWriter(dataPath("Divvy_Stations_Trips_2013/Divvy_Stations_2013_Preprocessed.csv")); 

    // Consume the header line so it isn't processed as if it's data.
    line = reader.readLine(); 

    // This while loop reads a new line (delimited by a new line character)
    // until the line is null (meaning the reader has reached the end).
    while ( (line = reader.readLine ()) != null) 
    {
      // Create an array of Strings split
      String[] columns = split(line, ",");

      int id = int(columns[0]); // The station id.
      String name = columns[1]; // The station name.
      float latitude = float(columns[2]); // The latitude.
      float longitude = float(columns[3]); // The longitude.
      int capacity = int(columns[4]); // The station capacity.
      int landmarkId = int(columns[5]); // The landmark id.
      Date onlineDate = stationDateFormat.parse(columns[6]); // The online date.

      // Add it to our array so we can sort them.

      Station station = new Station(id, name, latitude, longitude, capacity, landmarkId, onlineDate);
      stations.add(station);
      stationsMap.put(id, station);
    }

    Collections.sort(stations, new Comparator<Station>() 
    {
      public int compare(Station station0, Station station1) 
      {
        return station0.getOnlineDate().compareTo(station1.getOnlineDate());
      }
    }
    );

    output.println(Station.getCSVHeader()); // write header

      for (Station station : stations)
    {
      output.println(station.toCSV());
    }
  }
  catch (ParseException e) 
  {
    e.printStackTrace();
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
      output.flush(); // Writes the remaining data to the file
      output.close(); // Finishes the file
    } 
    catch (IOException e) 
    {
      e.printStackTrace();
    }
  }



  // This is the date format in the trips
  SimpleDateFormat tripDateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm"); 
  tripDateTimeFormat.setTimeZone(TimeZone.getTimeZone("America/Chicago"));

  // This is the date format we'd like to store.
  // We choose this format because it is easy to import into databases.
  SimpleDateFormat outDateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
  outDateTimeFormat.setTimeZone(TimeZone.getTimeZone("UTC"));

  println("Allocating trip memory ...");

  ArrayList<Trip> trips = new ArrayList<Trip>(800000);

  try 
  {
    // Create a reader to read our trip data.
    reader = createReader("Divvy_Stations_Trips_2013/Divvy_Trips_2013.csv");    

    // Create a write to write our processed data to a new CSV file.
    // dataPath() places the file inside the data folder.
    output = createWriter(dataPath("Divvy_Stations_Trips_2013/Divvy_Trips_2013_Preprocessed.csv")); 

    // Consume the header line so it isn't processed as if it's data.
    line = reader.readLine(); 

    // Keep a count of the lines for progress feedback.
    int lineCount = 0;

    // This while loop reads a new line (delimited by a new line character)
    // until the line is null (meaning the reader has reached the end).
    while ( (line = reader.readLine ()) != null) 
    {
      // Keep a count of the current line.
      lineCount++;

      // A sanity counter to see if we are making progress.
      // This will print a message every 10000 lines.
      if (lineCount % 5000 == 0) println("Num trips processed: " + lineCount);

      // Create an array of Strings split
      String[] columns = split(line, ",");

      int tripId = int(columns[0]);

      // Parse the raw start time for conversion.
      Date startTime = tripDateTimeFormat.parse(columns[1]);

      // Parse the raw end time for conversion.
      Date stopTime = tripDateTimeFormat.parse(columns[2]);

      int bikeId = int(columns[3]);

      // Currently the station list does not contain matching station ids.
      // Here we will create a map for later use when we clean the station list CSV.

      int fromStationId = int(columns[5]);
      int fromStationName = int(columns[6]);
      int toStationId = int(columns[7]);
      int toStationName = int(columns[8]);

      // Convert Male to M and Female to F
      String userType = columns[9];

      // Convert Male to M and Female to F
      if (userType.equalsIgnoreCase("Customer"))
      {
        userType = "C";
      } 
      else if (userType.equalsIgnoreCase("Subscriber"))
      {
        userType = "S";
      }

      // Convert Male to M and Female to F
      String gender = columns[10];

      if (gender.equalsIgnoreCase("Female"))
      {
        gender = "F";
      } 
      else if (gender.equalsIgnoreCase("Male"))
      {
        gender = "M";
      }

      int birthYear = int(columns[11]);


      Station fromStation = stationsMap.get(fromStationId);
      Station toStation = stationsMap.get(toStationId);

// Lots of these errors.
//      if (fromStation.getOnlineDate().getTime() > startTime.getTime())
//      {
//        println("Departure station didn't exist when ride started." + toStation.toCSV());
//      } 
//
//      if (toStation.getOnlineDate().getTime() > stopTime.getTime())
//      {
//        println("Arrival station didn't exist when ride started." + toStation.toCSV());
//      } 

      trips.add(new Trip(tripId, startTime, stopTime, bikeId, fromStation, toStation, userType, gender, birthYear));
    }

    println("Sorting collection of " + trips.size() + " trips...");

    Collections.sort(trips, new Comparator<Trip>() 
    {
      public int compare(Trip trip0, Trip trip1) 
      {
        return trip0.getStartTime().compareTo(trip1.getStartTime());
      }
    }
    );

    output.println(Trip.getCSVHeader()); // write header

      for (Trip trip : trips)
    {
      output.println(trip.toCSV());
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
      output.flush(); // Writes the remaining data to the file
      output.close(); // Finishes the file
    } 
    catch (IOException e) 
    {
      e.printStackTrace();
    }
  }

  /////////////////////////////////////////////////////////////////////////////////

  println("Preprocessing complete.");
  exit();
}

