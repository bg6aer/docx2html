build: docx2html.phar

docx2html.phar:
	php -d phar.readonly=0 build.php

clean:
	rm docx2html.phar
