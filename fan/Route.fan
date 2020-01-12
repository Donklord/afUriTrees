
class Route {
	Uri    requestUrl         // the original HTTP Request URL
    Uri    definedUrl         // what was passed to UrlTreeMap.add()
    //Uri?   redirectUrl        // TODO the URL we should re-direct to (if at all)
    Obj    handler            // the handler
    Str[]  wildcardSegments   // path segments that * should be replaced with
    //Str[]  remainingSegments // TODO remaining segments that ** or *** match to (I'm a bit fuzzy on if this is needed)
	
	new make(Uri requestUrl, Uri definedUrl, Obj handler, Str[] wildcardSegments) {
		this.requestUrl = requestUrl
		this.definedUrl = definedUrl
		this.handler = handler
		this.wildcardSegments = wildcardSegments
	}
}
