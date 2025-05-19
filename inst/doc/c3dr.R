## -----------------------------------------------------------------------------
#| eval: false
# install.packages("c3dr", repos = "https://ropensci.r-universe.dev")
# 
# # Alternative:
# # if (!require(remotes)) install.packages("remotes")
# # remotes::install_github("ropensci/c3dr")


## -----------------------------------------------------------------------------
library(c3dr)
# this example uses an internal example file
filepath <- c3d_example()

# import C3D file
d <- c3d_read(filepath)
d


## -----------------------------------------------------------------------------
str(d, max.level = 1)


## -----------------------------------------------------------------------------
d$header


## -----------------------------------------------------------------------------
str(d$parameters, max.level = 1)

# retrieve SOFTWARE parameter from MANUFACTURER group
d$parameters$MANUFACTURER$SOFTWARE


## -----------------------------------------------------------------------------
# read the coordinates of the first frame for the second data point
d$data[[1]][[2]]


## -----------------------------------------------------------------------------
d$analog[[2]][3, 1]

# read the values of the first five analog channels for the first point frame
# The sampling frequency is ten times that of the point data, resulting in
# ten subframes
d$analog[[1]][, 1:5]


## -----------------------------------------------------------------------------
# this example file has data from two force platforms
str(d$forceplatform)


## -----------------------------------------------------------------------------
# view for the first force platform the force data for the first five frames
d$forceplatform[[1]]$forces[1:5, ]


## -----------------------------------------------------------------------------
p <- c3d_data(d)

p[1:5, 1:5]


## -----------------------------------------------------------------------------
p_long <- c3d_data(d, format = "long")
p_long[1:5, 1:5]

p_longest <- c3d_data(d, format = "longest")
p_longest[1:5, ]


## -----------------------------------------------------------------------------
a <- c3d_analog(d)
a[1:5, 41:46]


## -----------------------------------------------------------------------------
# plot the z-coordinate (the vertical position) of the right heel
plot(p$R_FCC_z, xlab = "Recording Frame", ylab = "Vertical Position (mm)")

# plot the vertical force vector of the second force platform
plot(
  d$forceplatform[[2]]$forces[, 3],
  xlab = "Recording Frame",
  ylab = "Vertical Force (N)"
)


## -----------------------------------------------------------------------------
#| eval: false
# c3d_write(d, "newfile.c3d")


## -----------------------------------------------------------------------------
#| eval: false
# # E.g. remove the last point from the point data
# full_data <- c3d_data(d, format = "long")
# cut_data <- full_data[, -57]
# 
# # update the data and write to new file
# new_object <- c3d_setdata(d, newdata = cut_data)
# c3d_write(new_object, "modified.c3d")

