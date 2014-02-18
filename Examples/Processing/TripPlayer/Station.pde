/// This class represents a Divvy Bike Station
class Station
{
  int _id;  // The station id number.
  String _name; // The station name.
  float _latitude; // The station latitude.
  float _longitude; // The station longitude.
  int _capacity;  // The bike capacity of the station.

  // The class constructor.
  public Station(int id, String name, float latitude, float longitude, int capacity)
  {
    _id = id;
    _name = name;
    _latitude = latitude;
    _longitude = longitude;
    _capacity = capacity;
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
  
  public float getShortestDistanceTo(Station other)
  {
    // reference: http://www.movable-type.co.uk/scripts/latlong.html
    int meanRadiusOfTheEarthKm = 6371;
    
    float deltaLatRad = radians(this._latitude - other._latitude);
    float deltaLonRad = radians(this._longitude - other._longitude);

    float thisLatRad = radians(this._latitude);
    float otherLatRad = radians(other._latitude);
      
    float s0 = sin(deltaLatRad / 2.0);
    float s1 = sin(deltaLonRad / 2.0);
    
    float a = s0 * s0 + s1 * s1 * cos(thisLatRad) * cos(otherLatRad);
    
    float c = 2 *  atan2(sqrt(a), sqrt(1 - a));
    
    float d = meanRadiusOfTheEarthKm * c; // the as-a-crow-flies-distance in km
    
    return d;
  }
  
  // Returns the bearing in degrees between two stations.
  public float getBearingTo(Station other)
  {
    float deltaLatRad = radians(this._latitude - other._latitude);
    float deltaLonRad = radians(this._longitude - other._longitude);

    float thisLatRad = radians(this._latitude);
    float otherLatRad = radians(other._latitude);
      
    float s0 = sin(deltaLatRad / 2.0);
    float s1 = sin(deltaLonRad / 2.0);
    
    float y = sin(deltaLonRad) * cos(otherLatRad);
    
    float x = cos(thisLatRad) * cos(otherLatRad) - 
              sin(thisLatRad) * cos(otherLatRad) * cos(deltaLonRad);
    
    float bearing = degrees(atan2(y, x));
    
    return bearing;
  } 
  
  public String toCSV()
  {
    return _id + "," + _name + "," + _latitude + "," + _longitude + "," + _capacity;
  }
}

