# Oscar Predictions
This was one of my first major "data science" projects in my data science program. It was done in the R language, which admittedly I was very unfamiliar with.
As you go through this, you will probably note that I didn't really know what I was doing in terms of data science. But I am highlighting this project because of a few things:
* The R code is decent, especially for a beginner
* It is (nearly) fully contained within the RMD file
* It highlights my abilities with databases

## R Code
There is an R script in the repository. And while it works, it doesn't provide much for the final product. 
This was mostly just a "scratch" script I was using while I was learning and building my skills throughout the project.

## RMarkdown
There are 3 RMarkdown files that comprise the bulk of the project. And each one highlights various objectives.

* **Part 1** - Data inspection
* **Part 2** - Data Cleanup/EDA
* **Part 3** - Findings

## SQL
There are a couple of SQL files. These were used in the postgresql database that was built for this project.

## CSV
These files contain the exported & cleaned data.

## Notes
The original datasets came from
* https://datasets.imdbws.com
* https://www.kaggle.com/unanimad/the-oscar-award

As noted in the project files, working with these datasets in R was difficult for me. So I created a local postgresql database, imported the data and used SQL to extract the
data in an easier to use format. The SQL is provided throughout the documentation. The process to build and import the data is not unfortunately.
