
# Table of Contents

1.  [Olli&rsquo;s dotfiles - Windows and Wsl](#org5653492)
    1.  [Installation](#org4f56917)
        1.  [Windows](#org4d11454)
        2.  [Wsl](#orgf20a57b)
    2.  [Thanks to&#x2026;](#orgebb2962)
        1.  [Christian Rondeau&rsquo;s dotfiles](#org86b1cd6)



<a id="org5653492"></a>

# Olli&rsquo;s dotfiles - Windows and Wsl


<a id="org4f56917"></a>

## Installation

Clone or download to ~/dotfiles


<a id="org4d11454"></a>

### Windows

Open powershell with admin priviledges

Set executionPolicy to allow running script:

    Set-ExecutionPolicy RemoteSigned

Start script, you need to select profile with parameter -p, below example we are using &ldquo;basic&rdquo;

    .\bootstrap.ps1 -p "basic"


<a id="orgf20a57b"></a>

### Wsl

Open wsl terminal

set script file executable

    chmod +x bootstrap.sh

Start script, you need to select profile with parameter -p, below example we are using &ldquo;basic&rdquo;

    sudo ./bootstrap.sh -p "basic"


<a id="orgebb2962"></a>

## Thanks to&#x2026;


<a id="org86b1cd6"></a>

### Christian Rondeau&rsquo;s dotfiles

[GitHub - christianrondeau/dotfiles: My own (awesome) personal dotfiles](https://github.com/christianrondeau/dotfiles)

