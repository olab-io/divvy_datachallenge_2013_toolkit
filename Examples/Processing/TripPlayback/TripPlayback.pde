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

DiskDataStore dataStore;
TripPlayer tripPlayer;

ArrayList<Trip> activeTrips = new ArrayList<Trip>();
HashMap<Integer, Station> stations = new HashMap<Integer, Station>();

void setup()
{
  size(1280, 720, P2D);
  frameRate(60);

  // Create the data store.
  dataStore = new DiskDataStore();
  tripPlayer = new TripPlayer();
}

void draw()
{
  // Set our background to opaque black.
  background(0);

  // Update our data store. This will enable us to keep buffering 
  // data in while simultaneously beignning to draw the buffered data.
  dataStore.update();

  // Update our trip player.  If we are playing, then this will provide
  // a new batch of recently departed trips for us to process.
  tripPlayer.update();

  // Add all new active trips to our list of active trips.
  activeTrips.addAll(tripPlayer.getNewTrips());

  // Iterate through all active trips.
  // Draw them and delete those that are no longer active.
  Iterator<Trip> iterator = activeTrips.iterator(); 

  int i = 0; 
  int h = 2;
  while (iterator.hasNext ())
  {
    Trip trip = iterator.next(); 

    if (trip.getStopTime().getTime() < tripPlayer.getTripTime())
    {
      iterator.remove();
    }
    else
    {
      float amt = trip.getProgressAtTime(tripPlayer.getTripTime());

      noStroke();
      fill(255, 200);
      rect(width * amt, i * h + i * 2, h, h);
    }

    i++;
  }

  // Draw a very simple gui play bar
  drawPlayBar();
}

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
  noStroke(); // no strokes in here.

  // Draw the background color.
  fill(255, 80);
  rect(_x, _y, _width, _height);

  // Draw the buffer progress on top of the background.
  fill(255, 100);
  rect(_x, _y, _width * dataStore.bufferProgress(), _height);

  stroke(255, 255);
  line(_width * dataStore.bufferProgress(), _y, _width * dataStore.bufferProgress(), _y + _height);

  noStroke();
  fill(255, 255, 0, 100);
  rect(_x, _y, _width * tripPlayer.getPlayhead(), _height);

  stroke(255, 255, 0, 255);
  line(_width * tripPlayer.getPlayhead(), _y, _width * tripPlayer.getPlayhead(), _y + _height);

  // Always pair a pushStyle() with a popStyle().
  popStyle();
}

