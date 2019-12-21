waterloo %>%
  ggplot(aes(x = time)) +
  geom_point(stat = "count")

waterloo %>%
  count_group(time) %>%
  ggplot(aes(x = time, y = count)) +
  geom_point() +
  geom_smooth(method = "lm")

waterloo %>%
  count_group(minute) %>%
  ggplot(aes(x = minute, y = count)) +
  geom_point() +
  geom_smooth()

waterloo %>%
  ggplot(aes(x = hour)) +
  geom_bar(stat = "count")

waterloo %>%
  ggplot(aes(x = hour)) +
  geom_bar(aes(y = (..count..)/sum(..count..))) + 
  scale_y_continuous(labels=scales::percent)


