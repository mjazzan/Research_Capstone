install.packages("RSNNS")
library("RSNNS")
?jordan
?elman

##################################################
# Example 1
##################################################

data(snnsData)
inputs <- snnsData$eight_016.pat[,inputColumns(snnsData$eight_016.pat)]
outputs <- snnsData$eight_016.pat[,outputColumns(snnsData$eight_016.pat)]

par(mfrow=c(1,2))

modelElman <- elman(inputs, outputs, size=8, learnFuncParams=c(0.1), maxit=1000)
modelElman
modelJordan <- jordan(inputs, outputs, size=8, learnFuncParams=c(0.1), maxit=1000)
modelJordan

plotIterativeError(modelElman)
plotIterativeError(modelJordan)

summary(modelElman)
summary(modelJordan)


##################################################
# Example 2
##################################################

laser <- snnsData$laser_1000.pat
inputs <- laser[, inputColumns(laser)]
targets <- laser[, outputColumns(laser)]
patterns <- splitForTrainingAndTest(inputs, targets, ratio = 0.15)

model <- elman(patterns$inputsTrain, patterns$targetsTrain,
  size = c(8, 8), learnFuncParams = c(0.1), maxit = 500,
  inputsTest = patterns$inputsTest, targetsTest = patterns$targetsTest,
  linOut = FALSE)


plot(inputs, type = "l")
plot(targets[1:100], type = "l")
lines(model$fitted.values[1:100], col = "green")

plotIterativeError(model)
plotRegressionError(patterns$targetsTrain, model$fitted.values)
plotRegressionError(patterns$targetsTest, model$fittedTestValues)
hist(model$fitted.values - patterns$targetsTrain)
