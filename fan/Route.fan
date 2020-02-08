
class Route {   //TODO Tie in all of the missing items from these
	Uri    requestUrl         // the original HTTP Request URL
    Uri    definedUrl         // what was passed to UrlTreeMap.add()
    Uri?   canonicalUrl        // TODO the URL we should re-direct to (if at all)
    Obj    handler            // the handler
    Str[]  wildcardSegments   // path segments that * should be replaced with
   // Str[]  remainingSegments // TODO remaining segments that ** or *** match to (I'm a bit fuzzy on if this is needed)
	
	new make(Uri requestUrl, Uri definedUrl, Uri? canonicalUrl, Obj handler, Str[] wildcardSegments) {  //Uri requestUrl, Uri definedUrl, Uri? canonicalUrl, Obj handler, Str[] wildcardSegments, Str[] remainingSegments
		this.requestUrl = requestUrl
		this.definedUrl = definedUrl
		this.canonicalUrl = canonicalUrl
		this.handler = handler
		this.wildcardSegments = wildcardSegments
		//this.remainingSegments = remainingSegments
	}
}
