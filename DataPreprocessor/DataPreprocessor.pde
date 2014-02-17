import java.util.Map; // for the Map
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.Date;
import java.util.TimeZone;
import java.util.Calendar;

// Station name to ID map.
Map<String, String> stationIdMap = new HashMap<String, String>();

BufferedReader reader = null;
PrintWriter output = null;

String line;

// This is the date format in the trips
SimpleDateFormat tripDateTimeFormat = new SimpleDateFormat("MM/dd/yyyy HH:mm"); 
tripDateTimeFormat.setTimeZone(TimeZone.getTimeZone("America/Chicago"));

// This is the date format we'd like to store.
// We choose this format because it is easy to import into databases.
SimpleDateFormat outDateTimeFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
outDateTimeFormat.setTimeZone(TimeZone.getTimeZone("UTC"));

try 
{
  // Create a reader to read our trip data.
  reader = createReader("Divvy_Stations_Trips_2013/Divvy_Trips_2013.csv");    

  // Create a write to write our processed data to a new CSV file.
  // dataPath() places the file inside the data folder.
  output = createWriter(dataPath("Divvy_Stations_Trips_2013/Divvy_Trips_2013_Cleaned.csv")); 

  // Consume the header line so it isn't processed as if it's data.
  String header = reader.readLine(); 

  String[] headerColumns = split(header, ",");

  // Now create a newly formatted CSV header line.
  String cleanedLine = ""; // Start with a blank line to build our row.

  cleanedLine += "trip_id";
  cleanedLine += ",";
  cleanedLine += "start_time";
  cleanedLine += ",";
  cleanedLine += "end_time";
  cleanedLine += ",";
  cleanedLine += "bike_id";
  cleanedLine += ","; 
  cleanedLine += "start_station_id";
  cleanedLine += ","; 
  cleanedLine += "end_station_id";
  cleanedLine += ","; 
  cleanedLine += "user_type";
  cleanedLine += ","; 
  cleanedLine += "gender";
  cleanedLine += ","; 
  cleanedLine += "birth_year";

  // Save the output to the new file.
  output.println(cleanedLine);

  // Keep a count of the lines for progress feedback.
  int lineCount = 0;

  // This while loop reads a new line (delimited by a new line character)
  // until the line is null (meaning the reader has reached the end).
  while ( (line = reader.readLine ()) != null) 
  {
    // Keep a count of the current line.
    lineCount++;

    // A sanity counter to see if we are making progress.
    // This will print a message every 10000 lines.
    if (lineCount % 10000 == 0) println("Num lines processed: " + lineCount);

    // First, there are fields in the tripduration column that look like this ...,"1,234",...
    // In order to make this CSV parsable, we need to convert this number to 1234.
    // Here, we'll construct a regular expression to replace the "1,234" with a 1234.
    // See this page for more info on regular expressions: 
    //     http://www.regexplanet.com/advanced/java/index.html
    line = line.replaceAll("\"([0-9]+),([0-9]+)\"", "$1$2");

    // Second, there are fields in the station_id columns that are #N/A.
    // We need to replace that with a more useful number.  
    // In our case, we will replace it with a 0 because we know 0 is not used elsewhere.
    line = line.replaceAll("#N/A", "0");

    // Create an array of Strings split
    String[] columns = split(line, ",");

    // Parse the raw start time for conversion.
    Date tripStartTime = tripDateTimeFormat.parse(columns[1]);

    // Parse the raw end time for conversion.
    Date tripEndTime = tripDateTimeFormat.parse(columns[2]);

    // Format the start time for MySQL DateTime and UTC time zone.
    String formattedStartTime = outDateTimeFormat.format(tripStartTime);
    // Format the end time for MySQL DateTime and UTC time zone.
    String formattedEndTime = outDateTimeFormat.format(tripEndTime);

    // Currently the station list does not contain matching station ids.
    // Here we will create a map for later use when we clean the station list CSV.

    String fromStationId = columns[5];
    String fromStationName = columns[6];
    String toStationId = columns[7];
    String toStationName = columns[8];

    stationIdMap.put(fromStationName, fromStationId);
    stationIdMap.put(toStationName, toStationId);

    // Convert Male to M and Female to F
    String userType = columns[9];

    // Convert Male to M and Female to F
    if (userType.equalsIgnoreCase("Customer"))
    {
      userType = "C";
    } 
    else if (userType.equalsIgnoreCase("Subscriber"))
    {
      userType = "S";
    }

    // Convert Male to M and Female to F
    String gender = columns[10];

    if (gender.equalsIgnoreCase("Female"))
    {
      gender = "F";
    } 
    else if (gender.equalsIgnoreCase("Male"))
    {
      gender = "M";
    }

    // Now create a newly formatted CSV line.
    cleanedLine = ""; // Start with a blank line to build our row.

    cleanedLine += columns[0]; // The raw trip id.
    cleanedLine += ",";
    cleanedLine += formattedStartTime; // The start time in MySQL DateTime format and in UTC timezone.
    cleanedLine += ",";
    cleanedLine += formattedEndTime; // The end time in MySQL DateTime format and in UTC timezone..
    cleanedLine += ",";
    cleanedLine += columns[3]; // The raw bike id.
    cleanedLine += ","; 
    cleanedLine += columns[5]; // The raw start station id.
    cleanedLine += ","; 
    cleanedLine += columns[7]; // The raw end station id.
    cleanedLine += ","; 
    cleanedLine += userType; // The raw user type.
    cleanedLine += ","; 
    cleanedLine += gender; // The gender.
    cleanedLine += ","; 
    cleanedLine += columns[11]; // The raw birth year.

    // Save the output to the new file.
    output.println(cleanedLine);
  }
}
catch (IOException e) 
{
  e.printStackTrace();
} 
catch (ParseException e) 
{
  e.printStackTrace();
} 
finally 
{
  try 
  {
    println("Closing it!");
    reader.close();
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
  } 
  catch (IOException e) 
  {
    e.printStackTrace();
  }
}

///////////////////////////

try 
{
  // Create a reader to read our trip data.
  reader = createReader("Divvy_Stations_Trips_2013/Divvy_Stations_2013.csv");    

  // Create a write to write our processed data to a new CSV file.
  // dataPath() places the file inside the data folder.
  output = createWriter(dataPath("Divvy_Stations_Trips_2013/Divvy_Stations_2013_Cleaned.csv")); 

  // Consume the header line so it isn't processed as if it's data.
  String header = reader.readLine(); 

  String[] headerColumns = split(header, ",");

  // Now create a newly formatted CSV header line.
  String cleanedLine = ""; // Start with a blank line to build our row.

  cleanedLine += "id";
  cleanedLine += ",";
  cleanedLine += "name";
  cleanedLine += ",";
  cleanedLine += "latitude";
  cleanedLine += ",";
  cleanedLine += "longitude";
  cleanedLine += ","; 
  cleanedLine += "capacity";

  // Save the output to the new file.
  output.println(cleanedLine);

  // Keep a count of the lines for progress feedback.
  int lineCount = 0;

  // This while loop reads a new line (delimited by a new line character)
  // until the line is null (meaning the reader has reached the end).
  while ( (line = reader.readLine ()) != null) 
  {
    // Keep a count of the current line.
    lineCount++;

    // A sanity counter to see if we are making progress.
    // This will print a message every 10000 lines.
    if (lineCount % 10000 == 0) println("Num lines processed: " + lineCount);

    // First, there are fields in the station_id columns that are #N/A.
    // We need to replace that with a more useful number.  
    // In our case, we will replace it with a 0 because we know 0 is not used elsewhere.
    line = line.replaceAll("#N/A", "0");

    // Create an array of Strings split
    String[] columns = split(line, ",");

    String stationName = columns[0];
    String stationId = stationIdMap.get(stationName);

    // Now create a newly formatted CSV line.
    cleanedLine = ""; // Start with a blank line to build our row.

    cleanedLine += stationId;
    cleanedLine += ",";
    cleanedLine += columns[0]; // The raw trip id.
    cleanedLine += ",";
    cleanedLine += columns[1]; // The raw bike id.
    cleanedLine += ","; 
    cleanedLine += columns[2]; // The raw start station id.
    cleanedLine += ","; 
    cleanedLine += columns[3]; // The raw end station id.

    // Save the output to the new file.
    output.println(cleanedLine);
  }
}
catch (IOException e) 
{
  e.printStackTrace();
} 
finally 
{
  try 
  {
    println("Closing it!");
    reader.close();
    output.flush(); // Writes the remaining data to the file
    output.close(); // Finishes the file
  } 
  catch (IOException e) 
  {
    e.printStackTrace();
  }
}

