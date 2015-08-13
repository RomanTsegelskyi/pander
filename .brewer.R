## generate README from the brew file
print(getwd())
library(pander);
detach('package:pander', unload = TRUE);
library(pander)
evalsOptions('graph.unify', TRUE)
## hardcoded plot name for the README
evalsOptions('graph.name', 'plot-1')
## brew the file to another directory (dedicated to the gh-pages branch)
Pandoc.brew('../pander/inst/README.brew', output = 'index', convert = 'html', open = FALSE, portable.html = FALSE)
## fix img and js/css absolute path
t <- readLines('index.html')
t <- gsub('/usr/lib/R/library/pander/includes/', '', t, fixed = TRUE)
cat(t, file = 'index.html', sep = '\n')
## add README to the pkg (not only to the gh-pages branch)
file.copy('index', 'README.md', overwrite = TRUE)
file.remove('index')

file.remove(list.files('plots/', full.names = TRUE))
examples <- gsub("(.*)\\.brew$", "\\1", list.files("../pander/inst/examples/"))

for (example in examples) {
    brew_path <- file.path("../pander/inst/examples/", paste(example, ".brew", sep=""))
    Pandoc.brew(brew_path, output = example, convert = 'html', open = FALSE)
    for (format in c('pdf', 'docx', 'odt')) {
        tryCatch(Pandoc.convert(example, format = format, open = FALSE), error = function(x) print(x))
    }
    file.rename(example, paste(example, ".md", sep=""))
}
