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


        /* Input is clean, start processing */

        $cmd = $GEN_TLSA_SH. " " . $domain;
        $output = exec($cmd);
        print('TLSA record:');
        print ("<br>\n");
        print ("<br>\n");
        print($output);
        print ("<br>");

        return;
    }
?>
