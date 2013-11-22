<?php
        # The only valid domain:
        $validDomain='revistes.uab.cat';

        if($_SERVER['HTTP_HOST'] != $validDomain) {
                print ("# Domain ".$_SERVER['HTTP_HOST']." is disallowed. \n");
                print ("# Try with http://$validDomain/robots.txt instead.\n\n");
                print ("User-agent: *\n");
                print ("Disallow: /");
        }
        else {
    print ("# No limitations in robots.txt for domain http://$validDomain.");
        }
?>
