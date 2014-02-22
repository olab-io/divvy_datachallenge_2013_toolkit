import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.Date;
import java.util.TimeZone;

public class DiskDataStore
{
  SimpleDateFormat outDateTimeFormat;

  // Station name to ID map.
  HashMap<Integer, Station> stationMap = new HashMap<Integer, Station>();

  // A big list of all of the trips loaded into memory.
  ArrayList<Trip> trips = new ArrayList<Trip>();

  // This is the number of trips that will be read in during 
  // a call to update.  Bugger chunk sizes will go more quickly
  // but also cause noticable lag on startup.
  int bufferChunkSize = 250; 

  // The persistante reader we'll use to read in our rows of trip data.
  BufferedReader tripsReader = null;

  // The location of our stations CSV file.
  String stationsPath = "Divvy_Stations_2013_Preprocessed.csv"; 

  // The location of our trips CSV file.
  String tripsPath = "Divvy_Trips_2013_Preprocessed.csv"; 

  // The total number of trips represented in our trips CSV file.
  int totalNumberOfTrips = 759789;

  // Constructor
  public DiskDataStore()
  {
    outDateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    outDateTimeFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
    loadStations();
  }

  public float bufferProgress()
  {
    return trips.size() / (float)totalNumberOfTrips;
  }

  public int getTotalNumberOfTrips()
  {
    return totalNumberOfTrips;
  }

  public int getNumTripsBuffered()
  {
    return trips.size();
  }  

  public int getNumStations()
  {
    return stationMap.size();
  }

  public ArrayList<Station> getStations()
  {
    return new ArrayList<Station>(stationMap.values());
  }

  public Trip getTripByArrayIndex(int index)
  {
    if (trips.isEmpty() || index >= trips.size()) 
    {
      return null;
    }
    else
    {
      return trips.get(index);
    }
  }

  public ArrayList<Trip> getTripsByStartTime(long minStartTime, long maxStartTime, int tripIndexHint)
  {
    ArrayList<Trip> tripsToReturn = new ArrayList<Trip>();

    int index = 0;

    if (tripIndexHint > 0 && 
      tripIndexHint < trips.size() && 
      trips.get(tripIndexHint - 1).getStartTime().getTime() < minStartTime)
    {
      index = tripIndexHint;
    }

    for (int i = index; i < trips.size(); i++)
    {
      Trip trip = trips.get(i);
      long startTime = trip.getStartTime().getTime();

      if (startTime > minStartTime && startTime <= maxStartTime)
      {
        tripsToReturn.add(trip);
      }

      if (startTime > maxStartTime) 
      {
        break;
      }
    }

    return tripsToReturn;
  }

  void update()
  {
    // If we have trips and we set our tripsReader back to null, 
    // then we know that we are done reading in new data.
    if (trips.size() > 0 && tripsReader == null) return;

    try 
    {
      String line = null;

      // First make sure we have an open reader.
      if (tripsReader == null)
      {
        // Create a reader to read our trip data.
        tripsReader = createReader(tripsPath);    

        // Consume the header
        line = tripsReader.readLine();
      }

      // Keep track of lines to read in this loop
      int linesToRead = bufferChunkSize;

      // This while loop reads a new line (delimited by a new line character)
      // until the line is null (meaning the reader has reached the end).
      while ( (line = tripsReader.readLine ()) != null && linesToRead > 0) 
      {
        linesToRead--;
        trips.add(TripFromCSV(line, stationMap));
      }

      if (line == null)
      {
        tripsReader.close();
        tripsReader = null;
      }
    }
    catch(IOException e) 
    {
      e.printStackTrace();
    }
  }

  void loadStations()
  {
    try 
    {
      BufferedReader reader = createReader(stationsPath);    
      // Consume the header line so it isn't processed as if it's data.
      String line = reader.readLine(); 

      // Cycle through the rest of the rows.
      while ( (line = reader.readLine ()) != null) 
      {
        Station station = StationFromCSV(line);
        // Place our station in our station map.
        stationMap.put(station.getId(), station);
      }

      reader.close();
      reader = null;
    }
    catch(IOException e) 
    {
      e.printStackTrace();
    }
  }

  private Date parseDate(String date)
  {
    if (outDateTimeFormat == null)
    {
      outDateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
      outDateTimeFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
    }

    try 
    {
      return outDateTimeFormat.parse(date);
    }
    catch (ParseException e) 
    {
      e.printStackTrace();
      return null;
    }
  }

  private String formatDate(Date date)
  {
    return outDateTimeFormat.format(date);
  }

  public String getStationCSVHeader()
  {
    return "id,name,latitude,longitude,capacity,landmark,online_date";
  }

  public Station StationFromCSV(String csv)
  {
    // Create an array of Strings split
    String[] columns = PApplet.split(csv, ",");

    int id = Integer.parseInt(columns[0]); // The station id.
    String name = columns[1]; // The station name.
    float latitude = Float.parseFloat(columns[2]); // The latitude.
    float longitude = Float.parseFloat(columns[3]); // The longitude.
    int capacity = Integer.parseInt(columns[4]); // The station capacity.
    int landmarkId = Integer.parseInt(columns[5]); // The landmark id.
    Date onlineDate = parseDate(columns[6]); // The online date.

    return new Station(id, name, latitude, longitude, capacity, landmarkId, onlineDate);
  }

  public String toCSV(Station station)
  {
    return 
      station._id + "," + 
      station._name + "," +
      station._latitude + "," + 
      station._longitude + "," +
      station._capacity + "," + 
      station._landmarkId + "," + 
      formatDate(station._onlineDate);
  }

  public String getTripCSVHeader()
  {
    return "trip_id,start_time,stop_time,bike_id,from_station_id,to_station_id,user_type,gender,birth_year";
  }

  public Trip TripFromCSV(String csv, HashMap<Integer, Station> stationsMap)
  {
    // Create an array of Strings split
    String[] columns = PApplet.split(csv, ",");

    int id = Integer.parseInt(columns[0]);
    Date startTime = parseDate(columns[1]);
    Date stopTime = parseDate(columns[2]);
    int bikeId = Integer.parseInt(columns[3]);
    int fromStationId = Integer.parseInt(columns[4]);
    int toStationId = Integer.parseInt(columns[5]);
    String userType = columns[6];
    String gender = columns[7];
    int birthYear = ((columns[8].isEmpty()) ? 0 : Integer.parseInt(columns[8]));

    return new Trip(id, startTime, stopTime, bikeId, stationsMap.get(fromStationId), stationsMap.get(toStationId), userType, gender, birthYear);
  }

  public String toCSV(Trip trip)
  {
    return trip._id + "," + 
      formatDate(trip._startTime) + "," + 
      formatDate(trip._stopTime) + "," + 
      trip._bikeId + "," + 
      trip._fromStation.getId() + "," + 
      trip._toStation.getId() + "," + 
      trip._userType + "," +
      trip._gender + "," + ((trip._birthYear == 0) ? "" : trip._birthYear);
  }
}

