class Route {
	Uri    requestUrl
    Uri    definedUrl
    Uri?   canonicalUrl
    Obj    handler
    Str[]  wildcardSegments
    Str[]  remainingSegments
	
	new make(Uri requestUrl, Uri definedUrl, Uri? canonicalUrl, Obj handler, Str[] wildcardSegments, Str[] remainingSegments) {
		this.requestUrl = requestUrl
		this.definedUrl = definedUrl
		this.canonicalUrl = canonicalUrl
		this.handler = handler
		this.wildcardSegments = wildcardSegments
		this.remainingSegments = remainingSegments
	}
}
