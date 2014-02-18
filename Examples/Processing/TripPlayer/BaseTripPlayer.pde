class BaseTripPlayer
{
  float _speed; // The speed of the player.  A speed of 1 will play the trips in "real time".

  boolean _isPlaying; // Are we currently playing.

  long _lastUpdate;  // The last time the player was updated.

  long _currentPlaybackPosition = 0;

  public void update()
  {
    // Get the current time.
    long now = millis(); 

    // How much "real" time has passed since the last update?
    long elapsedTimeReal = now - _lastUpdate; 
    
    // How much time has passed in our simulation?
    long elapsedTimeSimulated = (long)(elapsedTimeReal * _speed);

    // Caclulate our new playback position.
    long newPlaybackPosition = _currentPlaybackPosition + elapsedTimeSimulated;

    // Get the items that are newly active.
    // Prune the items that are newly inactive.

    _currentPlaybackPosition = newPlaybackPosition;
    _lastUpdate = now;
  }

  public void setSpeed(float speed)
  {
    _speed = speed;
  }

  public float getSpeed()
  {
    return _speed;
  }
};

