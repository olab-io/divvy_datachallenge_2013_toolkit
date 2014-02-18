JSONArray json;

void setup() {

  json = loadJSONArray("http://data.olab.io/divvy/api.php");

  println(json);
}


