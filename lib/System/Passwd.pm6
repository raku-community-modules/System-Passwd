use System::Passwd::User;

module System::Passwd
{
    my @users = ();

    my Bool $loaded_users = False;

    my sub populate-users() {
        if !$loaded_users {
            my $user_class;
            given $*DISTRO.Str|$*KERNEL.Str
            {
                when rx:i/linux/   { $user_class = System::Passwd::User }
                when rx:i/openbsd/ { $user_class = System::Passwd::User }
                when rx:i/netbsd/  { $user_class = System::Passwd::User }
                when rx:i/freebsd/ { $user_class = System::Passwd::User }
                when rx:i/macosx/  { $user_class = System::Passwd::User }
                default { die "This module is not compatible with the operating system {$*DISTRO.Str}" }
            }

            # build users array
            my $password_file = open '/etc/passwd', :r;

            for $password_file.lines
            {
                next if .substr(0, 1) ~~ '#'; # skip comments
                my $user = $user_class.new($_);
                @users.push($user);
            }
            $loaded_users = True;
        }
    }

    our sub get_user_by_username (Str:D $username) is export is DEPRECATED('get-user-by-username') {
        get-user-by-username($username);
    }

    our sub get-user-by-username (Str:D $username) is export
    {
        populate-users();
        return first { .username ~~ $username }, @users;
    }

    our sub get_user_by_uid (Int:D $uid) is export is DEPRECATED('get-user-by-uid') {
        get-user-by-uid($uid)
    }

    our sub get-user-by-uid (Int:D $uid) is export
    {
        populate-users();
        return first { .uid == $uid }, @users;
    }

    our sub get_user_by_fullname (Str:D $fullname) is export is DEPRECATED('get-user-by-fullname') {
        get-user-by-fullname($fullname)
    }

    our sub get-user-by-fullname (Str:D $fullname) is export
    {
        populate-users();
        return first { .fullname ~~ $fullname }, @users;
    }
}

=begin pod

=head1 NAME

System::Passwd - easily search for system users on Unix based systems

=head2 DESCRIPTION

L<System::Passwd> is a Raku distribution for searching the C</etc/passwd> file. It provides subroutines to search for a System::Passwd::User user by uid, username or full name. System::Passwd should work on Linux, Unix, FreeBSD, NetBSD, OpenBSD and OSX (although not all OSX users are stored in C</etc/passwd>).

=head2 SYNOPSIS

    use System::Passwd;

    my $root_user = get-user-by-uid(0);

    say $root_user.username;
    say $root_user.uid;
    say $root_user.gid;
    say $root_user.fullname;
    say $root_user.login-shell;
    say $root_user.home-directory;
    say $root_user.password;         # This won't be a useful value on most systems

    # can search for users other methods
    my $user = get-user-by-username('sillymoose');

    # or:
    my $user = get-user-by-fullname('David Farrell');

=head2 LICENSE

FreeBSD - see LICENSE

=head2 AUTHOR

David Farrell

=end pod
