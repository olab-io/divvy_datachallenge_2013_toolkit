class DataPlayer
{
  float _speed = 1000; // The speed of the player.  A speed of 1 will play the trips in "real time".
  boolean _isInited = false;

  boolean _isPlaying = true; // Are we currently playing.
  long _lastUpdate = 0;  // The last time the player was updated.

  int _lastTripArrayIndex = 0;
  long _lastTripTime = 0;

  ArrayList<Trip> _newTrips = new ArrayList<Trip>();

  public DataPlayer()
  {
  }

  // This is where we do the math to figure out what trips come next.
  public void update()
  {
    // Clear out the trips.
    _newTrips.clear();

    // Do we have any trips?  If not, skip this.
    // If we have trips, are we currently playing?  If not, skip this.
    if (!_isPlaying) return;

    // Get the current time.
    long now = millis(); 

    // How much "real" time has passed since the last update?
    long elapsedTimeReal = now - _lastUpdate; 

    // How much time has passed in our simulation?
    long elapsedTimeSimulated = (long)(elapsedTimeReal * _speed);

    if (!_isInited)
    {
      if (dataStore.getNumTripsBuffered() > 0)
      {
        _lastTripTime = dataStore.getTripByArrayIndex(0).getStartTime().getTime();
        _isInited = true;
      }
      else
      {
        // We can't do anything yet, because there is no data to start with.
        return;
      }
    }

    // Caclulate our new playback position.
    long newTripTime = _lastTripTime + elapsedTimeSimulated;

    // Get the items that are newly active.
    // Prune the items that are newly inactive.
    _newTrips = dataStore.getTripsByStartTime(_lastTripTime, newTripTime, _lastTripArrayIndex);

    _lastTripArrayIndex += _newTrips.size();

    _lastTripTime = newTripTime;
    _lastUpdate = now;
  }

  public float getPlayhead()
  {
    return _lastTripArrayIndex / (float)dataStore.getTotalNumberOfTrips();
  }

  public ArrayList<Trip> getNewTrips()
  {
    return _newTrips;
  }

  public void togglePause()
  {
    if (_isPlaying)
    {
      pause();
    }
    else
    {
      play();
    }
  }

  public void play()
  {
    _isPlaying = true;
    _lastUpdate = millis();
  }

  public void pause()
  {
    _isPlaying = false;
  }

  public void setSpeed(float speed)
  {
    _speed = speed;
  }

  public float getSpeed()
  {
    return _speed;
  }

  public void setTime(long time)
  {
    _lastTripTime = time;
  }

  public long getTime()
  {
    return _lastTripTime;
  }
}

