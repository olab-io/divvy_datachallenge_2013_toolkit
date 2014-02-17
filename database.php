<?php
 // Connect to the divvy database.
 mysql_connect("DATABASE_HOST",
               "DATABASE_USERNAME",    
               "DATABAES_PASSWORD") or die(mysql_error());
 // Select the divvy database. 
 mysql_select_db("divvy_2013") or die(mysql_error());   
?>  
