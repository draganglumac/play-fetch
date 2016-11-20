# play-fetch
Simple Sinatra web server which allows the user to upload a piece of static content to a URL via a PUT request and retrieve it with a GET request.

URL does not neet to be preexisting, it will dynamically add it on the fly.

Server supports ETag which is a SHA-1 hash of the static content at a URL, as well as conditional retrieval via ETag.
