% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/lsh_candidates.R
\name{lsh_candidates}
\alias{lsh_candidates}
\title{Candidate pairs from LSH comparisons}
\usage{
lsh_candidates(buckets)
}
\arguments{
\item{buckets}{A data frame returned from \code{\link{lsh}}.}
}
\value{
A data frame of candidate pairs.
}
\description{
Given a data frame of LSH buckets returned from \code{\link{lsh}}, this
function returns the potential candidates.
}
\examples{
dir <- system.file("extdata/legal", package = "textreuse")
minhash <- minhash_generator(200, seed = 234)
corpus <- TextReuseCorpus(dir = dir,
                          tokenizer = tokenize_ngrams, n = 5,
                          hash_func = minhash)
buckets <- lsh(corpus, bands = 50)
lsh_candidates(buckets)
}

