
class Hello
{
  static Void main() { 
  	RouteTree myTree := RouteTree()
		
	myTree.add(`/foo/*/edit/*`, "test")
	//echo(myTree.listAbsoluteMaps)
	//echo(myTree.listRouteTreeMaps)
	echo(myTree.get(`/foo/bar/edit/12`).wildcardSegments)
  }
}
