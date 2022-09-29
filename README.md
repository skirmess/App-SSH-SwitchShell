# NAME

sshss - use your preferred shell and own home directory for shared SSH accounts

# VERSION

Version 0.006

# SYNOPSIS

- **sshss** \[-h &lt;home>\] \[-e VARIABLE\[=value\]\]...
    \[--env-command VARIABLE\[=value\]\]...
    \[--env-login VARIABLE\[=value\]...  \[shell\]

# DESCRIPTION

**sshss** adds support to ease the pain of these dreadful shared accounts
prevalent at some organizations. All you have to do is add **sshss** to
the _command_ string of the `authorized_keys` file. **sshss** lets you
define a different shell then the one defined in the passwd database,
configure environment variables, and a different directory as your home
directory.

All features, the personal home directory, the environment variables,
and the shell change, can be used independently without using the other.

If you specify a new shell the shell is not only used as the login
shell but also if you directly run a command. This includes commands
that run over SSH like [scp(1)](http://man.he.net/man1/scp) and [rsync(1)](http://man.he.net/man1/rsync). It's
your responsibility to not use an overly obscure shell that breaks these
commands.

The used shell must support the _-c_ flag to run a command, which is
used if you run a command directly over SSH, including [scp(1)](http://man.he.net/man1/scp)
and [rsync(1)](http://man.he.net/man1/rsync). This is the default used by SSH itself. If
your shell would work with plain SSH, it will also work with **sshss**.

**sshss** tries to behave as much as possible like the `do_child`
function from `session.c` from OpenSSH portable.

**sshss** uses no non-core modules.

# OPTIONS

- _-e VARIABLE\[=value\]_

    Sets the environment variable `VARIABLE` to `value`.

    If `value` is an empty string, the environent variable is set to an
    empty string.

    If the `=` sign is ommited, the variable is deleted

- _--env-command VARIABLE\[=value\]_

    Same as `-e` but this variable is only set for non-login sessions.

- _--env-login VARIABLE\[=value\]_

    Same as `-e` but this variable is only set for login sessions.

- _-h home_

    Specifies the directory to set as your home directory. sshss will set
    the _HOME_ environment variable and change to this directory.

    If the argument is a relative directory it is made absolute from the
    current working directory, which is the default home directory of the
    account you log in to.

    If this is not specified, or if it is the same as the already configured
    home directory, nothing is changed.

    Note: Symlinks are resolved to compare the directory with the current
    defined home directory, but they are not resolved when setting the
    `HOME` variable.

- _shell_

    Specifies the shell to be used instead of the one specified in the
    passwd database.

    This can be used to overwrite the shell configured for a shared account.
    It can also be used to change the shell for your personal account if
    your organization does not have a supported way to change your shell.

    If the shell is omitted, **sshss** uses the default shell for the account
    from the passwd database.

    If the specified shell is not an absolute path, **sshss** uses the
    default shell for the account from the passwd database.

# EXIT STATUS

**sshss** exits 1 if an error occurs until it can exec the shell. After
the exec the exit status depends on the executed shell or the command
run in this shell.

# EXAMPLES

## **Example 1** Change the shell to ksh93 and use a custom home directory

Create a directory to contain your own home directory. We create the
directory ~/.ryah in this example. Add the following command string in
front of your SSH key in the `~/.ssh/authorized_keys` file:

    command="/usr/bin/env perl .ryah/.ssh/sshss -h .ryah /usr/bin/ksh93"

Note: Adjust the path to `sshss` if you didn't put it in the `.ssh`
directory in your new home directory.

When you login over SSH with your key to the admin account,

- your shell will be `/usr/bin/ksh93`, started as login shell
- the SHELL environment variable will be set to `/usr/bin/ksh93`
- the HOME environment variable will be set to `/home/admin/.ryah`
(The shared accounts home directory is /home/admin in this example)
- the working directory will be `/home/admin/.ryah`
(The shared accounts home directory is /home/admin in this example)

## **Example 2** Change the shell to ksh93 without changing the home directory

Add the **sshss** script to e.g. the `~/.ssh` directory or any other
directory.

Add the following command string in front of your SSH key in the
`~/.ssh/authorized_keys` file:

    command="/usr/bin/env perl .ssh/sshss /usr/bin/ksh93"

Note: Adjust the path to `sshss` if you didn't put it in the `.ssh`
directory.

When you login over SSH with your key to the admin account,

- your shell will be `/usr/bin/ksh93`, started as login shell
- the SHELL environment variable will be set to `/usr/bin/ksh93`

## **Example 3** Use a custom home directory

Create a directory to contain your own home directory. We create the
directory ~/.ryah in this example. Add the following command string in
front of your SSH key in the `~/.ssh/authorized_keys` file:

    command="/usr/bin/env perl .ryah/.ssh/sshss -h .ryah"

When you login over SSH with your key to the admin account,

- your shell will be the shell defined in the passwd database,
started as login shell. If the shell specified in the passwd database is
empty or invalid, `/bin/sh` is used instead.
- the SHELL environment variable will be set to the shell defined
in the passwd database. If the shell specified in the passwd database is
empty or invalid, the SHELL environment variable is set to `/bin/sh`
instead.
- the HOME environment variable will be set to `/home/admin/.ryah`
(The shared accounts home directory is /home/admin in this example)
- the working directory will be `/home/admin/.ryah`
(The shared accounts home directory is /home/admin in this example)

## **Example 4** Use a custom bash profile

Create your own `.bash_profile` file and call it something like e.g.
`.bash_profile.ryah`. Then add the following at the top of the
`.bash_profile` file in the shared account.

    if [[ $SSHSS_USER = 'ryah' ]]
    then
        . $HOME/.bash_profile.$SSHSS_USER
        return
    fi

Create your own `.bashrc` file and call it something like e.g.
`.bashrc`. Then add the following at the top of the
`.bashrc` file in the shared account.

    if [[ $SSHSS_USER = 'ryah' ]]
    then
        . $HOME/.bashrc.$SSHSS_USER
        return
    fi

Then add the following command to your `authorized_keys` file:

    command="/usr/bin/env perl sshss -e SSHSS_USER=ryah"

The `.bash_profile` file is executed when you log in to the system and
the `.bashrc` file is only run when you start another shell after
logging in. Most of the time the `.bashrc` file should be sourced from
the `.bash_profile` file.

## **Example 5** Use a custom ksh93 profile

Create your own `.profile` file and call it something like e.g.
`.profile.ryah`. Then add the following at the top of the
`.profile` file in the shared account.

    if [[ $ENV =~ /.kshrc.ryah$ ]]
    then
        . $HOME/.profile.ryah
        return
    fi

Then add the following command to your `authorized_keys` file:

    command="/usr/bin/env perl sshss -e ENV=$HOME/.kshrc.ryah"

## **Example 6** Configure your Git user

One of the many problems of shared accounts is that the Git author is
most likely configured for someone else, or for the sared account.

Then add the following command to your `authorized_keys` file to fix
this:

    command="/usr/bin/env perl sshss -e GIT_AUTHOR_NAME='Sven Kirmess' -e GIT_AUTHOR_EMAIL='sven@example.com' -e GIT_COMMITTER_NAME='Sven Kirmess' -e GIT_COMMITTER_EMAIL='sven@example.com'"

These variables get precedence over whatever is configured in the
shared accounts `.gitconfig`.

# ENVIRONMENT

- HOME

    If the `-h` option is used the `HOME` environment variable is set to
    the new home directory and the working directory is changed to this new
    home directory.

    Otherwise the HOME environment variable is not used, nor is the working
    directory changed.

- SHELL

    The environment variable SHELL is set to the shell that is either used
    as interactive shell or that is used to execute the command.

# SEE ALSO

[passwd(4)](http://man.he.net/man4/passwd), ["AUTHORIZED\_KEYS FILE FORMAT" in sshd(1)](http://man.he.net/man1/sshd)

# SUPPORT

## Bugs / Feature Requests

Please report any bugs or feature requests through the issue tracker
at [https://github.com/skirmess/App-SSH-SwitchShell/issues](https://github.com/skirmess/App-SSH-SwitchShell/issues).
You will be notified automatically of any progress on your issue.

## Source Code

This is open source software. The code repository is available for
public review and contribution under the terms of the license.

[https://github.com/skirmess/App-SSH-SwitchShell](https://github.com/skirmess/App-SSH-SwitchShell)

    git clone https://github.com/skirmess/App-SSH-SwitchShell.git

# AUTHOR

Sven Kirmess <sven.kirmess@kzone.ch>
