class Hello
{
  static Void main() { 
  	RouteTree myTree := RouteTree()
		
	myTree.add(`/foo`, "test")
	myTree.add(`/foo2`, "test2")
	myTree.add(`/foo3`, "test3")
	myTree.add(`/foo4`, "test4")
	myTree.add(`/*`, "anotherWildCardTest")
	myTree.add(`/foo/bar`, "test5")
	myTree.add(`/foo/*`, "wildCardTest")
	myTree.add(`/foo2/bar2`, "test6")
	//echo(myTree.listAbsoluteMaps)
	//echo(myTree.listRouteTreeMaps)
	echo(myTree.get(`/*`).handler) //.handler
  }
}
