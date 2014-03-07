class NamedLocation extends Location
{
  String _name;

  NamedLocation(String name, float latitude, float longitude)
  {
    this(name, new Location(latitude, longitude));
  }

  NamedLocation(String name, Location location)
  {  
    super(location);
    _name = name;
  }

  String getName()
  {
    return _name;
  }  

  String toString()
  {
    return _name + " " + super.toString();
  }
}

