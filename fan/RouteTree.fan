
class RouteTree {

	private Str:Obj			handlerMap	:= Str:Obj[:]		// <-- replace absoluteMap with this
	private Str:RouteTree	nestedMap	:= Str:RouteTree[:]	// <-- replace routeTreeMap with this
	
	private [Str:Obj][]	absoluteMap		:= [Str:Obj][,]		//Map keys {urlKey: Uri, handler: obj}
	private [Str:Obj][]	routeTreeMap	:= [Str:Obj][,]		//Map keys {urlKey: Uri, handler: obj}
	
	private RouteTree?	childRouteTree	:= null				// <-- can this be killed? Wot is it?
	
	
	// TODO Throw error if a route already exists
	This add(Uri url, Obj handler) {
		if (url.pathStr.contains("//"))	throw ArgErr("That's nasty! $url")	// <-- let's not entertain dodgy URLs
		
		childRouteTree = null
        routeStr	:= url.pathStr
		//routeDepth:= routeStr.split('/').findAll |Str v-> Bool| { return v!=""  }.size
		routeDepth	:= url.path.size	// <-- use this instead
		
		if (routeDepth == 1) {	
			absoluteMap.add(["uriKey":url, "handler":handler])

		} else {			
//			curLvlUri := Uri.fromStr("/" + url.toStr.split('/').findAll |Str v-> Bool| { return v!=""  }[0])
			curLvlUri := url.path[0]	// <-- use this instead
			
			routeTreeMap.each |treeRow| {
				if (treeRow["uriKey"] == curLvlUri) {
					childRouteTree = treeRow["handler"]
				}
			}

			if (childRouteTree == null) {
				childRouteTree = RouteTree()
				routeTreeMap.add(["uriKey":Uri.fromStr("/" + url.toStr.split('/').findAll |Str v-> Bool| { return v!=""  }[0]), "handler":childRouteTree])
			}
			childRouteTree.add(Uri.fromStr("/" + url.getRange(1..-1).toStr), handler)
		}
		
        return this
    }
	
	// See if the child has a tree
	// FIXME Debug function only, should this be removed in the final version?
	Bool hasChild() { return childRouteTree != null }
	
	// List out all absoluteMaps
	// FIXME Debug function only, should this be removed in the final version?
	Map[] listAbsoluteMaps() { return absoluteMap }
	
	// List out all absoluteMaps
	// FIXME Debug function only, should this be removed in the final version?
	Map[] listRouteTreeMaps() { return routeTreeMap }
	
    @Operator
    Route? get(Uri url) {
		containsWildCard := false	// <-- no need to define the Bool type.
		Bool matchFound := false
		Uri definedMatchUri := ``
		Obj? matchHandler := null
		Obj? wildCardHandler := null
		Uri curLvlUri := Uri.fromStr("/" + url.toStr.split('/').findAll |Str v-> Bool| { return v!=""  }[0])
		Route? newMatch
		Int routeDepth := url.pathStr.split('/').findAll |Str v-> Bool| { return v!=""  }.size

		if (routeDepth == 1) {
			absoluteMap.each |map| {
				if (map["uriKey"] == curLvlUri) {
					matchFound = true
					newMatch = Route(url, map["uriKey"], map["handler"], [,])
				}
				
				if (map["uriKey"] == `/*`) {		// <-- use / check against str "*" as the key  
					containsWildCard	= true
					definedMatchUri		= map["uriKey"]
					matchHandler		= map["handler"]
				}
			}

			if (matchFound) {
				return newMatch
			} else
			
			if (containsWildCard) {	
				return Route(url, definedMatchUri, matchHandler, curLvlUri.path)
			}
		} else
		
		if (routeDepth > 1) {
			routeTreeMap.each |map| {
				if (map["uriKey"] == curLvlUri) {
					matchFound = true
					matchHandler = map["handler"]
				}
				
				if (map["uriKey"] == `/*`) {
					containsWildCard = true
					wildCardHandler = map["handler"]
				}
			}

			if (matchFound) {
				//echo(Uri.fromStr("/" + url.getRange(1..-1).toStr))
				return (matchHandler as RouteTree).get(Uri.fromStr("/" + url.getRange(1..-1).toStr))
			} else
			
			if (containsWildCard) {
				newMatch = (wildCardHandler as RouteTree).get(Uri.fromStr("/" + url.getRange(1..-1).toStr))
				newMatch.wildcardSegments = newMatch.wildcardSegments.rw.insert(0, curLvlUri.path[0])
				return newMatch
			}
			
			else {
				// <-- what happens here?
			}
		}
		
		return null
    }
}