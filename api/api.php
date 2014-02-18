<?php
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

    // Configuration
    $rpp_max = 100; // The maximum number of records that can be returned for a single query. 
    $trip_table = "Divvy_Trips_2013"; // The name of the trips table

    if (isset($_GET['start_min']) && // Is the "start_min" parameter set?
        (($start_min = strtotime(mysql_real_escape_string($_GET['start_min']))) !== false))
    {
        // we use gmdate because our stored dates are in UTC.
        $conditions[] = " start_time >= :start_min ";
        $conditions_params['start_min'] = gmdate("Y-m-d H:i:s", $start_min);
    }

    if (isset($_GET['start_max']) &&
        (($start_max = strtotime(mysql_real_escape_string($_GET['start_max']))) !== false))
    {
        // we use gmdate because our stored dates are in UTC.
        $conditions[] = " start_time < :start_max ";
        $conditions_params['start_max'] = gmdate("Y-m-d H:i:s", $start_max);
    }

    if (isset($_GET['stop_min']) && // Is the "stop_min" parameter set?
        (($stop_min = strtotime(mysql_real_escape_string($_GET['stop_min']))) !== false))
    {
        // we use gmdate because our stored dates are in UTC.
        $conditions[] = " stop_time >= :stop_min ";
        $conditions_params['stop_min'] = gmdate("Y-m-d H:i:s", $stop_min);
    }

    if (isset($_GET['stop_max']) &&
        (($stop_max = strtotime(mysql_real_escape_string($_GET['stop_max']))) !== false))
    {
        // we use gmdate because our stored dates are in UTC.
        $conditions[] = " stop_time < :stop_max ";
        $conditions_params['stop_max'] = gmdate("Y-m-d H:i:s", $stop_max);
    }

    if (isset($_GET['from_station_id']) && is_numeric($_GET["from_station_id"]) && $_GET["from_station_id"] >= 0)
    {
        $conditions[] = " from_station_id = :from_station_id ";
        $conditions_params['from_station_id'] = $_GET["from_station_id"];
    }

    if (isset($_GET['to_station_id']) && is_numeric($_GET["to_station_id"]) && $_GET["to_station_id"] >= 0)
    {
        $conditions[] = " to_station_id = :to_station_id ";
        $conditions_params['to_station_id'] = $_GET["to_station_id"];
    }

    if (isset($_GET['bike_id']) && is_numeric($_GET["bike_id"]) && $_GET["bike_id"] >= 0)
    {
        $conditions[] = " bike_id = :bike_id ";
        $conditions_params['bike_id'] = $_GET["bike_id"];
    }


    if (
        (isset($_GET["trip_id"]) && is_numeric($_GET["trip_id"]) && $_GET["trip_id"] >= 0) ||
        (isset($_GET["trip_id_min"]) && is_numeric($_GET["trip_id_min"]) && $_GET["trip_id_min"] >= 0) ||
        (isset($_GET["trip_id_max"]) && is_numeric($_GET["trip_id_max"]) && $_GET["trip_id_max"] >= 0)
        )
    {
        if (isset($_GET["trip_id_min"]) || isset($_GET["trip_id_max"]))
        {
            if (isset($_GET["trip_id_min"]))
            {
                $conditions[] = " trip_id >= :trip_id_min ";
                $conditions_params['trip_id_min'] = $_GET["trip_id_min"];
            }

            if (isset($_GET["trip_id_max"]))
            {
                $conditions[] = " trip_id < :trip_id_max ";
                $conditions_params['trip_id_max'] = $_GET["trip_id_max"];
            }
        }
        else if (isset($_GET["trip_id"]))
        {
            $conditions[] = " trip_id = :trip_id ";
            $conditions_params['trip_id'] = $_GET["trip_id"];
        }

    }

    if (isset($_GET['trip_id_min']) && is_numeric($_GET["bike_id"]) && $_GET["bike_id"] >= 0)
    {
        $conditions[] = " bike_id = :bike_id ";
        $conditions_params['bike_id'] = $_GET["bike_id"];
    }

    if (isset($_GET['user_type'])) // Is the "user_type" parameter set?
    {   
        if (strcasecmp($_GET['user_type'], "customer") == 0)
        {
            $conditions[] = " user_type = 'C' ";
        } 
        else if (strcasecmp($_GET['user_type'], "subscriber") == 0)
        {
            $conditions[] = " user_type = 'S' ";
        }
    }

    if (isset($_GET['gender'])) // Is the "user_type" parameter set?
    {   
        if (strcasecmp($_GET['gender'], "male") == 0)
        {
            $conditions[] = " gender = 'M' ";
        } 
        else if (strcasecmp($_GET['gender'], "female") == 0)
        {
            $conditions[] = " gender = 'F' ";
        }
    }

    // Do we have any age 
    if (
        (isset($_GET['birth_year'])     && is_numeric($_GET['birth_year'])     && $_GET['birth_year'] > 0)    || 
        (isset($_GET['age'])            && is_numeric($_GET['age'])            && $_GET['age'] > 0)           || 
        (isset($_GET['age_min'])        && is_numeric($_GET['age_min'])        && $_GET['age_min'] > 0)       || 
        (isset($_GET['age_max'])        && is_numeric($_GET['age_max'])        && $_GET['age_max'] > 0)       ||
        (isset($_GET['birth_year_min']) && is_numeric($_GET['birth_year_min']) && $_GET['birth_year_min'] > 0)|| 
        (isset($_GET['birth_year_max']) && is_numeric($_GET['birth_year_max']) && $_GET['birth_year_max'] > 0)
       )
    {
        if (isset($_GET['age_min']) || isset($_GET['age_max']))
        {
            if (isset($_GET['age_min']))
            {
                $conditions[] = " birth_year < :birth_year_max AND birth_year != 0 ";
                $conditions_params['birth_year_max'] = 2013 - $_GET['age_min'];
            }

            if (isset($_GET['age_max']))
            {
                $conditions[] = " birth_year >= :birth_year_min AND birth_year != 0 ";
                $conditions_params['birth_year_min'] = 2013 - $_GET['age_max'];
            }
        }
        else if (isset($_GET['birth_year_min']) || isset($_GET['birth_year_max']))
        {
            if (isset($_GET['birth_year_min']))
            {
                $conditions[] = " birth_year >= :birth_year_min AND birth_year != 0 ";
                $conditions_params['birth_year_min'] = $_GET['birth_year_min'];
            }

            if (isset($_GET['birth_year_max']))
            {
                $conditions[] = " birth_year < :birth_year_max AND birth_year != 0 ";
                $conditions_params['birth_year_max'] = $_GET['birth_year_max'];
            }

        }
        else if (isset($_GET['age']))
        {
            $conditions[] = " birth_year = :birth_year AND birth_year != 0 ";
            $conditions_params['birth_year'] = 2013 - $_GET['age'];
        }
        else if (isset($_GET['birth_year']))
        {
            $conditions[] = " birth_year = :birth_year AND birth_year != 0 ";
            $conditions_params['birth_year'] = $_GET['birth_year'];
        }
    }

    $page = 0; // Set our initial value.

    if (isset($_GET['page']) // Is the "page" parameter set?
        && is_numeric($_GET['page']) // Is the "page" parameter numeric?
        && $_GET['page'] >= 0) // Is the "page" parameter >= 0?
    {
        $page = $_GET['page']; // It's valid, so set it.
    }

    $rpp = $rpp_max; // Set our initial value.

    if (isset($_GET['rpp']) // Is the "rpp" parameter set?
        && is_numeric($_GET['rpp']) // Is the "rpp" parameter numeric?
        && $_GET['rpp'] <= $rpp_max // Is the "rpp" parameter <= to our $rpp_max?
        && $_GET['rpp'] >= 0) // Is the "rpp" parameter >= 0?
    {
        $rpp = $_GET['rpp'];
    }

    // Create our inital select statement.
    $query = "SELECT * FROM " . $trip_table;

    // Add our conditions if we set any.
    if (!empty($conditions))
    {
        $query .= ' WHERE ' . implode(' AND ', $conditions);
    }

    // TODO: get rid of mysql_real_escape_string and use the prepared statement correctly
    $query .= " LIMIT " . mysql_real_escape_string($rpp * $page) . ", " . mysql_real_escape_string($rpp) . " ";

    // take a look at the query to see what's up.    
    // echo $query;

    // We use an include here as an easy way to share the source of this file 
    // on github without sharing our database credentials. In most cases, with 
    // a properly configured MySQL user, database access that does not originate
    // from the "localhost" (i.e. the machine that is serving this PHP script)
    // will not be able to use the hidden credentials even if they get them. 
    // But, it is generally a good practice to hide your user / password info to
    // prevent accidents or oversights.
    include 'credentials.php'; 

    try 
    {
        // These variables should be included with the above credentials.php.
        $dbh = new PDO("mysql:host=$host;dbname=$dbname", $user, $pass);
    }
    catch(PDOException $e) 
    {
        header('Content-Type: application/json');

        print json_encode(array("errorCode" => $e->getCode(), 
                                "errorMessage" => $e->getMessage()));

        return;
    }

    $statement = $dbh->prepare($query);
    $statement->execute($conditions_params);

    $results = $statement->fetchAll(PDO::FETCH_ASSOC);
    $json = json_encode($results);

    $dbh = null; // Close the db connection.

    header('content-type: application/json; charset=utf-8');

    // http://stackoverflow.com/a/20958422/1518329
    function is_valid_callback($subject)
    {
         $identifier_syntax
           = '/^[$_\p{L}][$_\p{L}\p{Mn}\p{Mc}\p{Nd}\p{Pc}\x{200C}\x{200D}]*+$/u';

         $reserved_words = array('break', 'do', 'instanceof', 'typeof', 'case',
           'else', 'new', 'var', 'catch', 'finally', 'return', 'void', 'continue', 
           'for', 'switch', 'while', 'debugger', 'function', 'this', 'with', 
           'default', 'if', 'throw', 'delete', 'in', 'try', 'class', 'enum', 
           'extends', 'super', 'const', 'export', 'import', 'implements', 'let', 
           'private', 'public', 'yield', 'interface', 'package', 'protected', 
           'static', 'null', 'true', 'false');

         return preg_match($identifier_syntax, $subject)
             && ! in_array(mb_strtolower($subject, 'UTF-8'), $reserved_words);
    }

    # JSON if no callback
    if (!isset($_GET['callback']))
         exit( $json );

    # JSONP if valid callback
    if (is_valid_callback($_GET['callback']))
         exit( "{$_GET['callback']}($json)" );

    # Otherwise, bad request
    header('Status: 400 Bad Request', true, 400);

?>
