# beckmanshire-chef

**beckmanshire-chef** is a complete Chef repository containing the cookbook and configuration files necessary for 
bootstrapping a macOS development machine. This repository is completely self-contained -- the cook is required to 
download the various cookbook dependencies via Berkshelf and **rsync** the repo to the target machine (_see 
"Bootstrap Instructions" section below_).


## Prerequisites

The following sections describe the necessary prerequisites that should be installed/configured on the target machine
before running the `chef-client` to bootstrap. 

### macOS VM

- Install VMWare Tools.
  - _NOTE: You may have to completely shutdown (rather than reboot) the VMWare VM after installing VMWare Tools for the
    screen resolution to adjust out of 1024x768._

### macOS VM and Server Installations

- Disable Messages and FaceTime.

### All Installations

#### From the Controller / Host Machine...

- Copy SSH public key from controller / host to the target machine.
  - _NOTE: It may be preferable to use an SSH key without a passphrase specifically for this purpose._ 
```shell
ssh-copy-id -i ~/.ssh/keys/vm-macos-ssh username@vm-hostname
```

#### From the Target Machine...

- Configure `System Preferences / Sharing`
  - Enable `Remote Login` for SSH access.
  - Change `Computer Name` and `Local Hostname`.
- Edit `/etc/sudoers` to add the following to enable passwordless SSH access.
```
%admin		ALL = (ALL) NOPASSWD:ALL
```
- Install XCode from the AppStore and accept the license agreement.
- Install the OSX Command Line Tools.
```shell
xcode-select --install
```
- Install [ChefDK](https://downloads.chef.io/chef-dk/mac/).
  - _NOTE: Due to some gem dependencies that have not been updated for Chef 13 compatibility, the latest version of the
    ChefDK found to work with `beckmanshire-chef` is `v1.6.11`._
- Generate an SSH key pair for the target machine (required for GitHub access to `beckmanshire` homesick repo). After
  creation, add the public key to GitHub.
  - _NOTE: This key should be generated without a passphrase so the `chef-client` can successfully clone a git 
    repository without being prompted for a passphrase._
```shell
ssh-keygen -t rsa -b 4096 -C "your_email@your_domain.com"
cat .ssh/id_rsa.pub
```
- If your target machine is a VM, create a VM snapshot.


## Bootstrap Instructions

### From the Controller / Host Machine...

#### Vendor Berkshelf Dependencies

**beckmanshire-chef** is dependant on the cookbooks defined in this repository as well as some community cookbooks from 
[supermarket.chef.io](https://supermarket.chef.io/). From your host machine, run the following command to gather all 
necessary dependencies locally. The following command will download all cookbook dependencies to `/berks-cookbooks`.

```shell
berks install && berks vendor --delete
```

#### rsync Cookbook Files and Config to Target Machine 

From your host machine, run the following command to copy the **beckmanshire-chef** contents to the target machine.

```shell
rsync -r . [username]@[target-machine]:~/.chef_zero
```

### From the Target Machine...

#### Execute chef-client

To make the setup and execution of the `chef-client` easier and more efficient on target machines, a shell script is 
included in this project that contains the necessary command line execution options. The only prerequisite for using 
this script is to ensure that any node JSON definition included in `/nodes` is _named with the target machines's 
**hostname** value_. For example: `nodes/kbeckman-macbook.local.json`

```shell
./.chef_zero/chef_client.sh
```

_NOTE: Occasionally the chef-client tends to fail during the execution when it's running homebrew cask installations.
If/when that happens, simply rerun the command to continue the process. All of the Chef commands are idempotent and are
designed to be executed multiple times._
