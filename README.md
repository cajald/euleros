# EulerOS

> _Distributed computing, for everyone on the two supported computers!_

EulerOS is **my** attempt to do both an OS and distributed computing where you
can connect multiple clusters and use them to distribute workload and do stuff
in multiple machines.

Euler runs on the home-grown Euclid monolithic kernel.

It is a mostly UNIX-like OS with a few notable changes:

* as little GNU as I could
* no _real_ `/usr`; it's mostly just symlinks
* no dynamic linking
* `/net` dir for cluster stuff.
* `/proc` dir (not really a directory, generated on the fly by the kernel to
	RAM) for exposing OS information.

## Building

You'll need:

* [fasm](https://flatassembler.net/)
* [TCC](https://bellard.org/tcc/)
* ksh for some scripts; any ksh clone should work, but I use `oksh` personally.
* BSD make; gmake won't work.
* **tons** of good luck

With [Void Linux](https://voidlinux.org/), install them with `xbps`:

```sh
$ sudo xbps-install -S   # sync repos
$ sudo xbps-install tcc fasm oksh bmake
```

If you want, you can also use `xbps-src` ¯\\(ツ)/¯.

Now just run `make` and if it succeeds, run the `scripts/disk.ksh` script to
make an `euler64.iso` file.

If you want to run it on an emulator, run the `scripts/emul.ksh` script to run
Euler on QEMU.

If you want to run it on real hardware tho... I don't think it will really
work...

## License

[0-BSD](./LICENSE)

## TODO

* do something
* become schizophrenic
* dedicate the os to god
* rename it to idk... curchOS?
* make it use 640x480 because that is god's favourite resolution
* don't take my meds and live on a van while vans support me
* change my name to "Terry Davis"

