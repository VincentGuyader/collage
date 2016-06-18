# -*- coding: utf-8 -*-

.onAttach <- function(libname, pkgname) {
    # Runs when attached to search() path such as by library() or require()
    if (interactive()) {
        
        pdesc <- packageDescription(pkgname)
        packageStartupMessage("")
        packageStartupMessage(pdesc$Package, " ", pdesc$Version, " par  Vincent Guyader")
        packageStartupMessage("->  Pour bien demmarrer taper : ?tipixel")
        packageStartupMessage("")
    }
}


# enlève les faux positifs du check
globalVariables(c("%do%", "%dopar%", "foreach", "i")) 
