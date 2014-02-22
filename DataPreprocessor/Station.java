import java.util.HashMap;
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.Date;
import java.util.TimeZone;
import processing.core.*;

/// This class represents a Divvy Bike Station
class Station
{
  int _id;  // The station id number.
  String _name; // The station name.
  float _latitude; // The station latitude.
  float _longitude; // The station longitude.
  int _capacity;  // The bike capacity of the station.

  int _landmarkId; // The landmark id.
  Date _onlineDate; // The online date of the station.


  // The class constructor.
  public Station(int id, String name, float latitude, float longitude, int capacity, int landmarkId, Date onlineDate)
  {
    _id = id;
    _name = name;
    _latitude = latitude;
    _longitude = longitude;
    _capacity = capacity;
    _landmarkId = landmarkId;
    _onlineDate = onlineDate;
  }

  // Accessors ////////////////////////////////////////////////////////////////
  // The member variables are protected by default, allowing only 
  // subclasses of Station to read or write values directly.
  // Accessors like "getId()" give other parts of your code 
  // read-only access to the member variables.

  public int getId() 
  {
    return _id;
  }

  public String getName()
  {
    return _name;
  }

  public float getLatitude()
  {
    return _latitude;
  }

  public float getLongitude()
  {
    return _longitude;
  }

  public int getCapacity()
  {
    return _capacity;
  }

  public int getLandmarkId()
  {
    return _landmarkId;
  }

  public Date getOnlineDate()
  {
    return _onlineDate;
  }

  public float getShortestDistanceTo(Station other)
  {
    // reference: http://www.movable-type.co.uk/scripts/latlong.html
    int meanRadiusOfTheEarthKm = 6371;

    float deltaLatRad = PApplet.radians(this._latitude - other._latitude);
    float deltaLonRad = PApplet.radians(this._longitude - other._longitude);

    float thisLatRad = PApplet.radians(this._latitude);
    float otherLatRad = PApplet.radians(other._latitude);

    float s0 = PApplet.sin(deltaLatRad / 2.0f);
    float s1 = PApplet.sin(deltaLonRad / 2.0f);

    float a = s0 * s0 + s1 * s1 * PApplet.cos(thisLatRad) * PApplet.cos(otherLatRad);

    float c = 2 *  PApplet.atan2(PApplet.sqrt(a), PApplet.sqrt(1 - a));

    float d = meanRadiusOfTheEarthKm * c; // the as-a-crow-flies-distance in km

    return d;
  }

  // Returns the bearing in degrees between two stations.
  public float getBearingTo(Station other)
  {
    float deltaLatRad = PApplet.radians(this._latitude - other._latitude);
    float deltaLonRad = PApplet.radians(this._longitude - other._longitude);

    float thisLatRad = PApplet.radians(this._latitude);
    float otherLatRad = PApplet.radians(other._latitude);

    float s0 = PApplet.sin(deltaLatRad / 2.0f);
    float s1 = PApplet.sin(deltaLonRad / 2.0f);

    float y = PApplet.sin(deltaLonRad) * PApplet.cos(otherLatRad);

    float x = PApplet.cos(thisLatRad) * PApplet.cos(otherLatRad) - 
      PApplet.sin(thisLatRad) * PApplet.cos(otherLatRad) * PApplet.cos(deltaLonRad);

    float bearing = PApplet.degrees(PApplet.atan2(y, x));

    return bearing;
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
    return "id,name,latitude,longitude,capacity,landmark,online_date";
  }

  public static Station fromCSV(String csv)
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

  public String toCSV()
  {
    return 
    _id + "," + 
    _name + "," +
    _latitude + "," + 
    _longitude + "," +
    _capacity + "," + 
    _landmarkId + "," + 
    formatDate(_onlineDate);
  }
}

