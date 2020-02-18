class RouteTree {

	private Str:Obj			handlerMap	:= Str:Obj[:]
	private Str:RouteTree	nestedMap	:= Str:RouteTree[:]

	// --> let's rename this to set() and add @Operator
	This add(Uri url, Obj handler) {
		if (url.pathStr.contains("//"))	throw ArgErr("That's nasty! $url")

		childRouteTree := (RouteTree?) null
        routeStr	:= url.pathStr
		routeDepth	:= url.path.size
		workingUri := url.path[0].lower

		if (routeDepth == 1) {
			// --> ERR if we overwrite existing?
			// --> FAN use @Operator
			handlerMap = handlerMap.set(workingUri.toStr, handler)
		} else {

			// --> FAN use Map.getOrAdd(...)
			childRouteTree = nestedMap[workingUri.toStr]

			if (childRouteTree == null) {
				childRouteTree = RouteTree()
				// --> ERR if we overwrite existing?
				// --> FAN use @Operator: map[
				nestedMap = nestedMap.set(workingUri.toStr, childRouteTree)
			}
			// --> FAN tree[url[1..-1]] = handler (no need for "/")
			childRouteTree.add(Uri.fromStr(url.getRange(1..-1).toStr), handler)
		}
        return this
    }

	// List out all absoluteMaps
	// FIXME Debug function only, should this be removed in the final version?
	// --> No-one's gonna call it - it'll be an internal class
	Str:RouteTree getHandlerMap() { return handlerMap }

	// List out all absoluteMaps
	// FIXME Debug function only, should this be removed in the final version?
	// --> No-one's gonna call it - it'll be an internal class
	Str:RouteTree getNestedMap() { return nestedMap }

    @Operator
    Route? get(Uri url) {
		// --> FAN perfect! - you can also do: "matchHandler := null as RouteTree"
		matchHandler := (RouteTree?) null
		// --> FAN no need to case to (Str)
		workingUri := (Str) url.path[0].lower
		newMatch := null
		routeDepth	:= url.path.size
		if (routeDepth == 1) {

			// --> sequence of "if" statements is fantastic use of logic precedence

			newMatch = handlerMap[workingUri]

			if (newMatch != null) {
				// --> instead of Uri.fromStr(workingUri) ... try "workingUri.toUri" and `/` + workingUri.toUri
				// --> for type safety I would explicitly use "Str[,]"
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
				// matchHandler[url[1..-1]]
				newMatch = matchHandler.get(Uri.fromStr("/" + url.getRange(1..-1).toStr))
				// --> no need for (as Route)
				(newMatch as Route).canonicalUrl = Uri.fromStr("/" + workingUri + (newMatch as Route).canonicalUrl.toStr)
				return newMatch
			}

			newMatch = handlerMap["**"]

			if (newMatch != null) {
				// --> wildCardList := url.path
				Str[] wildCardList := [""]
				url.path.each |Str p| {
					wildCardList = wildCardList.add(p)
				}

				// --> wots the bug?
				wildCardList = wildCardList.findAll |Str v->Bool| { return v != "" }   //Sorry this is messy, this fixes a really stupid bug.
				return Route(url, `**`, Uri.fromStr(url.toStr.lower), newMatch, wildCardList, wildCardList)
			}

			matchHandler = nestedMap["*"]

			if (matchHandler != null) {
				newMatch = matchHandler.get(Uri.fromStr("/" + url.getRange(1..-1).toStr))

				// --> no need for (as Route)
				// --> Uri.fromStr(url.path[0]).path[0] ???
				// --> good idea, let's keep the .rw. but now lets make the initial Lists immutable via Str#.emptyList
				(newMatch as Route).wildcardSegments = (newMatch as Route).wildcardSegments.rw.insert(0, Uri.fromStr(url.path[0]).path[0])
				// --> no need for (as Route)
				(newMatch as Route).canonicalUrl = Uri.fromStr("/" + workingUri + (newMatch as Route).canonicalUrl.toStr)
				return newMatch
			}
		}

		return null
    }
}
