use System::Passwd::User;

module System::Passwd
{
    die 'This module is only compatible with Linux' if $*DISTRO.Str !~~ m:i/linux/;

    # build users array
    my $password_file = open '/etc/passwd', :r;
    my @users = ();

    for $password_file.lines
    {
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

