
class RouteTree {
	private Map[] absoluteMap := [,]  //Map keys {urlKey: Uri, handler: str}
	private Map[] routeTreeMap := [,] //Map keys {urlKey: Uri, handler: str}
	private RouteTree? childRouteTree := null
	
	
	This add(Uri url, Obj handler) {
        Str routeStr := url.pathStr
		Int routeDepth := routeStr.split('/').findAll |Str v-> Bool| { return v!=""  }.size
		
		if (routeDepth == 1)
		{	
			absoluteMap.add(["uriKey":url, "handler":handler])
		}
		else
		{			
			if (childRouteTree == null)
			{
				childRouteTree = RouteTree()
			}
			routeTreeMap.add(["uriKey":url.getRange(0..0), "handler":childRouteTree])
			childRouteTree = childRouteTree.add(url.getRange(1..-1), handler)
			//echo(childRouteTree.listAbsoluteMaps)
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
		Bool matchFound := false
		Uri curLvlUri := url.getRange(0..0)
		Route? newMatch
		Bool containsAbsoluteWildCard := false
		Uri wildcardUriKey := ``
		Str[] splitUrl := url.pathStr.split('/')
		Str[] wildcardList := [,]
		
        //Run through absoluteMaps
		// If match found, return UrlMatch
		absoluteMap.each |map|
		{
			
			if (map["uriKey"] == curLvlUri && map["uriKey"] != `/*`)
			{
				echo("normal")
				matchFound = true
				newMatch = Route(url, map["uriKey"], map["handler"], [,])  //TODO tie in wildcard
			}
			if (map["uriKey"] == `/*`)
			{
				containsAbsoluteWildCard = true
				wildcardUriKey = map["uriKey"]
			}
		}
		
		
		if (containsAbsoluteWildCard) {
			Int index := 0
			wildcardUriKey.pathStr.split('/').each |key|
			{
				if (key == "*" && key != "") {
					wildcardList.add(splitUrl.get(index))
				}
				index++
			}
			echo(wildcardList)
		}
		else if (newMatch != null)
		{
			return newMatch
		}
		
		
		
		//If no matches found, run through routeTreeMaps
		// If match found, pass request to new get
		
		//If no matches found, null
		
		return null
    }
}
