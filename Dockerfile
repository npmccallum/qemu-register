FROM fedora:latest

RUN dnf install -y qemu-user-static && dnf clean all

CMD mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc && /usr/lib/systemd/systemd-binfmt
