# Mannaggia

Automatic italian swearer. Supports the following features:

- use "mannaggia" saint invocations or actual italian swear words (offensive!)
- let the terminal read such invocations for you (with `say` or `mplayer`)
- choose the number of invocations per minute
- automatically display all the invocations on all active terminals

## Getting started

### macOS

On macOS, no additional steps are required. Simply install the package and run the command `mannaggia`.

### Linux/WSL

On Linux environments, you need to install the `mplayer` package using the package manager of your choice (or by source, nobody is preventing you from doing that).

### Windows

Windows is not yet supported, but you can still `mannaggia` using WSL.

```plaintext
mannaggia [options]

--angry     uses actual italian swear words
--audio     uses `mplayer` to read the invocations
--spm <n>   sets the number of invocations per minute
--wall      displays the invocations on all active terminals
--nds <n>   number of invocations per minute (default: infinite)
--shutdown  if nds > 0 and root, shuts down the computer after nds invocations
--off       if root, shuts down the computer immediately (equivalent to --nds 1 --shutdown)
```

## Credits

Original idea by Alexiobash from `incazzatore.sh`. Expanded, rewritten and maintained by Pietro "Legolas" Suffritti. Further converted in `mannaggia.sh v0.2`. Current version expanded and rewritten by Matteo Franzil.

This project is released under the GPLv3 license. See the LICENCE file for more details.

Collaborators:

- Enrico "Henryx" Bianchi
- Alessandro "Aleskandro" Di Stefano
- Davide "kk0nrad" Corrado

Patchers and contributors:

- Marco Placidi
- Maurizio "Tannoiser" Lemmo
- Matteo Panella
- Mattia Munari
- Paolo Fabbri

Thanks to:

- Veteran Unix Admins group on Facebook
