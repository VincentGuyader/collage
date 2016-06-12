exx<-matrix(c(1,2,3,1,1,2,3,3,1,1,1,1),ncol=3)
rownames(exx)<-letters[1:4]
dist(exx,diag = TRUE)


# je vais prendre le e point 2,2,2 et a partir des distance a A, B,C retrouver la distance a c
dist(rbind(exx[4,,drop=FALSE],X=c(2,2,2)),diag=TRUE)
1.732051
dist(rbind(exx[1:3,,drop=FALSE],X=c(2,2,2)),diag = TRUE)


# " fait en 2 D

exx<-matrix(c(1,2,3,1),ncol=2)
rownames(exx)<-letters[1:2]
dist(exx,diag = TRUE)
exx

# si je calcule la distance de C (1,1) par rapport a A et B , alors j'aurai aussi sa distance par rapport à D
dist(rbind(exx,c=c(1,1)),diag = TRUE)
dist(rbind(exx,d=c(3,3)),diag = TRUE)
dist(rbind(c=c(1,1),d=c(3,3)),diag = TRUE)

sqrt(sum((x_i - y_i)^2))

sqrt((1-3)**2+(1-3)**2)

AD = 2
AC =2
CB =1
BD = 2.32
AB= 2.23

combien vaut CD ?? 2.82

AD = sqrt( (xD- xA)**2 + (yD-yA)**2)
AC = sqrt( (xC- xA)**2 + (yC-yA)**2)
BC = sqrt( (xC- xB)**2 + (yC-yB)**2)
BD = sqrt( (xD- xB)**2 + (yD-yB)**2)
BA = sqrt( (xD- xB)**2 + (yA-yB)**2)

CD = sqrt( (xD- xC)**2 + (yD-yC)**2)
