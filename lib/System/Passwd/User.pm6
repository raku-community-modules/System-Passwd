class System::Passwd::User
{
    has $.username;
    has $.password;
    has $.uid;
    has $.gid;
    has $.fullname;
    has $.home-directory;
    has $.login-shell;

    method home_directory() is DEPRECATED('home-directory') {
        $!home-directory
    }

    method login_shell() is DEPRECATED('login-shell') {
        $!login-shell
    }

    method new ($line!)
    {
        my @line = $line.split(':');
        my $username        = @line[0];
        my $password        = @line[1];
        my $uid             = @line[2];
        my $gid             = @line[3];
        my $fullname        = @line[4];
        my $home-directory  = @line[5];
        my $login-shell     = @line[6];

        return self.bless(:$username, :$password, :$uid, :$gid, :$fullname, :$home-directory, :$login-shell);
    }
}
