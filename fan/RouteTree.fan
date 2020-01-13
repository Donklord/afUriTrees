
class RouteTree {
	private Map[] absoluteMap := [,]  //Map keys {urlKey: Uri, handler: str}
	private Map[] routeTreeMap := [,] //Map keys {urlKey: Uri, handler: str}
	private RouteTree? childRouteTree := null
	
	
	// TODO Throw error if a route already exists
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
		Bool containsWildCard := false
		Uri curLvlUri := url.getRange(0..0)  // TODO Rename this variable, gets only our current URI that we are working on.
		Route? newMatch
		
		absoluteMap.each |map|
		{
			if (map["uriKey"] == curLvlUri)
			{
				newMatch = Route(url, map["uriKey"], map["handler"], [,])  //TODO tie in wildcard, do we pass in wildcard from tree to tree as its built?
			}
		}
		
		if (newMatch != null)
		{
			return newMatch
		}
		//Look through absoluateMaps
		// If no match found, see if any wildcard exists
		// If a wildcard exists, return Reoute with updated runningWildcard
		
		return null
    }
}
