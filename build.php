<?php
$a = new Phar('docx2html.phar');

$a->addFile('docx2html.xslt');
$a->addFile('html.php');

$a->setStub('#!/usr/bin/env php
<?php

   Phar::mapPhar("docx2html.phar");

   if (empty($argv[1])) {

      die("You must provide a word file as a first argument\n");
   }

   if (!file_exists($argv[1])) {

      die("The file {$argv[1]} does not exist\n");
   }

   $xslDoc = new DOMDocument();
   $xslDoc->load("phar://docx2html.phar/docx2html.xslt");

   $xmlDoc = new DOMDocument();
   $xmlDoc->load("zip://file.docx#word/document.xml");

   $proc = new XSLTProcessor();
   $proc->importStylesheet($xslDoc);
   echo $proc->transformToXML($xmlDoc);

 __HALT_COMPILER();');

$a->compressFiles(Phar::GZ);
