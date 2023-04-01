# R Basics session A-State RUG
# Alix Matthews
# Date created: 20230328

# load packages ####

### we will fill this out later

# session info ####
xfun::session_info()

# 1. Some basics ####
## 1.1. Objects ####

my_obj <- 48 # check out what has been added to your environment now!

my_obj2 <- "R is fun" # try it without quotes and see what happens

my_obj2 <- 1024 # what happened in your environment?

my_obj3 <- my_obj + my_obj2 # what are we doing here?

my_obj3 # see the output

my_obj4 # what happens?


## 1.2. Vectors ####
my_vec <- c(20, 3, 11, 16, 14, 1, 9, 17) # create the vector

my_vec # view the vector

my_vec[5] # extract the value at the 5th index

my_vec[5] <- 15 # replace this value with another value
my_vec[5] # double-check that it worked

my_vec < 10 # logical expression of which indices are less than 10


## 1.3. Basic functions ####
which(my_vec < 10) # identify which indices are less than 10. Compare with logical output above.

mean(my_vec) # mean of the string of values
sd(my_vec) # standard dev of the string of values
length(my_vec) # how many values are in the object

## 1.4. Plotting and help ####
plot(my_vec) # very basic plotting

?plot # Need help? let’s view the help documentation to see what other arguments we can pass to plot, may have to dig around a little bit

plot(my_vec, col = "blue", pch = 16, cex = 2) # try this, play around with other arguments



# 2. Data frames ####

# There are other data structures, including vectors (like above), matrices, arrays, lists, etc. but data frames are the most commonly used

# A data frame is a list of vectors (columns)
# Each column is a vector, has a name, has a data type, and is subject to manipulation (not every column has to be the same data type)

## 2.1. Pre-loaded data frames ####

str(iris) # view the 'structure' of the iris data frame
iris$Sepal.Length # extract values from certain columns (use $)

head(iris) # view first 6 lines of the df
tail(iris) # view last 6 lines of the df

View(iris) # try this and see what happens

# subsetting (just an aside)
iris_setosa <- subset(iris, Species=="setosa")
View(iris_setosa) # check it out
levels(iris_setosa$Species) # BUT... are the other species still secretly "there"? This can be an annoyance during downstream plotting. There are a few ways to fix this, but here is my preferred way...
iris_setosa$Species <- factor(iris_setosa$Species) # factor it again
levels(iris_setosa$Species) # Now they're gone!


### 2.1.1. Base R plotting ####

# Basic plot
plot(Petal.Width~Petal.Length, iris)

# Basic plot (more advanced)
plot(Petal.Width~Petal.Length, iris,
     type = "p", # "p" for points, "l" for lines, "b" for both, others
     pch = 2, # style of point by factor; many options here (1-25)
     col = c("darkgreen", "darkorange", "darkmagenta")[as.factor(iris$Species)], # interesting things happen if you don't include the [as.factor(iris$Species)] part
     main = "Petal width vs. length",
     xlab = "Petal length (cm)",
     ylab = "Petal width (cm)"
)

legend("topleft", legend = unique(iris$Species), col = c("darkgreen", "darkorange", "darkmagenta"), pch = 2)


## 2.2. Import our own data frame ####

# Typically, .csv or .txt are the most commonly imported (not .xls or .xlsx)

# make sure the .csv file is located in your working directory. Otherwise, put the absolute (or relative) path in the quotes where the file name is...

flower_db <- read.csv(file = "flower.csv", sep = ",") # other helpful arguments here are `header = TRUE` and `sep = "\t"` if tab-delimited

str(flower_db)

### 2.2.1. Lil' bitta data wrangling ####

# Right now, some of our columns are `characters`. We need to make them factors for analysis and plotting. We have two (plus more) options. Pick one!

#### Option 1. Factor each column individually ####

flower_db$treat <- as.factor(flower_db$treat)
flower_db$nitrogen <- as.factor(flower_db$nitrogen)
flower_db$block <- as.factor(flower_db$block)

str(flower_db)

#### Option 2. Use lapply ####
cols_to_factor <- c("treat", "nitrogen", "block")
flower_db[,cols_to_factor] <- lapply(flower_db[,cols_to_factor] ,factor)

str(flower_db)

### 2.2.2. ggplotting ####

# Here is where we're installing and loading a new library! Installation may take a couple minutes depending on your machine...

install.packages("ggplot2")
library(ggplot2)

# Basic ggplot
ggplot(flower_db, aes(x = nitrogen, y = flowers)) +
    geom_boxplot()

# Basic ggplot (more advanced)
ggplot(flower_db, aes(x = factor(nitrogen, level = c("low", "medium", "high")), y = flowers, fill = nitrogen)) +
    geom_boxplot() +
    theme_bw() +
    scale_fill_manual(values = c("high" = "tomato3", "medium" = "steelblue", "low" = "lightpink")) +
    theme(legend.position="none") +
    scale_x_discrete(labels = c("High", "Medium", "Low")) +
    xlab("Nitrogen Concentration") +
    ylab("Number of Flowers Produced") +
    theme(axis.text=element_text(size=12),
          axis.title=element_text(size=15))

