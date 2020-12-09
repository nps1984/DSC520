# Load library
library(readr)
library(ggplot2)
library(magrittr)
library(tidyr)
library(pastecs)
library(dplyr)
library(vcd)

# Load data
oscar_preds <- read_csv("oscar-prediction-dataset-1000v.csv")

# Split comma separate genre column into multiple genre columns.
oscar_preds <- oscar_preds %>% separate(genres, c("genre_1", "genre_2", "genre_3"), ",", extra = "drop", fill = "right")

# Preview the data
head(oscar_preds)
str(oscar_preds)

# I care mostly about the first genre, so check for NAs (should be NONE!)
any(is.na(oscar_preds$genre_1))

# Check our genres
ggplot(data=oscar_preds, aes(x=oscar_preds$genre_1)) +
  geom_bar()

# note some peculiar genres from graph above, review data
subset(oscar_preds, genre_1 == 'NULL' | genre_1 == 'Adult', select = c(primary_title))

## Remove 2 "adult" records. Convert 2 null to documentary based on additional research (The Cleaners and Jane Fonda in Five Acts)
oscar_preds$genre_1[oscar_preds$genre_1 == "NULL"] <- 'Documentary'
oscar_preds <- subset(oscar_preds, genre_1 != "Adult")

# Oscars seem to congregate around certain genre's. I think we should remove non-relevant genres
subset(subset(oscar_preds, have_win == 1) %>% 
         group_by(genre_1) %>%
         tally(), n >= 40)

# Remove everything not in specified genres
oscar_preds <- subset(oscar_preds, genre_1 %in% cbind("Action","Adventure","Biography","Comedy","Crime","Drama"))

# Re-plot genres again
ggplot(data=oscar_preds, aes(x=oscar_preds$genre_1)) +
  geom_bar()

# a few runtimes were expressed as chars, resulting in the column be a char. convert to number
oscar_preds <- transform(oscar_preds, runtime_minutes = as.numeric(runtime_minutes))

# Throw away NAs and "shorts"
oscar_preds <- subset(oscar_preds, !is.na(oscar_preds$runtime_minutes) & oscar_preds$runtime_minutes > 40 & genre_1 != "Short"
                      & genre_2 != "Short" & genre_3 != "Short" )

# Check on the distribution of our average rating
ggplot(data=oscar_preds, aes(x=oscar_preds$average_rating)) +
  geom_histogram(binwidth = 0.25)

stat.desc(oscar_preds[sample(nrow(oscar_preds), 5000), "average_rating"], basic = FALSE, norm = TRUE)

# Check our distribution of number of votes... hmm something is askew here.
ggplot(data=oscar_preds, aes(x=oscar_preds$number_votes)) +
  geom_histogram(binwidth = 100000)

# Whoa our skew and kurtosis is bad. As bad as your halitosis.
stat.desc(oscar_preds[sample(nrow(oscar_preds), 5000), "number_votes"], basic = FALSE, norm = TRUE)

# Get an idea of counts
# How many oscar winners? 589
sum(oscar_preds$have_win == 1)

# How many films have less than 100,000 votes? 12960
sum(oscar_preds$number_votes < 100000)

# How many films have more than or equal to 100,000 votes? 1182
sum(oscar_preds$number_votes >= 100000)

# What is minimum (1001 votes) & mean (25021.28) number of votes for an oscar winner, mostly for curiosity?
min(subset(oscar_preds, have_win = 1, select=c(number_votes)))
subset(oscar_preds, have_win = 1, select=c(number_votes)) %>% lapply(mean)

# Create new dataframe for just oscar winners
oscar_winners <- subset(oscar_preds, have_win == 1)

# Let's plot our votes for oscar winners....hmm also very skewed. Why? Genre? Shorts...
ggplot(data=oscar_winners, aes(x=oscar_winners$number_votes)) +
  geom_histogram(binwidth = 100000)

# Let's revisit that halitosis with our winners.
stat.desc(oscar_winners$number_votes, basic = FALSE, norm = TRUE)

# Check our genres... shows that drama wins most of our Oscars
ggplot(data=oscar_winners, aes(x=oscar_winners$genre_1)) +
  geom_bar()

oscar_preds$genre.factor <- as.numeric(factor(oscar_preds$genre_1))
oscar_winners$genre.factor <- as.numeric(factor(oscar_winners$genre_1))

cor(oscar_preds$genre.factor,oscar_preds$have_win)^2
cor(oscar_winners$have_win,oscar_winners$genre.factor)

cor(oscar_preds[,c("have_win","prior_director_win","prior_actor_win","prior_writer_win","prior_other_win")])

str(oscar_preds)
###
# NEED MORE GRAPHS???
###

# Fit a model
mod = glm(have_win ~ genre_1 + factor(prior_director_win) + factor(prior_actor_win) + 
         factor(prior_writer_win) + factor(prior_other_win), data = oscar_preds,
         family = binomial())

confint(mod)
summary(mod)
exp(coef(mod))

mod3 <- aov(have_win ~ genre_1 + factor(prior_director_win) + factor(prior_actor_win) + 
      factor(prior_writer_win) + factor(prior_other_win), data = oscar_preds)

summary(mod3)

# https://psu-psychology.github.io/r-bootcamp-2018/talks/anova_categorical.html#working-with-categorical-data


# Show counts of different combinations
tb2 <- xtabs(~genre_1 + prior_director_win + prior_actor_win + prior_writer_win +
               prior_other_win + have_win, oscar_preds)

tb3 <- xtabs(~genre_1 + prior_director_win + prior_actor_win + have_win, oscar_preds)

tb4 <- structable(prior_director_win + prior_actor_win + prior_writer_win +
                    prior_other_win ~  have_win, oscar_preds)


ftable(tb2)
ftable(tb3)

assocstats(tb3)
mosaic(tb3)
