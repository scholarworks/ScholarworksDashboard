<?php

if($_GET["facet"] === "") echo "Facet String is Empty\n"; // TODO: Determin need for default

$facet = $_GET["facet"];
$data_url = "http://localhost:24091/solr/search/select/?q=*:*&wt=json&rows=0&&facet=true&facet.field=$facet"; // returns JSON formatted facet counts from solr.

// echo file_get_contents($data_url);

$json_array = json_decode(file_get_contents($data_url),TRUE);
// print_r($json_array);

echo "--------------- <br /> -------------------- <br /> <br />";

// print_r($json_array[facet_counts][facet_fields][type_keyword]);
$array_for_loop = $json_array[facet_counts][facet_fields][$facet];

print_r($array_for_loop);