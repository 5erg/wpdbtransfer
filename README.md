wpdbtransfer
============

### Summary
A perl script to facilitate Wordpress database transfers when the domain name changes.

### Detailed
When a Wordpress site is moved to a new domain, there are various places where the old domain needs to be replaced with the new domain. This is a simple search-and-replace except when serialized data is affected. This script is a safe way to do a search and replace to update the domain, and also ensure that any serialized data is updated as well.

### Notes:
This is a perl script and must be run from the terminal.

It is written and tested on OS X.

The search and replace is dumb: it will blindly search for what you supply, and replace what you supply.

The search and replace is optional, so this script can be use to fix borked serialized data.

The script will optionally gzip the fixed file to aid in speedy uploads

### Tips
When you are moving from one domain to another, I suggest that you include the http:// part and NOT a trailing /  So this is how I recommend you do it:
  http://old-domain.com
to
  http://new-domain.com
  
### Usage
```
USAGE:
wpdbtransfer

Updates a text dump of a wordpress database with a new URL, preserving and
fixing the serialized data as it goes. The originally supplied file will be
untouched and the new file created with ".fixed" as a suffix.

Takes:
	--file=<name of database file>
	--from=<URL to search for> (optional)
	--to=<URL to replace with> (optional)

	--strip_db_create  remove the database CREATE and USE lines (optional)

	--gzip  compress the fixed file for speedy uploads (optional)

Note: if either of 
	--to
 or 
	--from
 are supplied, they both must be.
```
