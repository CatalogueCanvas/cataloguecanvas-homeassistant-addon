#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(ggplot2)
  library(xkcd)
  library(showtext)
})

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 3) stop("usage: plot_download_stats.R <in.csv> <out.png> <font.ttf>")
in_csv <- args[1]; out_png <- args[2]; font_ttf <- args[3]

font_add("xkcd", font_ttf)
showtext_auto()
showtext_opts(dpi = 150)

BLUE <- "#2a78d6"
INK <- "#52514e"

d <- read.csv(in_csv, stringsAsFactors = FALSE)
d$date <- as.Date(d$date)
d <- d[order(d$date), ]

generated <- format(max(d$date), "%Y-%m-%d")
latest <- d[nrow(d), ]

# xkcdaxis needs a non-degenerate range. With a single row (the first run, and
# any run before a second week has accrued) min == max on both axes, which
# collapses the panel, so pad both ranges by hand.
xr <- if (nrow(d) > 1) {
  c(min(d$date), max(d$date) + (max(d$date) - min(d$date)) * 0.12)
} else {
  c(d$date[1] - 3, d$date[1] + 3)
}
ymax <- max(d$downloads)
yr <- c(0, if (ymax > 0) ymax * 1.25 else 1)

p <- ggplot(d, aes(x = date, y = downloads))

# A line through one point renders nothing, so only add it once there are two.
if (nrow(d) > 1) {
  p <- p + geom_line(colour = BLUE, linewidth = 0.9)
}

p <- p +
  geom_point(colour = BLUE, size = 2.4) +
  geom_text(
    data = latest, aes(label = downloads),
    vjust = -1.1, family = "xkcd", size = 4, colour = INK
  ) +
  xkcdaxis(xrange = as.numeric(xr), yrange = yr) +
  scale_x_continuous(
    breaks = as.numeric(d$date),
    labels = format(d$date, "%d %b")
  ) +
  labs(
    title = "CatalogueCanvas image pulls",
    x = NULL, y = NULL,
    caption = paste("GHCR image pulls as of", generated)
  ) +
  theme_xkcd() +
  theme(
    text = element_text(family = "xkcd", size = 12),
    plot.caption = element_text(family = "xkcd", size = 10, colour = INK)
  )

ggsave(out_png, p, width = 9, height = 5, dpi = 150, bg = "white")
cat("wrote", out_png, "\n")
