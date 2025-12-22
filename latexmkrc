# LaTeX engine settings for Japanese documents (uplatex + dvipdfmx)
# Note: latexmk will run: uplatex -> pbibtex -> uplatex (repeat) -> dvipdfmx

$latex     = 'uplatex -synctex=1 -interaction=nonstopmode -file-line-error -kanji=utf8 %O %S';
$bibtex    = 'pbibtex -kanji=utf8 %O %B';
$dvipdf    = 'dvipdfmx -f ptex-ipaex.map -z 0 %O -o %D %S';
$makeindex = 'mendex %O -o %D %S';

# Use dvipdfmx-based PDF generation
$pdf_mode        = 3;
$postscript_mode = 0;

# Force multiple runs for proper cross-references and bibliography
$max_repeat = 3;

# Clean up auxiliary files
$clean_ext = 'aux bbl blg dvi fdb_latexmk fls log out toc synctex.gz';

# Ensure proper processing order for Japanese documents
$recorder = 1;
