<?php
// Connecting, selecting database
$dbconna = pg_connect("host=" . $_SERVER['POSTGRESQL1_HOST'] . " dbname=" . $_SERVER['POSTGRESQL1_NAME'] . " user=" . $_SERVER['POSTGRESQL1_USER'] . " password=" . $_SERVER['POSTGRESQL1_PASS'])
    or die('Could not connect: ' . pg_last_error());

// create table
$query = 'CREATE TABLE IF NOT EXISTS authors (author varchar(40), email varchar(40))';
$result = pg_query($query) or die('Query failed: ' . pg_last_error());
// insert data
$query = "INSERT INTO authors (author, email) VALUES ('test author 9.4', 'author@test.com')";
$result = pg_query($query) or die('Query failed: ' . pg_last_error());
// Performing SQL query
$query = 'SELECT * FROM authors';
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

// Printing results in HTML
echo "<table>\n";
while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
    echo "\t<tr>\n";
    foreach ($line as $col_value) {
        echo "\t\t<td>$col_value</td>\n";
    }
    echo "\t</tr>\n";
}
echo "</table>\n";

// Free resultset
pg_free_result($result);

// Closing connection
pg_close($dbconna);

// Connecting, selecting database
$dbconnb = pg_connect("host=" . $_SERVER['POSTGRESQL2_HOST'] . " dbname=" . $_SERVER['POSTGRESQL2_NAME'] . " user=" . $_SERVER['POSTGRESQL2_USER'] . " password=" . $_SERVER['POSTGRESQL2_PASS'])
    or die('Could not connect: ' . pg_last_error());

// create table
$query = 'CREATE TABLE IF NOT EXISTS authors (author varchar(40), email varchar(40))';
$result = pg_query($query) or die('Query failed: ' . pg_last_error());
// insert data
$query = "INSERT INTO authors (author, email) VALUES ('test author 9.3', 'author@test.com')";
$result = pg_query($query) or die('Query failed: ' . pg_last_error());
// Performing SQL query
$query = 'SELECT * FROM authors';
$result = pg_query($query) or die('Query failed: ' . pg_last_error());

// Printing results in HTML
echo "<table>\n";
while ($line = pg_fetch_array($result, null, PGSQL_ASSOC)) {
    echo "\t<tr>\n";
    foreach ($line as $col_value) {
        echo "\t\t<td>$col_value</td>\n";
    }
    echo "\t</tr>\n";
}
echo "</table>\n";

// Free resultset
pg_free_result($result);

// Closing connection
pg_close($dbconnb);
?>