set.seed(1234)

# create some data
nFeature = 3
dataSet <- matrix(rnorm(3 * nFeature), ncol = nFeature)
query <- matrix(rnorm(1 * nFeature), ncol = nFeature)

# parameter for distance calculations
K = 10  # number of nearest neighbors


rowDistWithoutApply <- function(ref, target, k) {
  dists = colSums((t(ref) - target[1, ])^2)
  iNN = order(dists)[1:k]
  return(list(knnIndexDist = matrix(c(iNN, dists[iNN]), nrow = 1), k = k))
}
rowDistWithoutApply(ref = dataSet, target = query, k = 2)












library(yaImpute)

ann_dist <- function(ref, target, k) {
  res <- ann(ref = ref, target = target, tree.type = "kd", k = k, verbose = FALSE)
  return(res)
}
resANN <- ann_dist(ref = dataSet, target = query, k = K)

library(pdist)

pdist_wrapper <- function(ref, target, k) {
  distAll <- pdist(X = ref, Y = target)
  iNN <- order(distAll)[1:k]
  return(list(knnIndexDist = matrix(c(iNN, distAll[iNN]^2), nrow = 1), k = k))
  # similar to ann the element knnIndexDist from the list is a vector which
  # contains the indices of the nearest neighbors on position 1 to k and all
  # distances afterwards (position k+1 to 2k)
}
resPDIST <- pdist_wrapper(ref = dataSet, target = query, k = K)


rowDist <- function(ref, target, k) {
  distAll <- colSums(apply(ref, 1, "-", target)^2)
  iNN <- order(distAll)[1:k]
  return(list(knnIndexDist = matrix(c(iNN, distAll[iNN]), nrow = 1), k = k))
}
resRowDist <- rowDist(ref = dataSet, target = query, k = K)

colDist <- function(ref, target, k) {
  distAll <- rowSums(sapply(1:ncol(target), function(i) {
    (ref[, i] - target[, i])^2
  }))
  iNN <- order(distAll)[1:k]
  return(list(knnIndexDist = matrix(c(iNN, distAll[iNN]), nrow = 1), k = k))
}
resColDist <- colDist(ref = dataSet, target = query, k = K)

rowDistWithoutApply <- function(ref, target, k) {
  dists = colSums((t(ref) - target[1, ])^2)
  iNN = order(dists)[1:k]
  return(list(knnIndexDist = matrix(c(iNN, dists[iNN]), nrow = 1), k = k))
}
resRowDistWA <- rowDistWithoutApply(ref = dataSet, target = query, k = K)



matrix(cbind(A = t(resANN$knnIndexDist),
             t(resRowDist$knnIndexDist),
             t(resColDist$knnIndexDist),
             t(resRowDistWA$knnIndexDist)),
       ncol = 4, dimnames = list(NULL,
                                 c("ann", "rowDist", "colDist", "rowDistWithoutApply")))

iterN <- 2000L
matrix(cbind(system.time(for (i in 1:iterN) {
  ann_dist(ref = dataSet, target = query, k = 50)
})[1:3], system.time(for (i in 1:iterN) {
  pdist_wrapper(ref = dataSet, target = query, k = 50)
})[1:3], system.time(for (i in 1:iterN) {
  rowDist(ref = dataSet, target = query, k = 50)
})[1:3], system.time(for (i in 1:iterN) {
  colDist(ref = dataSet, target = query, k = 50)
})[1:3], system.time(for (i in 1:iterN) {
  rowDistWithoutApply(ref = dataSet, target = query, k = 50)
})[1:3]), ncol = 5, dimnames = list(c("user", "system", "elapsed"), c("ann",
                                                                      "pdist", "rowDist", "colDist", "rowDistWithoutApply")))

library(microbenchmark)
res <- microbenchmark(ann = ann_dist(ref = dataSet, target = query, k = 50),
                      # pdist = pdist_wrapper(ref = dataSet, target = query, k = 50),
                      rowDist = rowDist(ref = dataSet, target = query, k = 50),
                      colDist = colDist(ref = dataSet, target = query, k = 50),
                      rowDistWithoutApply = rowDistWithoutApply(ref = dataSet, target = query, k = 50),
                      times = 2000L)
print(res)

library(ggplot2)
plt <- qplot(y = time, data = res, colour = expr)
plt <- plt + scale_y_log10()
print(plt)
