# Flickr Downloader

Small [Sinatra][] application that lists your flickr photosets (you need to provide your
user id and api key), and lets you download a zipfile with all the photos in each set.

## Why?

Because a lot of friends of mine wanted to mass-download my photos from flickr. And anything
is a good reason to play with Sinatra ;)

## How to use

Just clone the repo, and add a `config/config.yml` (see `config/config.sample.yml` for an
extremely easy example). Then run `ruby flickr-downloader.rb`, and you're done! For an easy 
way to deploy Sinatra apps to production, [cschneid][] has a great blog post about [setting 
up thin with Sinatra][thin-setup].

## Example

Check out [http://photos.nicolassanguinetti.info][example] for a running example of this app.

## Warning

This is mostly a proof-of-concept, which just happens to work perfectly fine for me. 
If your photos are not publicly accesible, or you don't allow anonymous users to download 
the "Original" sized pics from your account, then this might not work.

But hey, it's open source ;)

## License

(The MIT License)

Copyright (c) 2008 [Nicolás Sanguinetti][foca].

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[Sinatra]:    http://sinatrarb.com
[cschneid]:   http://gittr.com
[thin-setup]: http://gittr.com/index.php/archive/deploying-sinatra-via-thin-and-lighttpd/
[foca]:       http://nicolassanguinetti.info
[example]:    http://photos.nicolassanguinetti.info