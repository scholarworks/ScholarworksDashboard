<?php

if($_GET["facet"] === "") echo "Facet String is Empty\n"; // TODO: Determin need for default

$facet = $_GET["facet"];
$data_url = "http://localhost:24091/solr/search/select/?q=*%3A*&version=2.2&start=0&rows=0&indent=on&wt=json&facet=true&facet.field=$facet"; // returns JSON formatted facet counts from solr.

echo file_get_contents($data_url);
