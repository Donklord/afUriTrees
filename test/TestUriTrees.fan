class TestUriTrees : Test {

	// Test Basic Functionality
	//   1 - Create myTree
	//   2 - Create a basic tree structure; `/foo`, `/foo/bar`
	//   3 - Verify get for both tree structures
	Void testBasic() {
		
		RouteTree myTree := RouteTree()
		
		myTree.add(`/foo`, "test")
		myTree.add(`/foo2/bar`, "test2")
		
		//Get `/foo`, verify that the handler equals "test"
		verifyEq(myTree.get(`/foo`).handler, "test")
		
		//Get `/foo2/bar`, verify that the handler equals "test2"
		verifyEq(myTree.get(`/foo2/bar`).handler, "test2")
	}
	
	// Test wildcard functionality
	//	 1 - Create myTree
	//   2 - Create a basic tree structure; `/*`, `/foo/*`
	//   3 - Verify get for both tree structures
	//   4 - Verify wildcard return
	Void testWildcard() {
		
		RouteTree myTree := RouteTree()
		
		myTree.add(`/*`, "test")
		myTree.add(`/foo/*`, "test2")
		myTree.add(`/foo2/*/edit/*`, "test3")
		
		//Get `/*`, verify that the handler equals "test"
		verifyEq(myTree.get(`/wildCard`).handler, "test")
		
		//Get `/foo/wildcard`, verify that it quals "test2"
		verifyEq(myTree.get(`/foo/wildCard`).handler, "test2")
		
		//Get wildcard return from `/*`, verify that it equals ["wildCard"]
		verifyEq(myTree.get(`/wildCard`).wildcardSegments, ["wildCard"])
		
		//Get wildcard return from `/foo/*`, verify that it equals ["wildCard"]
		verifyEq(myTree.get(`/foo/wildCard`).wildcardSegments, ["wildCard"])
		
		//Get `/foo/wildCard/edit/12`, verify that it equals "test3"
		verifyEq(myTree.get(`/foo2/wildCard/edit/12`).handler, "test3")
		
		//Get wildcard return from `/foo/*`, verify that it equals ["wildCard"]
		verifyEq(myTree.get(`/foo2/wildCard/edit/12`).wildcardSegments, ["wildCard", "12"])
	}
	
	// Test map preferences; absoluteMap > routeTreeMap
	//   1 - Create myTree
	//   2 - Create tree structure; `/foo`, `/foo/bar`
	Void testMapPrefrences() {
		RouteTree myTree := RouteTree()
		
		myTree.add(`/foo`, "test")
		myTree.add(`/foo/bar`, "test2")
		
		//Get `/foo`, verify that the handler equals "test"
		verifyEq(myTree.get(`/foo`).handler, "test")
	}
	
	// Test explicit preferences; explicit path > wildcard path
	Void testExplicitPreferences() {
		RouteTree myTree := RouteTree()
		
		myTree.add(`/foo`, "test")
		myTree.add(`/*`, "test2")
		
		//Get `/foo`, verify that the handler equals "test"
		verifyEq(myTree.get(`/foo`).handler, "test")
		
	}
}