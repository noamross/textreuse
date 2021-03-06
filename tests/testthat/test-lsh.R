context("LSH")

dir <- system.file("extdata/legal", package = "textreuse")
minhash <- minhash_generator(200, seed = 4236)
corpus <- TextReuseCorpus(dir = dir,
                          tokenizer = tokenize_ngrams, n = 5,
                          keep_tokens = TRUE,
                          hash_func = minhash)
buckets <- lsh(corpus, bands = 50)
candidates <- lsh_candidates(buckets)
corpus <- rehash(corpus, hash_string)
scores <- lsh_compare(candidates, corpus, jaccard_similarity)

test_that("returns a data frame with additional class", {
  expect_is(buckets, "tbl_df")
  expect_is(buckets, "lsh_buckets")
})

test_that("returns error if improper number of bands are chosen", {
  expect_error(lsh(corpus, bands = 33), "The number of hashes")
})

test_that("returns pairs of candidates", {
  expect_is(candidates, "data.frame")
  expect_named(candidates, c("a", "b", "score"))
  expect_equal(candidates[[1, 1]], "ca1851-match")
  expect_equal(candidates[[1, 2]], "ny1850-match")
  expect_equal(candidates[[1, 3]], NA_real_)
})

test_that("additional documents can be added", {
  corpus2 <- rehash(corpus, minhash)
  buckets1and2 <- lsh(corpus2[1:2], bands = 50)
  buckets3 <- lsh(corpus2[[3]], bands = 50)
  buckets_combined <- dplyr::bind_rows(buckets1and2, buckets3)
  expect_equal(buckets_combined$buckets, buckets$buckets)
  expect_equal(buckets_combined$doc, buckets$doc)
})

test_that("candidates can be scored", {
  correct <- jaccard_similarity(corpus[["ca1851-match"]],
                                corpus[["ny1850-match"]])
  expect_equal(scores[[1,3]], correct)
})
