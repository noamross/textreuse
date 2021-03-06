% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/TextReuseTextDocument.R
\name{TextReuseTextDocument}
\alias{TextReuseTextDocument}
\alias{has_content}
\alias{has_hashes}
\alias{has_tokens}
\alias{is.TextReuseTextDocument}
\title{TextReuseTextDocument}
\usage{
TextReuseTextDocument(text, file = NULL, meta = list(),
  tokenizer = tokenize_ngrams, ..., hash_func = hash_string,
  keep_tokens = FALSE, keep_text = TRUE, skip_short = TRUE)

is.TextReuseTextDocument(x)

has_content(x)

has_tokens(x)

has_hashes(x)
}
\arguments{
\item{text}{A character vector containing the text of the document. This
argument can be skipped if supplying \code{file}.}

\item{file}{The path to a text file, if \code{text} is not provided.}

\item{meta}{A list with named elements for the metadata associated with this
document. If a document is created using the \code{text} parameter, then
you must provide an \code{id} field, e.g., \code{meta = list(id =
"my_id")}. If the document is created using \code{file}, then the ID will
be created from the file name.}

\item{tokenizer}{A function to split the text into tokens. See
\code{\link{tokenizers}}. If value is \code{NULL}, then tokenizing and
hashing will be skipped.}

\item{...}{Arguments passed on to the \code{tokenizer}.}

\item{hash_func}{A function to hash the tokens. See
\code{\link{hash_string}}.}

\item{keep_tokens}{Should the tokens be saved in the document that is
returned or discarded?}

\item{keep_text}{Should the text be saved in the document that is returned or
discarded?}

\item{skip_short}{Should short documents be skipped? (See details.)}

\item{x}{An R object to check.}
}
\value{
An object of class \code{TextReuseTextDocument}. This object inherits
  from the virtual S3 class \code{\link[NLP]{TextDocument}} in the NLP
  package. It contains the following elements: \describe{ \item{content}{The
  text of the document.} \item{tokens}{The tokens created from the text.}
  \item{hashes}{Hashes created from the tokens.} \item{metadata}{The document
  metadata, including the filename (if any) in \code{file}.} }
}
\description{
This is the constructor function for \code{TextReuseTextDocument} objects.
This class is used for comparing documents.
}
\details{
This constructor function follows a three-step process. It reads in
  the text, either from a file or from memory. It then tokenizes that text.
  Then it hashes the tokens. Most of the comparison functions in this package
  rely only on the hashes to make the comparison. By passing \code{FALSE} to
  \code{keep_tokens} and \code{keep_text}, you can avoid saving those
  objects, which can result in significant memory savings for large corpora.

  If \code{skip_short = TRUE}, this function will return \code{NULL} for very
  short or empty documents. A very short document is one where there are two
  few words to create at least two n-grams. For example, if five-grams are
  desired, then a document must be at least six words long. If no value of
  \code{n} is provided, then the function assumes a value of \code{n = 3}. A
  warning will be printed with the document ID of a skipped document.
}
\examples{
file <- system.file("extdata/legal/ny1850-match.txt", package = "textreuse")
doc  <- TextReuseTextDocument(file = file, meta = list(id = "ny1850"))
print(doc)
meta(doc)
head(tokens(doc))
head(hashes(doc))
\dontrun{
content(doc)
}
}

