# foreman_data_binding

Data binding terminus for Puppet 3+ that uses Foreman's smart class parameters
feature to resolve class parameters.  Drop-in replacement for Hiera.

Requires the [foreman_param_lookup](https://github.com/domcleal/foreman_param_lookup)
plugin to be installed on your Foreman server.

## Why would you do this?

In a Foreman 1.1 setup, classes are added to a host or hostgroup and Foreman
provides the list of classes and their parameters to Puppet through the ENC.
However, if those classes then include others, the data has to be provided by
the first set of classes - which can make for lots of duplication of parameter
lists.

Puppet 3 adds data binding support with Hiera, so if a class is included, it
uses the data binding implementation to look up all of the parameters, e.g.

    # this gets added to the host in Foreman
    class role::webserver {
      include httpd
    }

    class httpd($document_root, $user, $group) {
      # ...
    }

Puppet 3 will look up `httpd::document_root`, `httpd::user` and `httpd::group`
automatically, without us needing to supply them in the role class.

When classes are imported in Foreman, you can create flexible matcher rules
that allow a hierarchy of lookups to resolve class parameters.

# Installation:

First install the [foreman_param_lookup](https://github.com/domcleal/foreman_param_lookup)
plugin on your Foreman server.

On your puppetmaster, install this module:

    puppet module install domcleal/foreman_data_binding

or copy this directory to your modulepath.

Edit `lib/puppet/indirector/foreman.rb` and set the `$foreman_url` value, e.g. to
`http://foreman/`.

In your puppetmaster's `/etc/puppet/puppet.conf`, set:

    [master]
    data_binding_terminus = foreman

Restart the puppetmaster.

# Usage

In Foreman, under Puppet Classes, ensure your classes have been imported.

Select a class, choose a parameter from the left hand list and edit the
hierarchy and matchers.  More info:

* [Foreman wiki and screencast](http://projects.theforeman.org/projects/foreman/wiki/Parameterized_class_support)
* [Foreman 1.1 manual](http://theforeman.org/manuals/1.1/index.html#4.2.5ParameterizedClasses)

# Copyright

Copyright (c) 2013 Red Hat Inc.  See LICENSE.
