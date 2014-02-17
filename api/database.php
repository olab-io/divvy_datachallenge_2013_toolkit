<?php
 // Connect to the divvy database.
 mysql_connect("HOSTNAME",
               "USERNAME",    
               "PASSWORD") or die(mysql_error());
 // Select the divvy database. 
 mysql_select_db("divvy_2013") or die(mysql_error());   
?>  

