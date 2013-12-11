wpdbtransfer
============

Summary
A perl script to facilitate Wordpress database transfers when the domain name changes.

Detailed
When a Wordpress site is moved to a new domain, there are various places where the old domain needs to be replaced with the new domain. This is a simple search-and-replace except when serialized data is affected. This script is a safe way to do a search and replace to update the domain, and also ensure that any serialized data is updated as well.

This is a perl script and must be run from the terminal.

It is written and tested on OS X.
