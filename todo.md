# TODO

* Fix searching for doc collections with docs: http://stackoverflow.com/questions/22489433/how-to-fetch-records-with-exactly-specified-has-many-through-records
* Add "powered by" banner into generated docs
* When starting to generate doc or doc collection, upload file to S3 forwarding people to show page
* Add custom main file for doc collection
* Improve doc main file RUBYDOCS.rdoc, RubyDocs logo etc.
* Save sdoc version with generated docs, check whether it's current in a Sidetiq worker and regenerate one per hour or so
* Can I use --urls option when merging, so docs don't actually have to be copied?
* Allow deeplinking: https://github.com/voloko/sdoc/issues/63
* Allow generating docs for any Ruby project from Git URL
* Update to Rails 4.1.0 when released
* Check out .document files, see https://github.com/voloko/sdoc/issues/62#issuecomment-32627868
* search_index.js becomes really big, like > 20MB big
* Add Whenever, robots.txt, Sitemap Generator, generate sitemap with a link for each doc_collection
* Do line numbers work?
* Create different Sidekiq queues, generating doc collections should be more important than uploading them
* Get it on https://www.ruby-lang.org/en/documentation/
