## About

Files and assets for creating and running
[OpenFOAM](https://www.openfoam.com) container images.

- https://hub.docker.com/u/opencfd/
- general [wiki docker information][wiki-docker]
- some [notes][wiki-notes]


## Notes

The container files listed here can provide a reasonable basis for
creating other images on top of OpenFOAM.

If you are using an ARM-based machine, the standard AMD64 images will
be rather slow (due to the emulation layer). For these type of
machines it is recommended to simply create your own image using
Ubuntu or openSUSE Leap components.


## License

File assets are GPL-3.0+ (as per OpenFOAM itself).


---
Copyright (C) 2021-2023 OpenCFD Ltd.

[wiki-docker]: https://develop.openfoam.com/Development/openfoam/-/wikis/precompiled/docker
[wiki-notes]: https://develop.openfoam.com/packaging/containers/-/wikis/home
