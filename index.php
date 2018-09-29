<?php

require_once 'globals.php';


echo '<html>';
echo '   <body>';
echo '      <form action = "/process_post.php" method = "POST">';
echo '         Host to scan: <input type="text" name="domain" autocomplete="off"> <br>';
echo '         <input type = "submit" value = "Submit">';
echo '      </form>';
echo '   </body>';
echo '</html>';

?>
