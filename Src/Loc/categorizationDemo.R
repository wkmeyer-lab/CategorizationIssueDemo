library(RERconverge)
source("Src/Reu/ZonomNameConvertMatrixCommon.R")
source("Src/Reu/ZonomNameConvertVector.R")
source("Src/Reu/categorizePaths.R")

#Read in the correlation file, RERs, and Paths produced by the original run RERs step 
allInsectivoryData = read.csv("Results/allInsectivoryCorrelationFile.csv")
RERs = readRDS("Results/allInsectivoryRERFile.rds")
Paths = readRDS("Results/allInsectivoryPathsFile.rds") #Note that this path is uncategorized. 

CNRers = ZonomNameConvertMatrixCommon(RERs) #convert the dataset names to common names

#Find indexes with "bat" in the species name 
CNNames = CNRers[1,]
names(CNNames)
bats = grep("bat", names(CNNames))


#Read in the binary tree (no paths)
binaryTree = readRDS("Results/allInsectivoryBinaryForegroundTree.rds")
plotTree(binaryTree)

#This code loads in the premade tree, with the manual annotations I used. 
premadeCategoricalTree = readRDS("Results/premadefunctionPathManualFGTree.rds")
plotTree(premadeCategoricalTree)

#Convert the categorical tree to a path
#premadeCategoricalPaths = tree2Paths(readRDS("Results/premadefunctionPathManualFGTree.rds"), zonomMaster) #This has been pre-executed, to remove dependency on the zoonomia dataset file. Result is read in below. 
premadeCategoricalPaths = readRDS("Results/premadeFunctionPaths.rds")

#Plot the RERs 
plotRers(CNRers,"KIAA0825", Paths, sortrers = T)
plotRers(CNRers,"KIAA0825", premadeCategoricalPaths, sortrers = T)


plotRers(CNRers,"ZNF292", Paths, sortrers = T)
plotRers(CNRers,"ZNF292", premadeCategoricalPaths, sortrers = T)

# --- OPTIONAL: TO GENERATE A NEW CATEGORICAL PATH 
#Read in the zoonomia master file. Ensure that this file is stored in the "Data" directory
#It is very large, and thus is not included in the Github! 
zonomMaster = readRDS("Data/RemadeTreesAllZoonomiaSpecies.rds")

#This line runs the manual selection 
#The "categoricalPaths" name can be changed, if a different file wants to be saved. 
#A tree with the manual annotations used is provided below, this code is present to show how it is generated.
#This function saves the *tree* to a file, and returns the path when called
categoricalPaths = categorizePaths(binaryTree, zonomMaster, "categoricalPaths", overwrite = T) 
# ------
plotRers(CNRers,"KIAA0825", categoricalPaths, sortrers = T)
plotRers(CNRers,"ZNF292", categoricalPaths, sortrers = T)
