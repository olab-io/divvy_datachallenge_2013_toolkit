import java.util.HashSet;

class TripSearchPredicate
{
  Date _minStartTime = null;
  Date _maxStartTime = null;

  Date _minStopTime = null;
  Date _maxStopTime = null;

  HashSet<Integer> _stationsInclude = null;
  HashSet<Integer> _stationsExclude = null;

  Long _minDuration = null;
  Long _maxDuration = null;

  Float _minShortestDistance = null;
  Float _maxShortestDistance = null;

  HashSet<String> _userTypeInclude = null;
  HashSet<String> _userTypeExclude = null;

  HashSet<String> _genderInclude = null;
  HashSet<String> _genderExclude = null;

  Integer _minBirthYear = null;
  Integer _maxBirthYear = null;

  Integer _minAge = null;
  Integer _maxAge = null;

  TripSearchPredicate()
  {
  }

  TripSearchPredicate(Date minStartTime, Date maxStartTime)
  {
    _minStartTime = minStartTime; 
    _maxStartTime = maxStartTime;
  }

  boolean matches(Trip trip)
  {
    if (_minStartTime != null && trip.getStartTime().getTime() < _minStartTime.getTime()) return false;
    if (_maxStartTime != null && trip.getStartTime().getTime() >= _maxStartTime.getTime()) return false;

    if (_minStopTime != null && trip.getStopTime().getTime() < _minStopTime.getTime()) return false;
    if (_maxStopTime != null && trip.getStopTime().getTime() >= _maxStopTime.getTime()) return false;

    // TODO add conditions for the rest

    return true;
  }
}

