FROM ubuntu:latest

RUN apt-get update &&\
    apt-get install build-essential cmake meson git clang-format clang-tidy -y

RUN apt-get install -y clangd

RUN apt-get install -y lldb

CMD ["/bin/bash"]