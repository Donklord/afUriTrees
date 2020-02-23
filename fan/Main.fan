class Hello
{
  static Void main() { 
	myTree := RouteTree()
	myTree.set(`/*`, "test")
	myTree.set(`/foo/*`, "test2")
	myTree.set(`/foo2/*/edit/*`, "test3")

	echo(myTree.get(`/foo2/wildCard/edit/12`).handler)
  }
}
