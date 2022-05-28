class System::Passwd::User {
    has $.username;
    has $.password;
    has $.uid;
    has $.gid;
    has $.fullname;
    has $.home-directory;
    has $.login-shell;

    method new(Str:D $line) {
        my ($username, $password, $uid, $gid,
            $fullname, $home-directory, $login-shell
        ) = $line.split(":");

        self.bless:
          :$username, :$password, :$uid, :$gid,
          :$fullname, :$home-directory, :$login-shell
    }
}

my @users;

my Bool $loaded-users = False;

my sub users() {
    if $loaded-users {
        @users
    }
    else {
        my $user-class;

        given $*DISTRO.Str | $*KERNEL.Str {
            when rx:i/linux/   { $user-class = System::Passwd::User }
            when rx:i/openbsd/ { $user-class = System::Passwd::User }
            when rx:i/netbsd/  { $user-class = System::Passwd::User }
            when rx:i/freebsd/ { $user-class = System::Passwd::User }
            when rx:i/macos/   { $user-class = System::Passwd::User }
            default {
                die "This module is not compatible with the operating system $*DISTRO.Str()"
            }
        }

        $loaded-users = True;
        @users = '/etc/passwd'.IO.lines
          .map: { $user-class.new($_) if !.starts-with('#') }

    }
}

sub get-user-by-username(Str:D $username) is export {
    users.first: { .username eq $username }
}

sub get-user-by-uid(Int:D $uid) is export {
    users.first: { .uid == $uid }
}

sub get-user-by-fullname (Str:D $fullname) is export {
    users.first: { .fullname eq $fullname }
}

=begin pod

=head1 NAME

System::Passwd - easily search for system users on Unix based systems

=head2 DESCRIPTION

L<System::Passwd> is a Raku distribution for searching the C</etc/passwd>
file. It provides subroutines to search for a C<System::Passwd::User>
user by uid, username or full name.  C<System::Passwd> should work on
Linux, Unix, FreeBSD, NetBSD, OpenBSD and MacOS (although not all MacOS
users are stored in C</etc/passwd>).

=head2 SYNOPSIS

=begin code :lang<raku>

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

=end code

=head2 AUTHOR

David Farrell

=head1 COPYRIGHT AND LICENSE

Copyright 2014 David Farrell

Copyright 2015 - 2022 Raku Community

This library is free software; you can redistribute it and/or modify it under the FreeBSD license.

=end pod

# vim: expandtab shiftwidth=4
