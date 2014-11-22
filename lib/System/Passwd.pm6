use System::Passwd::User;

module System::Passwd
{
    die 'This module is only compatible with Linux' if $*DISTRO.Str !~~ m:i/[linux|macosx]/;

    # build users array
    my $password_file = open '/etc/passwd', :r;
    my @users = ();

    for $password_file.lines
    {
        next if .substr(0, 1) ~~ '#'; # skip comments
        my @cols = .split(':');
        my $user = System::Passwd::User.new(
            username    => @cols[0],
            password    => @cols[1],
            uid         => @cols[2],
            gid         => @cols[3],
            fullname    => @cols[4],
            home_dir    => @cols[5],
            login_shell => @cols[6],
        );
        @users.push($user);
    }

    our sub get_user_by_username (Str:D $username) is export
    {
        return first { .username ~~ $username }, @users;
    }

    our sub get_user_by_uid (Int:D $uid) is export
    {
        return first { .uid == $uid }, @users;
    }

    our sub get_user_by_fullname (Str:D $fullname) is export
    {
        return first { .fullname ~~ $fullname }, @users;
    }
}

=begin pod

=head1 NAME

System::Passwd - easily search for Linux system users

=head2 DESCRIPTION

L<System::Passwd> is a Perl 6 distribution for searching the C</etc/passwd> file. It provides subroutines to search for a System::Passwd::User user by uid, username or full name.

=head2 SYNOPSIS

    use System::Passwd;

    my $root_user = get_user_by_uid(0);

    say $root_user.username;
    say $root_user.uid;
    say $root_user.gid;
    say $root_user.fullname;
    say $root_user.login_shell;
    say $root_user.home_dir;

    # can search for users other methods
    my $user = get_user_by_username('sillymoose');

    # or:
    my $user = get_user_by_fullname('David Farrell');

=head2 LICENSE

FreeBSD - see LICENSE

=head2 AUTHOR

David Farrell

=end pod
