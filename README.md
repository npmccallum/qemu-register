### Unmodified Foreign-Architecture Docker Images

Sometimes you need to run a Docker image for a CPU architecture you don't own.
The [multiarch](https://hub.docker.com/u/multiarch/) project has attempted to
do this in the past. But the approach they have taken requires you to run
modified images. This is a lot of maintenance overhead. And it means the
images are perpetually out of date.

Enter `npmccallum/qemu-register`. This Docker image enables the host to run
**unmodified** foreign-architecture Docker images. Want an example?

```sh
$ sudo docker run -it --rm --privileged npmccallum/qemu-register
$ sudo docker run -it --rm aarch64/busybox uname -a
Linux 7643af1fa898 5.1.18-300.fc30.x86_64 #1 SMP Mon Jul 15 15:42:34 UTC 2019 aarch64 GNU/Linux
```

Yup! That's it!

### Requirements

* The host must be running Linux 4.8 or later.

### How it Works

Linux 4.8 added the `F` flag to `binfmt_misc`. This flag causes the kernel to
load the interpreter for the binary as soon as the configuration is loaded
rather than lazily on program execution.

This configuration really helps with containers because it means the
interpreter from one container can be used in another container. For example,
when you load an `aarch64` binary from the `aarch64/busybox` Docker image
above, the `qemu-user-aarch64` emulation binary is used from the
`npmccallum/qemu-register` Docker image. Therefore, foreign-architecture
images can run unmodified with this strategy.

### Security Implications

Any `qemu` vulnerabilities in `npmccallum/qemu-register` may impact your
application. This could result in an escalation of privileges. But containers
don't contain anyway. You probably don't need to be scared if you aren't using
this for public-facing services.
