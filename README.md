# play-fetch
Simple *Sinatra* web server which allows the user to upload a piece of static content to a URL via a `PUT` request, and retrieve it with a `GET` request.

URL does not neet to be preexisting, it gets dynamically added to the running server the first time you upload some content to that URL.

Server supports `ETag` which is a *SHA-1 hash* of the static content at a URL, as well as conditional retrieval via `ETag`.

- To start the server run

```sh
cd <root-of-this-project>
bundle exec ruby run.rb [-p PORT]
```
Let's assume that the server is running on `http://localhost` base URL.

- To send a file called `foobar.json` to http://localhost/foo/bar/foobar.json you can `cURL` the following

```sh
curl -T foobar.json -X PUT http://localhost/foo/bar/foobar.json
```

- To retrieve the resource you've already uploaded use a `GET` request, either simple

```sh
curl http://localhost/foo/bar/foobar.json
# This returns a response with a content and an ETag header which contains <etag-value>
```

or a conditional `GET` with `If-Match` or `If-None-Match` headers using an ETag value you obtain in the `ETag` header of `PUT` and `GET` responses.

```sh
curl -H "If-None-Match: <etag-value>" http://localhost/foo/bar/foobar.json
```
And that's all there is to it.

Enjoy!
