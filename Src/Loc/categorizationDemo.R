library(RERconverge)

#All of these scripts are used to see the tree with the common names; no other function 
source("Src/Reu/ZonomNameConvertMatrixCommon.R")
source("Src/Reu/ZonomNameConvertVector.R")
source("Src/Reu/categorizePaths.R")
source("Src/Reu/ZoonomTreeNameToCommon.R")
#

#Read in the correlation file, RERs, and Paths produced by the original run RERs step 
allInsectivoryData = read.csv("Results/allInsectivoryCorrelationFile.csv")
RERs = readRDS("Results/allInsectivoryRERFile.rds")
Paths = readRDS("Results/allInsectivoryPathsFile.rds") #Note that this path is uncategorized. 

CNRers = ZonomNameConvertMatrixCommon(RERs) #convert the dataset names to common names

#Read in the binary tree (no paths); this is the correct foreground 
binaryTree = readRDS("Results/allInsectivoryBinaryForegroundTree.rds")
ZoonomTreeNameToCommon(binaryTree) #Plots the binary tree with common names displayed 

#This code loads in the premade tree, with the foreground click-selection I used; see Doc/manualTreeSelectionColored.png for image of click-selection. 
premadeCategoricalTree = readRDS("Results/premadefunctionPathManualFGTree.rds")
premadeCategoricalTreeCN = ZoonomTreeNameToCommon(premadeCategoricalTree, isForegroundTree = F) #Plots the tree with common names displayed 
{ # collapsable code for making branch colors 
category1Edges = which(premadeCategoricalTreeCN$edge.length == 2)
category2Edges = which(premadeCategoricalTreeCN$edge.length == 3)
hlColors = NA
hlColors[1:length(category1Edges)] = "blue"
hlColors[(length(category1Edges)+1):(length(category1Edges)+length(category2Edges))] = "green"
} # collapsed code for making branch colors 
plotTreeHighlightBranches(premadeCategoricalTreeCN, hlspecies = c(category1Edges, category2Edges), hlcols = hlColors)

#Convert the categorical tree to a path
#premadeCategoricalPaths = tree2Paths(readRDS("Results/premadefunctionPathManualFGTree.rds"), zonomMaster) #This has been pre-executed, to remove dependency on the zoonomia dataset file. Result is read in below. 
premadeCategoricalPaths = readRDS("Results/premadeFunctionPaths.rds")
#Plot the RERs 

plotRers(CNRers,"ZNF292", Paths, sortrers = T)
plotRers(CNRers,"ZNF292", premadeCategoricalPaths, sortrers = T) 
#Note incorrect classification, 4th category, yak in foreground

#An example of another gene. Also has errors, though less obvious. 
plotRers(CNRers,"KIAA0825", Paths, sortrers = T) #Using non-categorical Path
plotRers(CNRers,"KIAA0825", premadeCategoricalPaths, sortrers = T) #Using categorical Path 






# --- OPTIONAL: TO GENERATE A NEW CATEGORICAL PATH USING CLICK-SELECT
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
