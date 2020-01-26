
class TestUriTrees : Test {

	// Test Basic Functionality
	//   1 - Create myTree
	//   2 - Create a basic tree structure; `/foo`, `/foo/bar`
	//   3 - Verify get for both tree structures
	Void testBasic() {
		myTree := RouteTree()
		
		myTree.add(`/foo`, "test")
		myTree.add(`/foo2/bar`, "test2")
		
		verifyEq(myTree.get(`/foo`		).handler, "test")
		verifyEq(myTree.get(`/foo2/bar`	).handler, "test2")
	}
	
	// Test wildcard functionality
	//	 1 - Create myTree
	//   2 - Create a basic tree structure; `/*`, `/foo/*`
	//   3 - Verify get for both tree structures
	//   4 - Verify wildcard return
	Void testWildcard() {
		myTree := RouteTree()
		myTree.add(`/*`, "test")
		myTree.add(`/foo/*`, "test2")
		myTree.add(`/foo2/*/edit/*`, "test3")
		
		verifyEq(myTree.get(`/wildCard`).handler, 			"test")
		verifyEq(myTree.get(`/wildCard`).wildcardSegments,	["wildCard"])

		verifyEq(myTree.get(`/foo/wildCard`).handler,			"test2")
		verifyEq(myTree.get(`/foo/wildCard`).wildcardSegments,	["wildCard"])
		
		verifyEq(myTree.get(`/foo2/wildCard/edit/12`).handler,			"test3")
		verifyEq(myTree.get(`/foo2/wildCard/edit/12`).wildcardSegments,	["wildCard", "12"])
	}
	
	// Test map preferences; absoluteMap > routeTreeMap
	//   1 - Create myTree
	//   2 - Create tree structure; `/foo`, `/foo/bar`
	Void testMapPrefrences() {
		myTree := RouteTree()
		myTree.add(`/foo`, "test")
		myTree.add(`/foo/bar`, "test2")
		
		verifyEq(myTree.get(`/foo`).handler, "test")
	}
	
	// Test explicit preferences; explicit path > wildcard path
	Void testExplicitPreferences() {
		myTree := RouteTree()
		myTree.add(`/foo`, "test")
		myTree.add(`/*`, "test2")
		
		verifyEq(myTree.get(`/foo`).handler, "test")
	}
}