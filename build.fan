using build

class Build : BuildPod {

	new make() {
		podName = "afUriTrees"
		summary = "My Awesome afUriTrees Project"
		version = Version("1.0")

		meta = [
			"proj.name" : "afUriTrees"
		]

		depends = [
			"sys 1.0"
		]

		srcDirs = [`fan/`]
		resDirs = [,]

		docApi = true
		docSrc = true
	}
}
