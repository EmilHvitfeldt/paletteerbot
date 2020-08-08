
adjective <- c(
  "ace",
  "adorable",
  "amazing",
  "astonishing",
  "astounding",
  "awe-inspiring",
  "awesome",
  "badass",
  "beautiful",
  "bedazzling",
  "breathtaking",
  "brilliant",
  "charming",
  "clever",
  "chic",
  "classy",
  "clever",
  "cool",
  "crackin'",
  "cute",
  "dandy",
  "dazzling",
  "delightful",
  "divine",
  "elegant",
  "excellent",
  "exceptional",
  "exciting",
  "exquisite",
  "extraordinary",
  "fabulous",
  "fancy",
  "fantastic",
  "fantabulous",
  "fascinating",
  "first-class",
  "first-rate",
  "flawless",
  "glorious",
  "gorgeous",
  "grand",
  "great",
  "groovy",
  "groundbreaking",
  "hip",
  "impeccable",
  "impressive",
  "incredible",
  "irresistible",
  "kickass",
  "legendary",
  "lovely",
  "magnificent",
  "majestic",
  "marvelous",
  "mind-blowing",
  "outstanding",
  "particular",
  "peachy",
  "peculiar",
  "perfect",
  "phenomenal",
  "polished",
  "prime",
  "rad",
  "remarkable",
  "riveting",
  "sensational",
  "sharp",
  "shining",
  "slick",
  "smart",
  "smashing",
  "special",
  "spectacular",
  "striking",
  "stylish",
  "supreme",
  "ultimate",
  "unique",
  "well-made",
  "wicked",
  "wise",
  "wonderful",
  "wondrous",
  "world-class"
)

special_day <- function(pal) {
  if (pal$weekday == "Monday") {
    return("PokéMonday")
  } else if (pal$weekday == "Friday") {
    return("Continuous Friday")
  } else {
    return(pal$weekday)
  }
}

palette_ref <- function(pal) {
  ref <- strsplit(Today_palette$slug, '::')[[1]]
  paste0("The ", ref[2], " palette from the {", ref[1], "} package")
}

emojis <- c("star", "star2", "dizzy", "tada", "fire", "paintbrush",
            "artist_palette", "man_artist", "artist_palette")

link_text <- function(pal) {

  ref <- paletteer_packages %>%
    filter(Name == strsplit(pal$slug, "::")[[1]][1])

  if (ref$CRAN) {
    if (is.null(ref$github_ver)) {
      res <- glue("{ref$Name} is available on CRAN!")
    } else {
      res <- glue("{ref$Name} is available on CRAN and on Github:\n",
                  "https://github.com/{ref$Github}")
    }
  } else {
    res <- glue("{ref$Name} is available on Github:\n",
                "https://github.com/{ref$Github}")
  }
  res
}

daily_tweet <- function(pal) {
  emoji_pick <- ji(sample(emojis, 1))

  glue(
    "Hello Twitter! It is {special_day(pal)} and I have a {sample(adjective, 1)} color palette for you!\n\n",
    "{emoji_pick}{palette_ref(pal)}{emoji_pick}\n\n",
    "{link_text(pal)}"
  )
}
