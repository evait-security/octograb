# octograb - by evait security GmbH

This tool allows you to match the HTTP responses from an input list and a given path against a specific string.

## Use Case: bug bounty low hanging fruits

You have a list of domains, subdomains or IP addresses (`domains.txt`) with 200 entries.
Now you want to check if any of the target domains contains an open git repo on the web-root file system,
e.g. `www.example.com/.git/`. The following command will do the task for all entries in `domains.txt`:

```bash
octograb -f domains.txt -p '/.git/HEAD' -c 'ref:'
```

The `-c` parameter contains a string that will matched against the HTTP response.
The corresponding HTTP request is a combination of any entry in the `domains.txt` and the optional `-p` parameter (path).

If the given string from the `-c` parameter matches against an HTTP response you will get an output like this:

```
[+] Content match: www.example.com/.git/HEAD
```

All requests will be threaded by default (50 threads). You can adjust this behavior with the `-t` parameter.

## Installation

Installing from source (make sure your gem path / env is set properly for this):

```bash
gem build octograb.gemspec
gem install ./octograb-1.0.0.gem
```

Alternatively, you can run it directly from source:

```bash
bundle config --local path 'vendor/bundle'
bundle install
bundle exec octograb
```

## Current ToDo

- output file parameter
- input match file (URL:MATCH) to define multiple URLs to check
- add `--data` option for post commands
- add `--header` in order to add custom headers

## FAQ

Why is it written in ruby?
- why not?!

Why not using Go lang?
- Maybe we will migrate to go later. PR welcome!

Why so salty on github issue discussion?
- This is a community project. We are a full time pentesting company and will not go into / care about every open issue that doesn't match our template or guidelines. If you get a rough answer or picture e.g. from a fully underwhelmed cat, you probably deserved it.
