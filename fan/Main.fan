
class Hello
{
  static Void main() { 
  	RouteTree myTree := RouteTree()
		
	myTree.add(`/foo/`, "test")
	myTree.add(`/foo2/`, "test2")
	myTree.add(`/foo3/`, "test3")
	myTree.add(`/foo4/`, "test4")
	echo(myTree.listAbsoluteMaps)
  }
}