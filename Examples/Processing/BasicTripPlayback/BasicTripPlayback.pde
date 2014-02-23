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

import java.util.Iterator; 
///< Import an iterator from Java to simplify iteration.
///< \note This is not compatible with Processing JS.

DiskDataStore dataStore;
///< The DiskDataStore is responsible for loading data from disk
///< and providing the data that we need when asked.

DataPlayer dataPlayer;
///< This player will "play" through the timeline and provide
///< sets of trips as they "begin" on the timeline.  This is a way
///< to "play back" the trip data.

ArrayList<Trip> activeTrips = new ArrayList<Trip>();
///< This is our collection of currently active trips according to the
///< data player.  In the draw loop, we keep this array up to date by 
///< querying the data player to add recently departed trips and
///< then we iterate through and remove any trips that have concluded.

HashMap<Integer, Station> stations = new HashMap<Integer, Station>();
///< This is a map of our stations.  This makes it easy to get a given
///< station object using only its stationId.

SimpleDateFormat localTimeFormat;
///< This is a time formatting object that displays times in CST.

PFont font;
///< Our tiny font.

/// The setup() method runs once and sets up our variables.
void setup()
{
  size(1280, 720); // Create a 2D openGL window context.
  smooth(); // Turn on anti-aliasing.

  frameRate(60); // Tell the sketch to run at 60 frames / second (if possible).

  dataStore = new DiskDataStore(); // Create a data store.
  dataPlayer = new DataPlayer(); // Create a data player.

  font = loadFont("Silkscreen-8.vlw"); // Load the font.
  textFont(font); // Enable the font.

  // Set up our local time format and time zone.
  localTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
  localTimeFormat.setTimeZone(TimeZone.getTimeZone("America/Chicago"));
}

// The draw() method runs repeatedly, approximately as often as 
// it was instructed to using the frameRate() method in the setup() 
// method above.
void draw()
{
  // Set our background to opaque black.
  background(0);

  // Update our data store. This will enable us to keep buffering 
  // data in while simultaneously beignning to draw the buffered data.
  dataStore.update();

  // Update our data player.  If we are playing, then this will provide
  // populate a new batch of recently departed trips for us to process.
  dataPlayer.update();

  // Add all new active trips to our list of active trips.
  activeTrips.addAll(dataPlayer.getNewTrips());

  // Iterate through all active trips.
  // Draw them and delete those that are no longer active.
  Iterator<Trip> iterator = activeTrips.iterator(); 

  int i = 0; // Keep a count that we'll use for the y position.

  long playerTime = dataPlayer.getTime();

  // Iterate through each of the currently active trips.
  while (iterator.hasNext ())
  {
    // Get the trip.
    Trip trip = iterator.next(); 

    // If the trip is finished, remove it from the activeTrips.
    if (trip.getStopTime().getTime() < playerTime)
    {
      iterator.remove();
    }
    else
    {
      // If it is not finished, get its 0-1 progress and use 
      // that to draw a very small rectangle.
      int h = 8; // This is the height of our little blob.
      float amt = trip.getProgressAtTime(playerTime);
      float x = width * amt;
      float y = i * (h + 2);

      ellipseMode(CENTER);

      color strokeColor = color(255, 255, 0, 200);
      color fillColor = color(255, 255, 0, 100);

      if (trip.getUserType().equals("S"))
      {      
        strokeColor = color(255, 0, 0, 200);
        fillColor = color(255, 0, 0, 100);
      }

      noStroke();
      fill(fillColor);
      ellipse(x, y, h, h);
      noFill();
      stroke(strokeColor);
      ellipse(x, y, h, h);

      fill(255, 200);
      text(trip.getBikeId(), x + h, y + 3);
    }
    i++;
  }

  // Draw a very simple gui play bar
  drawPlayBar();
}

// This is our very simple plaback / buffer progress bar.
void drawPlayBar()
{

  // Draw a rectangle at the bottom of the screen.
  // The rectangle will show the current playhead position
  // and will show how much trip data has been buffered.

  // A rectangle to define our playhead gui.
  int _width = width;
  int _height = 10;
  int _x = 0;
  int _y = height - _height; 

  // We push a PStyle in order to isolate these styles from others.
  pushStyle();
  rectMode(CORNER);

  noStroke(); // no strokes in here.

  // Draw the background color.
  fill(255, 80);
  rect(_x, _y, _width, _height);

  // Draw the buffer progress on top of the background.
  fill(255, 100);
  rect(_x, _y, _width * dataStore.bufferProgress(), _height);

  noStroke();
  fill(255, 255, 0, 100);
  rect(_x, _y, _width * dataPlayer.getPlayhead(), _height);

  fill(255, 100);
  text("Speed: " + (int)dataPlayer.getSpeed() + "x", _x + 1, _y - 3);

  // Create a string with the current playhead time.
  String playheadTime = localTimeFormat.format(new Date(dataPlayer.getTime()));

  fill(255, 100);
  text("Time: " + playheadTime, _x + 1, _y - 3 - 8);

  // Always pair a pushStyle() with a popStyle().
  popStyle();
}

// Respond to key presses.
void keyPressed()
{
  switch(key)
  {
  case ' ':
    dataPlayer.togglePause();
    break;
  case '=':
    dataPlayer.setSpeed(dataPlayer.getSpeed() + 100);
    break;
  case '-':
    float currentSpeed = dataPlayer.getSpeed() - 100;
    // Don't allow negative speeds yet.
    if (currentSpeed > 0) 
    {
      dataPlayer.setSpeed(currentSpeed);
    }
    else 
    {
      dataPlayer.setSpeed(1);
    }
    break;
  }
}

