exx<-matrix(c(1,2,3,1,1,2,3,3,1,1,1,1),ncol=3)
rownames(exx)<-letters[1:4]
dist(exx,diag = TRUE)


# je vais prendre le e point 2,2,2 et a partir des distance a A, B,C retrouver la distance a c
dist(rbind(exx[4,,drop=FALSE],X=c(2,2,2)),diag=TRUE)
1.732051
dist(rbind(exx[1:3,,drop=FALSE],X=c(2,2,2)),diag = TRUE)
