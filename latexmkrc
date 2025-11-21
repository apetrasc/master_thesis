# LaTeX engine settings for Japanese documents
$latex = 'uplatex -interaction=nonstopmode';
$pdflatex = 'uplatex -interaction=nonstopmode';
$bibtex = 'pbibtex -kanji=utf8';
$dvipdfmx = 'dvipdfmx -f ptex-ipaex.map %O -o %D %S';
$makeindex = 'mendex %O -o %D %S';

# PDF generation mode (3 = dvipdfmx, not dvipdf)
$pdf_mode = 3;
$postscript_mode = 0;

# Disable dvipdf rule to prevent conflicts
$dvipdf = '';

# Force multiple runs for proper cross-references and bibliography
$max_repeat = 3;

# Clean up auxiliary files
$clean_ext = 'aux bbl blg dvi fdb_latexmk fls log out toc synctex.gz';

# Ensure proper processing order for Japanese documents
$recorder = 1;
