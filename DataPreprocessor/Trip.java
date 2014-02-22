import java.util.HashMap;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.Date;
import java.util.TimeZone;
import processing.core.*;

/// This class represents a Divvy Bike Trip taken by a single user.
class Trip
{
  int _id; // Trip id;
  Date _startTime; // The trip start time.
  Date _stopTime;   // The trip stop time.

  long _duration; // The duration of the trip in milliseconds.

  int _bikeId; // The bike id.

  Station _fromStation; // The start station id number.
  Station _toStation;   // The stop station id number.

  float _shortestDistance; // the crow-flies distance of the trip.
  float _bearing;  // the crow-flies bearing of the trip.

  String _userType; // Customer or Subscriber

  // These fields are only available if userType == Subscriber
  String _gender;   // Male or Female  
  int _birthYear;   // Year of birth.
  int _age;

  Trip(int id, 
  Date startTime, 
  Date stopTime, 
  int bikeId, 
  Station fromStation, 
  Station toStation, 
  String userType, 
  String gender, 
  int birthYear)
  {
    _id = id;
    _startTime = startTime;
    _stopTime = stopTime;
    _bikeId = bikeId;
    _fromStation = fromStation;
    _toStation = toStation;
    _userType = userType;
    _gender = gender;
    _birthYear = birthYear;

    // Calculate several variables.
    _shortestDistance = _fromStation.getShortestDistanceTo(_toStation);
    _bearing = _fromStation.getBearingTo(_toStation);
    _duration = _stopTime.getTime() - _startTime.getTime();
    _age = _birthYear != 0 ? _startTime.getYear() - _birthYear : 0;
  }

  // Accessors ////////////////////////////////////////////////////////////////
  // The member variables are protected by default, allowing only 
  // subclasses of Station to read or write values directly.
  // Accessors like "getId()" give other parts of your code 
  // read-only access to the member variables.

  public Date getStartTime()
  {
    return _startTime;
  }

  public Date getStopTime()
  {
    return _stopTime;
  }

  public Station getFromStation()
  {
    return _fromStation;
  }

  public Station getToStation()
  {
    return _toStation;
  }

  public int getBikeId()
  {
    return _bikeId;
  }

  public String getUserType()
  {
    return _userType;
  }

  public int getBirthYear()
  {
    return _birthYear;
  }

  // Calculated variables
  public float getShortestDistance() 
  {
    return _shortestDistance;
  }

  public float getBearing() 
  {
    return _bearing;
  }

  // Return the trip duration in milliseconds
  public float getDuration() 
  {
    return _duration;
  }

  public int getAge()
  {
    return _age;
  }

  // returns a clamped 0 - 1 for a trip
  float getProgressAtTime(Date time)
  {
    return PApplet.constrain(PApplet.norm(time.getTime(), _startTime.getTime(), _stopTime.getTime()), 0, 1);
  }

  private static SimpleDateFormat outDateTimeFormat = null;

  private static Date parseDate(String date)
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

  private static String formatDate(Date date)
  {
    if (outDateTimeFormat == null)
    {
      outDateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
      outDateTimeFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
    }

    return outDateTimeFormat.format(date);
  }

  public static String getCSVHeader()
  {
    return "trip_id,start_time,stop_time,bike_id,from_station_id,to_station_id,user_type,gender,birth_year";
  }

  public static Trip fromCSV(String csv, HashMap<Integer, Station> stationsMap)
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

  public String toCSV()
  {
    return _id + "," + 
      formatDate(_startTime) + "," + 
      formatDate(_stopTime) + "," + 
      _bikeId + "," + 
      _fromStation.getId() + "," + 
      _toStation.getId() + "," + 
      _userType + "," +
      _gender + "," + ((_birthYear == 0) ? "" : _birthYear);
  }
}

