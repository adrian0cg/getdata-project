## Coursera DataScience "Getting and Cleaning Data"-Project

This contains a file `run_analysis.R` that

1. downloads the source data
2. loads source data
3. assembles test and training data
4. augments the data with activity names
5. augments the data with subject ids
6. prettifies the variable names
7. slices the desired Mean/Standard deviation variables form the full data set
8. performs a group-wise mean over the (subject,activity) combinations
9. wirtes out the result of the aggregation into a file called {tidyGroupMeans.txt}