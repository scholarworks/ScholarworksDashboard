<?php

if($_GET["facet"] === "") echo "Facet String is Empty\n"; // TODO: Determin need for default

$facet = $_GET["facet"];
$data_url = "http://localhost:24091/solr/search/select/?q=*:*&wt=json&rows=0&&facet=true&facet.field=$facet"; // returns JSON formatted facet counts from solr.

// echo file_get_contents($data_url);

$json_array = json_decode(file_get_contents($data_url),TRUE);
// print_r($json_array);

// echo "--------------- <br /> -------------------- <br /> <br />";

// print_r($json_array[facet_counts][facet_fields][type_keyword]);
$array_for_loop = $json_array[facet_counts][facet_fields][$facet];

// print_r($array_for_loop);
$array_for_json = array();
// echo "COUNT = " . count($array_for_loop);

for($i=0; $i<count($array_for_loop); $i+=2) {
	$step = $i;
	$step2 = $i+1;
	$name = $array_for_loop[$step];
	$count = $array_for_loop[$step2];
	
	$nextLevelDataUrl = "http://localhost:24091/solr/search/select/?q=$facet:\"" . urlencode($name) . "\"&wt=json&rows=0&&facet=true&facet.field=$facet"; // returns JSON formatted facet counts from solr.
	$nextLevelJsonArray = json_decode(file_get_contents($nextLevelDataUrl),TRUE);
	$nextLevelArrayForLoop = $nextLevelJsonArray[facet_counts][facet_fields][$facet];
	
	$childrenArray = array();
	$children = 0;
	for($j=0; $j<count($nextLevelArrayForLoop); $j+=2) {
		$levelStep = $j;
		$levelStep2 = $j+1;
		$childName = $nextLevelArrayForLoop[$levelStep];
		$childCount = $nextLevelArrayForLoop[$levelStep2];
	
		if($childCount > 0) {
			$children = 1;
			array_push($childrenArray,array("name" => $nextLevelArrayForLoop[$levelStep], "size" => $nextLevelArrayForLoop[$levelStep2]));
		}
	}
	
	if($children) {
		array_push($array_for_json,array("name" => $name, "children" => $childrenArray));
	}
}

echo json_encode($array_for_json);
// print_r($array_for_json);