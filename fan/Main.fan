class Hello
{
  static Void main() { 
  	RouteTree myTree := RouteTree()
		
	myTree.add(`/foo/*/edit/*`, "test")
	myTree.add(`/foo2`, "test2")
	//echo(myTree.getHandlerMap)
	//echo(myTree.getNestedMap)
	//echo(myTree.get(`FOO2`).handler)
	echo(myTree.get(`/fOo/bar/Edit/12/`).handler)
  }
}
