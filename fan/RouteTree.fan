class RouteTree {

	private Str:Obj			handlerMap	:= Str:Obj[:]
	private Str:RouteTree	nestedMap	:= Str:RouteTree[:]
	
	
	@Operator
	This set(Uri url, Obj handler) {
		if (url.pathStr.contains("//"))	throw ArgErr("That's nasty! $url")

		childRouteTree := (RouteTree?) null
        routeStr	:= url.pathStr
		routeDepth	:= url.path.size
		workingUri := url.path[0].lower

		if (routeDepth == 1) {
			handlerMap[workingUri.toStr] = handler
		} else {

			// --> FAN use Map.getOrAdd(...)
			childRouteTree = nestedMap[workingUri.toStr]

			if (childRouteTree == null) {
				childRouteTree = RouteTree()
				nestedMap[workingUri.toStr] = childRouteTree
			}
			childRouteTree[url[1..-1]] = handler
		}
        return this
    }

	// List out all absoluteMaps
	Str:RouteTree getHandlerMap() { return handlerMap }

	// List out all absoluteMaps
	Str:RouteTree getNestedMap() { return nestedMap }

    @Operator
    Route? get(Uri url) {
		matchHandler := (RouteTree?) null
		workingUri := url.path[0].lower
		newMatch := null
		routeDepth	:= url.path.size
		if (routeDepth == 1) {

			newMatch = handlerMap[workingUri]

			if (newMatch != null) {
				return Route(url, workingUri.toUri, `/` + workingUri.toUri,newMatch, Str[,], Str[,])
			}

			newMatch = handlerMap["**"]

			if (newMatch != null) {
				return Route(url, `**`, `/` + workingUri.lower.toUri, newMatch, [url.path[0]], [url.path[0]])
			}

			newMatch = handlerMap["*"]

			if (newMatch != null) {
				return Route(url, `*`, `/` + workingUri.toUri, newMatch, Uri.fromStr(url.path[0]).path, Str[,])
			}
		} else if (routeDepth > 1) {
			matchHandler = nestedMap[workingUri]
			if (matchHandler != null) {
				newMatch = matchHandler[url[1..-1]]
				
				// --> TODO no need for (as Route)  --> PB: Because newMatch is used for a number of different var types in this method, i need to add as Route so fantom knows its a route type  Otherwise this will error out, having issues with Obj
				if (newMatch != null) {
					
					if (!(newMatch as Route).canonicalUrl.isPathAbs) {
						(newMatch as Route).canonicalUrl = Uri.fromStr("/" + workingUri + "/" + (newMatch as Route).canonicalUrl.toStr)
					} else {
						(newMatch as Route).canonicalUrl = Uri.fromStr("/" + workingUri + (newMatch as Route).canonicalUrl.toStr)
					}
					(newMatch as Route).requestUrl = url
					
				}
				return newMatch
			}

			newMatch = handlerMap["**"]

			if (newMatch != null) {
				Str[] wildCardList := url.path
				return Route(url, `**`, Uri.fromStr(url.toStr.lower), newMatch, wildCardList, wildCardList)
			}

			matchHandler = nestedMap["*"]

			if (matchHandler != null) {
				newMatch = matchHandler.get(Uri.fromStr("/" + url.getRange(1..-1).toStr))

				// --> no need for (as Route)   --> PB, see line 72 comment above.
				// --> TODO Uri.fromStr(url.path[0]).path[0] ???/  PB: Uri.fromstr(url.path[0]) returns back as a list.  I have to pull that out, so i can insert it to the begining of a new list.
				// --> TODO good idea, let's keep the .rw. but now lets make the initial Lists immutable via Str#.emptyList  PB: you may have to explain "Str#.emptyList" to be, ive never seen that syntax before.
				(newMatch as Route).wildcardSegments = (newMatch as Route).wildcardSegments.rw.insert(0, Uri.fromStr(url.path[0]).path[0])
				// --> no need for (as Route)   --> PB, see line 72 comment above.
				(newMatch as Route).canonicalUrl = Uri.fromStr("/" + workingUri + (newMatch as Route).canonicalUrl.toStr)
				(newMatch as Route).requestUrl = url
				return newMatch
			}
		}

		return null
    }
}
