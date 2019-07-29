# shebangs and busybox
% byline a POSIX tragicomedy, as chronicled by Lexi Summer Hale
% with style ../res/code.css

so here's a common problem and how busybox will use it to ruin your day:

on linux, script interpreters are specified in what we call a "shebang" - if a file is +x and begins with `#!…*\\n*`, the kernel itself can execute that script by starting an interpreter and feeding the file (shebang and all) into that interpreter. neat, right? except the shebang path *has to be an absolute path*

and if you know anything at all about the unix ecosystem, you know why this is fucking insane.

anyway, the usual idiom we use to get around the problem involves a tool called `env`. env is a weird little frankenstein's binary that does a couple of things. with no arguments, it lists all current environment variables. but with one or more arguments of the form `x=y`, followed by a command to invoke, it will permute the environment according to your specifications and then invoke that command. crucially, `env` *doesn't* require an absolute path and can generally be relied on to be located at `/usr/bin/env`, so if we just pass it the name of a binary, it'll take that name and work out where the actual binary is.

neat, right? this lets us write shell scripts that are portable across all sorts of different setups. except there's a problem.

you may be under the impression that a command line is just a string. it's not. on linux, the command line is actually an array -- the shell splits the string you enter up into tokens and then feeds them one-by-one into the program you launch. e.g. `$ cat -n fucko.c` --> `cat` `-n` `fucko.c`. this is why you can use quote marks and backslashes to pass complex strings to binaries.

however. that splitting-up-the-command behavior? shebangs can't do that[¹](#foot-1). a shebang has two fields: the interpreter and the first argument to pass to that interpreter. so if you pass it a command `binary -\-fucko` it won't launch a binary with the flag `-\-fucko` set; it will look for a binary literally named `binary \--fucko`, space and all. which it won't find, so it will error out. to get around this and allow you to pass flags to your scripts, GNU env, thank god, has a flag -S to emulate the shell behavior.

busybox env, on the other hand, has no way to split up a shebang's arguments

so good fucking luck writing portable shell scripts.

---

%anchor foot-1
**[1]** technically, shebang behavior is not actually defined in POSIX. some OSes split up arguments, some don't. to make things even messier, some interpreters, like perl, know about shebang fuckiness and ignore the actual command line flags when launched as an interpreter, instead *parsing the shebang line from the file* to set its options. even better, not every shell works by just passing the shebang'd file off to the kernel - some of them instead interpret the shebang in userspace and do the kernel's job for it, and again, can interpret the shebang howsoever it pleases. so the behavior is finicky, inconsistent even on the same system depending on a multitude of unclear factors, and extremely subtle - the best possible scenario to write portable code for!

%to pub/vt/irl
%path essays