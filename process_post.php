<?php
    /* require_once 'globals.php'; */

    $TOPDIR = '/var/www/tlsa.koeroo.net/';
    $GEN_TLSA_SH=$TOPDIR.'gen_tlsa.sh';
    $PROCESS_POST_PHP="process_post.php";


    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        /* Start processing */
        $domain = trim($_POST["domain"]);

        if(preg_match('/[^\.a-zA-Z\-0-9]/i', $domain)) {
            header("refresh:4;url=index.php");
            print("Not a valid FQAN. No special characters allowed.\n");
            print("You typed: ");
            print($domain);
            return;
        }


        print('<!DOCTYPE html>');
        print('<html>');
        print('<head>');
        print('<link rel="stylesheet" type="text/css" href="mystyle.css">');
        print('</head>');
        print('<body>');

        print('<h1>Legend:</h1>');
        print('The first output line is generated by using a certificate lookup, process the certificate hash value and creating a TLSA hash and 3 1 1 record type.<br>');
        print('The second output line is based on a DNS query on the TLSA record type.<br>');


        print('<h1>TLSA record:</h1>');

        /* Input is clean, start processing */

        $cmd = $GEN_TLSA_SH. " " . $domain;
        exec($cmd, $output);

        foreach ($output as &$value) {
            print($value.'<br>');
        }
        print ("<br>");


        print('</body>');
        print('</html>');
        return;
    }
?>
