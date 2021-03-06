#' Candidate pairs from LSH comparisons
#'
#' Given a data frame of LSH buckets returned from \code{\link{lsh}}, this
#' function returns the potential candidates.
#'
#' @param buckets A data frame returned from \code{\link{lsh}}.
#'
#' @return A data frame of candidate pairs.
#'
#' @examples
#' dir <- system.file("extdata/legal", package = "textreuse")
#' minhash <- minhash_generator(200, seed = 234)
#' corpus <- TextReuseCorpus(dir = dir,
#'                           tokenizer = tokenize_ngrams, n = 5,
#'                           hash_func = minhash)
#' buckets <- lsh(corpus, bands = 50)
#' lsh_candidates(buckets)
#'
#' @export
lsh_candidates <- function(buckets) {
  assert_that(is_lsh_buckets(buckets))

  candidates <- buckets %>%
    dplyr::left_join(buckets, by = "buckets") %>%
    dplyr::select_(~-buckets) %>%
    dplyr::distinct_() %>%
    dplyr::filter_(~doc.x != doc.y) %>%
    dplyr::arrange_(~doc.x, ~doc.y) %>%
    dplyr::distinct_(dn = ~pmin(doc.x, doc.y), up = ~pmax(doc.x, doc.y)) %>%
    dplyr::select_(~-up, ~-dn) %>%
    dplyr::rename_(a = ~doc.x, b = ~doc.y) %>%
    dplyr::arrange_(~a, ~b) %>%
    dplyr::mutate_(score = NA_real_)

  class(candidates) <- c(class(candidates), "textreuse_candidates")

  candidates

}
