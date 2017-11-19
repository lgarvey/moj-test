<?php

   $host        = "host = db";
   $port        = "port = 5432";
   $dbname      = "dbname = template1";
   $credentials = "user = postgres password=mysecretpassword";

   $db = pg_connect("$host $port $dbname $credentials");
   if(!$db) {
      echo "Error : Unable to open database\n";
   } else {
      echo "Opened database successfully\n";
   }
