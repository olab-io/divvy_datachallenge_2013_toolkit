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

    // We use an include here as an easy way to share the source of this file 
    // on github without sharing our database credentials. In most cases, with 
    // a properly configured MySQL user, database access that does not originate
    // from the "localhost" (i.e. the machine that is serving this PHP script)
    // will not be able to use the hidden credentials even if they get them. 
    // But, it is generally a good practice to hide your user / password info to
    // prevent accidents or oversights.

    include 'credentials.php'; 

    // Configuration
    $stations_table = "Divvy_Stations_2013"; // The name of the trips table

    // Create our inital select statement.
    $query = "SELECT * FROM " . $stations_table;

    // take a look at the query to see what's up.    
    // echo $query;


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
