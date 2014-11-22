class System::Passwd::User::Linux is System::Passwd::User
{
    method new (Str @line!)
    {
        self.username    = @line[0],
        self.password    = @line[1],
        self.uid         = @line[2],
        self.gid         = @line[3],
        self.fullname    = @line[4],
        self.home_dir    = @line[5],
        self.login_shell = @line[6]
    }
}
