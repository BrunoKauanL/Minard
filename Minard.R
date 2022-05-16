data(Minard.troops, package="HistData")
str(Minard.troops)

data(Minard.cities, package="HistData")
str(Minard.cities)

data(Minard.temp, package="HistData")
str(Minard.temp)

library("ggplot2")
library("scales")
library("grid")
library("gridExtra")
library("dplyr")
library("ggrepel")

ggplot(Minard.troops, aes(long, lat))

ggplot(Minard.troops, aes(long, lat)) +
  geom_path(aes(size = survivors))

breaks <- c(1, 2, 3) * 10^5 
ggplot(Minard.troops, aes(long, lat)) +
  geom_path(aes(size = survivors, colour = direction, group = group),
            lineend="round") +
  scale_size("Survivors", range = c(1,10), #c(0.5, 15),
             breaks=breaks, labels=scales::comma(breaks)) +
  scale_color_manual("Direction", 
                     values = c("#E22121", "#00FF55"), 
                     labels=c("Advance", "Retreat")) 

plot_troops <- last_plot()

plot_troops + geom_text(data = Minard.cities, aes(label = city), size = 3)
plot_troops +   
  geom_point(data = Minard.cities) +
  geom_text(data = Minard.cities, aes(label = city), vjust = 1.5)

if (!require(ggrepel)) {install.packages("ggrepel"); require(ggrepel)}
library(ggrepel)
plot_troops +   
  geom_point(data = Minard.cities) +
  geom_text_repel(data = Minard.cities, aes(label = city), color = "Purple")

plot_troops_cities <- last_plot()

Minard.temp

ggplot(Minard.temp, aes(long, temp)) +
  geom_path(color="grey", size=1.5) +
  geom_point(size=2)

Minard.temp <- Minard.temp %>%
  mutate(label = paste0(temp, "° ", date))
head(Minard.temp$label)

ggplot(Minard.temp, aes(long, temp)) +
  geom_path(color="grey", size=1.5) +
  geom_point(size=1) +
  geom_text(aes(label=label), size=2, vjust=-1)

ggplot(Minard.temp, aes(long, temp)) +
  geom_path(color="blue", size=1.5) +
  geom_point(size=1) +
  geom_text_repel(aes(label=label), size=2.5)

plot_temp <- last_plot()

grid.arrange(plot_troops_cities, plot_temp)

plot_troops_cities +
  coord_cartesian(xlim = c(24, 38)) +
  labs(x = NULL, y = NULL) +
  guides(color = FALSE, size = FALSE) +
  theme_void()

plot_troops_cities_fixed <- last_plot()

plot_temp + 
  coord_cartesian(xlim = c(24, 38)) +
  labs(x = NULL, y="Temperature") + 
  theme_bw() +
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.text.x = element_blank(), axis.ticks = element_blank(),
        panel.border = element_blank())

plot_temp_fixed <- last_plot()

grid.arrange(plot_troops_cities_fixed, plot_temp_fixed, nrow=2, heights=c(3.5, 1.2))
grid.rect(width = .99, height = .99, gp = gpar(lwd = 2, col = "gray", fill = NA))


