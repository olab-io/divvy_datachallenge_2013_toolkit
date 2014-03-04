# Divvy Data Challenge 2013 Toolkit

## Updates

 - 21 Feb, 2014: Updated everything for revised Divvy Data. 
 - 16 Feb, 2014: Initial Upload.

## Background

Developed by [Christopher Baker](http://github.com/bakercp) in collaboration with the [openLab](http://olab.io) at the [School of the Art Institute of Chicago](http://saic.edu).

This toolkit consists of a collection of examples, preprocessors and tools to support work on the [http://divvybikes.com/datachallenge](http://divvybikes.com/datachallenge) data set.

The goal of this toolkit is to provide a basic foundation for building data visualizations using the 2013 Divvy Bike data.

__For questions, leave an issue here or join the conversation @ <https://talk.olab.io>.__

## Toolkit Components

### Raw Data

The raw data is included in this repository in the `data` folder.  Please see the raw data [README.md](https://github.com/olab-io/divvy_datachallenge_2013_toolkit/blob/master/data/README.md) for a discussion of some current issues with the data.

### Data Preprocessor

The `DataPreprocessor` is a Processing sketch that makes it easy to pre-process the raw Divvy data.  See the [README.md](https://github.com/olab-io/divvy_datachallenge_2013_toolkit/blob/master/DataPreprocessor/README.md) for more information.

### DIY API (Do-It-Yourself-Application-Programming-Interface)

The DIY API is a way to let your visualization project search the Divvy bike data using simple search parameters.  Here are a few examples:

Select the first page of 25 results for for trips between 2013-06-01 and 2013-07-01 for males over the age of 50: 
  
  - <http://data.olab.io/divvy/api.php?start_min=2013-06-01&start_max=2013-07-01&gender=male&age_min=50&page=0&rpp=25>

To get results 26 - 50 from the same query:
  
  - <http://data.olab.io/divvy/api.php?start_min=2013-06-01&start_max=2013-07-01&gender=male&age_min=50&page=1&rpp=25>

To get all trips taken by 33 year old females:
  
  - <http://data.olab.io/divvy/api.php?gender=female&age=33>

See the [README.md](https://github.com/olab-io/divvy_datachallenge_2013_toolkit/blob/master/api/README.md) for DIY API installation instructions and query parameter documentation.

An alternate API by @amonks is <http://divvy-json.herokuapp.com/>.

### Examples
    
_Descriptions coming soon.  See code comments for the moment._

## Related

 - [Divvy API](http://divvy-json.herokuapp.com/)
     - Annotated API by @amonks
 - [Divvy Data Document](http://j.mp/DivvyData)
     - Explains the fields, etc.
 - [Divvy Station Distance Tables](https://github.com/tothebeat/pairwise-geo-distances/tree/master/bike_stations_data/Chicago)
     - Supplementary distance data.
 - <http://chicagocrashes.org/>
     - A map that examines pedestrian / cyclist vs. auto crashes in chicago.
 - <https://bikesharingdata.hackpad.com/>
     - A lot of bike-data resources collected by @stevevance.
