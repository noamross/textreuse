#' Recompute the tokens for a document or corpus
#'
#' Given a \code{\link{TextReuseTextDocument}} or a
#' \code{\link{TextReuseCorpus}}, this function recomputes the tokens and hashes
#' with the functions specified.
#'
#' @param x A \code{\link{TextReuseTextDocument}} or
#'   \code{\link{TextReuseCorpus}}.
#' @param tokenizer A function to split the text into tokens. See
#'   \code{\link{tokenizers}}.
#' @param ... Arguments passed on to the \code{tokenizer}.
#' @param hash_func A function to hash the tokens. See
#'   \code{\link{hash_string}}, \code{\link{minhash_generator}}.
#' @param keep_tokens Should the tokens be saved in the document that is
#'   returned or discarded?
#' @param keep_text Should the text be saved in the document that is returned or
#'   discarded?
#'
#' @return The modified \code{\link{TextReuseTextDocument}} or
#'   \code{\link{TextReuseCorpus}}.
#'
#' @examples
#' dir <- system.file("extdata/legal", package = "textreuse")
#' corpus <- TextReuseCorpus(dir = dir, tokenizer = NULL)
#' corpus <- tokenize(corpus, tokenize_ngrams)
#' head(tokens(corpus[[1]]))
#' @export
tokenize <- function(x, tokenizer, ..., hash_func = hash_string,
                     keep_tokens = FALSE, keep_text = TRUE) {
  UseMethod("tokenize", x)
}

#' @export
tokenize.TextReuseTextDocument <- function(x, tokenizer, ...,
                                           hash_func = hash_string,
                                           keep_tokens = TRUE,
                                           keep_text = TRUE) {
  assert_that(has_content(x),
              is.function(tokenizer),
              is.function(hash_func))
  x$tokens <- tokenizer(x$content, ...)
  x$hashes <- hash_func(x$tokens)
  if (!keep_tokens) x$tokens <- NULL
  if (!keep_text) x$text <- NULL
  x$meta$tokenizer <- as.character(substitute(tokenizer))
  x$meta$hash_func <- as.character(substitute(hash_func))
  x
}

#' @export
tokenize.TextReuseCorpus <- function(x, tokenizer, ..., hash_func = hash_string,
                                     keep_tokens = TRUE, keep_text = TRUE) {
  x$documents <- lapply(x$documents, tokenize, tokenizer, ...,
                        hash_func = hash_func, keep_tokens = keep_tokens,
                        keep_text = keep_text)

  x$meta$tokenizer <- as.character(substitute(tokenizer))
  x$meta$hash_func <- as.character(substitute(hash_func))

  x

}
