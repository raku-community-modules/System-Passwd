[![Actions Status](https://github.com/raku-community-modules/System-Passwd/actions/workflows/test.yml/badge.svg)](https://github.com/raku-community-modules/System-Passwd/actions)

NAME
====

System::Passwd - easily search for system users on Unix based systems

DESCRIPTION
-----------

[System::Passwd](System::Passwd) is a Raku distribution for searching the `/etc/passwd` file. It provides subroutines to search for a `System::Passwd::User` user by uid, username or full name. `System::Passwd` should work on Linux, Unix, FreeBSD, NetBSD, OpenBSD and MacOS (although not all MacOS users are stored in `/etc/passwd`).

SYNOPSIS
--------

```raku
use System::Passwd;

my $root-user = get-user-by-uid(0);

say $root-user.username;
say $root-user.uid;
say $root-user.gid;
say $root-user.fullname;
say $root-user.login-shell;
say $root-user.home-directory;
say $root-user.password;         # This won't be a useful value on most systems

# can search for users other methods
my $user = get-user-by-username('sillymoose');

# or:
my $user = get-user-by-fullname('David Farrell');
```

AUTHOR
------

David Farrell

COPYRIGHT AND LICENSE
=====================

Copyright 2014 David Farrell

Copyright 2015 - 2022 Raku Community

This library is free software; you can redistribute it and/or modify it under the FreeBSD license.

