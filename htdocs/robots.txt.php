<?php
	# The only valid domains:
  $validDomains=array (
    'revistes.uab.cat',
    'papers.uab.cat',
    'dag.revista.uab.es',
    'educar.uab.cat',
    'ensciencias.uab.es',
    'atheneadigital.net',
    'elcvia.cvc.uab.es',
    'www.quadernsdepsicologia.cat',
    'www.rpd-online.com',
  );

	if(in_array($_SERVER['HTTP_HOST'],$validDomains)) {
    print ("# No limitations in robots.txt for domain http://".$_SERVER['HTTP_HOST']);
  }
  else {
		print ("# Domain http://".$_SERVER['HTTP_HOST']." is disallowed. \n");
		print ("# Visit http://revistes.uab.cat and find the valid domain of this magazine.\n\n");
		print ("User-agent: *\n");
		print ("Disallow: /");
	}
?>
