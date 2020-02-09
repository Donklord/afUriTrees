class RouteTree {

	private Str:Obj			handlerMap	:= Str:Obj[:]
	private Str:RouteTree	nestedMap	:= Str:RouteTree[:]
	
	This add(Uri url, Obj handler) {
		if (url.pathStr.contains("//"))	throw ArgErr("That's nasty! $url")
		
		childRouteTree := (RouteTree?) null
        routeStr	:= url.pathStr
		routeDepth	:= url.path.size
		workingUri := url.path[0].lower
		
		if (routeDepth == 1) {	
			handlerMap = handlerMap.set(workingUri.toStr, handler)
		} else {	
			
			childRouteTree = nestedMap[workingUri.toStr]

			if (childRouteTree == null) {
				childRouteTree = RouteTree()
				nestedMap = nestedMap.set(workingUri.toStr, childRouteTree)
			}
			childRouteTree.add(Uri.fromStr("/" + url.getRange(1..-1).toStr), handler)
		}
        return this
    }
	
	// List out all absoluteMaps
	// FIXME Debug function only, should this be removed in the final version?
	Str:RouteTree getHandlerMap() { return handlerMap }
	
	// List out all absoluteMaps
	// FIXME Debug function only, should this be removed in the final version?
	Str:RouteTree getNestedMap() { return nestedMap }
	
    @Operator
    Route? get(Uri url) {
		matchHandler := (RouteTree?) null
		workingUri := (Str) url.path[0].lower
		newMatch := null
		routeDepth	:= url.path.size
		if (routeDepth == 1) {
			
			newMatch = handlerMap[workingUri]

			if (newMatch != null) {
				return Route(url, Uri.fromStr(workingUri), Uri.fromStr("/" + workingUri),newMatch, [,], [,])
			} 
			
			newMatch = handlerMap["**"]
			
			if (newMatch != null) {
				return Route(url, `**`, Uri.fromStr(url.toStr.lower), newMatch, [url.path[0]], [url.path[0]])
			}
			
			newMatch = handlerMap["*"]
			
			if (newMatch != null) {
				return Route(url, `*`, Uri.fromStr("/" + workingUri), newMatch, Uri.fromStr(url.path[0]).path, [,])
			}
		} else if (routeDepth > 1) {
			matchHandler = nestedMap[workingUri]
			
			if (matchHandler != null) {
				newMatch = matchHandler.get(Uri.fromStr("/" + url.getRange(1..-1).toStr))
				(newMatch as Route).canonicalUrl = Uri.fromStr("/" + workingUri + (newMatch as Route).canonicalUrl.toStr)
				return newMatch
			} 
			
			newMatch = handlerMap["**"]
			
			if (newMatch != null) {
				Str[] wildCardList := [""]
				url.path.each |Str p| {
					wildCardList = wildCardList.add(p)
				}
				
				wildCardList = wildCardList.findAll |Str v->Bool| { return v != "" }   //Sorry this is messy, this fixes a really stupid bug.
				return Route(url, `**`, Uri.fromStr(url.toStr.lower), newMatch, wildCardList, wildCardList)
			}

			matchHandler = nestedMap["*"]
			
			if (matchHandler != null) {
				newMatch = matchHandler.get(Uri.fromStr("/" + url.getRange(1..-1).toStr))
				(newMatch as Route).wildcardSegments = (newMatch as Route).wildcardSegments.rw.insert(0, Uri.fromStr(url.path[0]).path[0])
				(newMatch as Route).canonicalUrl = Uri.fromStr("/" + workingUri + (newMatch as Route).canonicalUrl.toStr)
				return newMatch
			}
		}   
		
		return null
    }
}
