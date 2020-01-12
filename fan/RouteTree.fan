
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
			//Loop through routeTreeMap to see if a child tree exists
			// If it doesnt, create one
			
			if (childRouteTree == null)
			{
				childRouteTree = RouteTree()
			}
			
			//TODO Split out first / base url
			
			childRouteTree = childRouteTree.add(url, handler)
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
	
    // TODO Returns 'null' if no match.
  //  @Operator
  //  UrlMatch? get(Uri url) {
  //      ...
  //  }
}
