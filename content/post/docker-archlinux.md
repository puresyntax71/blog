+++
date = "2017-09-17T00:28:51+08:00"
tags = ["archlinux","tools"]
title = "Docker in Arch Linux"
+++

[Docker][1] has been a necessary tool for me when it comes to development. I've used to use [Vagrant][2] but have then switched to Docker.

This was my first time installing Docker in Arch Linux.

## Installation

Installation for docker packages was pretty easy. All I had to do was:

```shell
$ pacman -Sy docker docker-compose docker-machine
```

I then needed to install the driver for `docker-machine` which would commonly be [Virtualbox][3]. I've installed Virtualbox with the following:

```shell
$ pacman -Sy virtualbox linux-headers virtualbox-host-dkms
```

## Virtualbox Configuration

Before any Virtualbox configuration, in my BIOS, I needed to first enable "SVM mode". I am using [GA-AB350-Gaming 3][4] and this setting is located under **Advanced Frequency Settings** > **Advanced CPU Core Settings** > **SVM Mode**.

{{< figure src="/images/gigabyte.png" title="GA-AB350-Gaming 3" >}}

I've then enabled modules needed to get `docker-machine` working:

```shell
$ modprobe -a vboxdrv vboxnetflt vboxnetadp
```

I can then finally get a new virtual machine with `docker-machine`:

```shell
$ docker-machine create default
```

I've also encountered an issue with the mounted files from host to the guest machine. Not yet sure what was the issue was. I recreated the machine which then seemed to have the mounted volume in place.

[1]: https://www.docker.com/
[2]: https://www.vagrantup.com/
[3]: https://www.virtualbox.org
[4]: http://www.gigabyte.us/Motherboard/GA-AB350-Gaming-3-rev-10
