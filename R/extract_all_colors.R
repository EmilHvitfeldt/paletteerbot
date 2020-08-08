extract_all_colors <- function(text) {
  pattern <- paste(c("#[0-6a-fA-F]{6,8}", colors()), collapse = "|")
  matches <- gregexpr(pattern = pattern, text = text)
  regmatches(text, m = matches)[[1]]
}
