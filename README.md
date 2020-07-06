# octograb - by evait security GmbH

This tool allows you to match the http responses from an input list and a given path against a specific string.

## usecase: bug bounty low hanging fruits
You have a list of domains, subdomains or ip adresses (`domains.txt`) with 200 entries. Now you want to check if any of the target domains contains an open git repo on the web-root filesystem e.g. `www.example.com/.git/`. The following command will do the task for all entries in `domains.txt`:

```
octograb.rb -f domains.txt -p /.git/HEAD -c 'ref:'
```

The `-c` paramter contains a string that will matched against the http response. The corresponding http request is a combination of any entry in the `domains.txt` and the optional `-p` parameter (path).

If the given string from the `-c` parameter matches against an http response you will get an output like this:

```
[+] Content match: www.example.com/.git/HEAD
```

All requests will be threaded by default (50 threads). You can justify this behavior with the `-t` parameter.

## current ToDo

- output file parameter
- input match file (URL:MATCH) to define multiple urls to check
- add `--data` option for post commands
- add `--header` in order to add custom headers

## FAQ

Why it's written in ruby?
- why not?!

Why not using Go lang?
- Maybe we will migrate to go later. PR welcome!

Why so salty on github issue discussion?
- This is a community project. We are a full time pentesting company and will not go into / care about every open issue that doesn't match our template or guidelines. If you get a rough answer or picture e.g. from a fully underwhelmed cat, you probably deserved it.