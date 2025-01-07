# DockerC++: Easy C++ Development Enviroment for Windows

## Installation & Usage

> [!NOTE]
> This proceduce isn't as smooth as I'd want it to be, but hopefully if I get time to work on it more, I can refine it

1. `git clone` this repository or download it as a zip file (to the right, green button saying "Code")
2. Right click on `install.ps1` and say _Run With Powershell_
3. That should be it, if you face any issues, please open an Issue

## Motivation
Usually when C++ is taught in schools and other education institutions, It is done on windows machines where the native IDE (Visual Studio) can be incredibly daunting if you are using it for the first time, It was daunting for me even though I've done C++ for comparativley ages.

![image](https://github.com/user-attachments/assets/500f18ea-a971-4175-ac35-6bc971f80bb8)
*What Visual Studio looks like when running a program*

So we usually settled on [Dev C++](https://www.embarcadero.com/free-tools/dev-cpp) (or on worse days, TurboC++ 🤮) which while a lot more graspable felt lacking in comparison to the experience I had with Visual Studio Code (or nvim) on Linux with a few additional tools, clangd, clang-tidy lldb etc, and for learning, things like linting formatting and **especially** autocomplete help a lot, even in normal usage

Knowning the massive pain that it is to get C/C++ working well without Visual Studio on Windows, I decided that it would be better to do everything inside of docker so one can use the usual linux binary tools and it would be easy to get libraries, through a package manager or by compiling for linux

But I needed this new experience to be as easy / easier to use so it had to be a few clicks at most and genuinley provide a better enviroment without any configuration / modification.

I initially wanted to put everything inside the container and ship a binary that would run the container within itself but after hunting I couldn't find a container runtime that was meant to be embeddable and the few I found didn't support windows (only [hcsshim](https://github.com/Microsoft/hcsshim) does) and had complicated install procedures which defeats the point ([containerd](https://github.com/containerd/containerd/blob/main/docs/getting-started.md) - it isn't that bad but doesn't feel very transparent, which is something I wanted)

So finally I settled on making use of Visual Studio Code's [Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers) which are designed to do exactly what I want, and to reach my 1-click goal, I made a powershell to go with that which will install Docker Desktop (if not already installed) and Visual Studio Code and then run code with a command to open in container
