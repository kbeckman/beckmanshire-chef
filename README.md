# beckmanshire-chef #

**beckmanshire-chef** is a Chef repository that contains the cookbook and configuration files necessary for boostrapping
a macOS development machine. This repository is completely self-contained and requires the cook to download the cookbook
dependencies via Berkshelf and **rsync** the repo to the target machine.

## Prerequisites ##

### System Setup ###

- (VM) Install VMWare Tools.
- Install XCode from the AppStore and accept the license agreement.
- Install the OSX Command Line Tools.
```
xcode-select --install
```
- [Enable Remote Login for SSH Access](https://support.apple.com/kb/PH21839?locale=en_US&viewlocale=en_US)
- SSH Setup
```shell
# From your host...
ssh-copy-id -i  ~/.ssh/id_rsa username@vm-hostname
```
```
# From your Chef client...
ssh-keygen -t rsa -b 4096 -C "your_email@your_domain.com"
```
- Install [ChefDK](https://downloads.chef.io/chef-dk/mac/)
- (VM) Create a VM snapshot.
- (Sierra) Make the following edit to the `/etc/sudoers` file.
```
%admin		ALL = (ALL) NOPASSWD:ALL
```


## Instructions ##

### Target System Setup ###

### Vendor Berkshelf Dependencies ###

**beckmanshire-chef** requires the cookbooks defined in this repository as well as some community cookbooks from 
[supermarket.chef.io](https://supermarket.chef.io/). From your host machine, run the following command to gather all 
necessary dependencies locally.

```shell
berks vendor
```

This will download all necessary cookbook files to `berks-cookbooks`.

### rsync Cookbook Files and Config to Target System ###

From your host machine, run the following command to copy the **beckmanshire-chef** contents to the target machine.

```shell
rsync -r . [username]@[target-machine]:~/.chef_zero
```

### Execute chef-client ###

Once all of the files have been copied to the target system, run the following command to execute the `chef-client`
utility _in local mode_ to bootstrap the target system.

- **node-name** - hostname of the target machine
- **target-node** - node filename for the target machine

```shell
sudo chef-client -z -N [node-name] -c ~/.chef_zero/chef_zero.rb -j ~/.chef_zero/nodes/[target_node].json
```

```shell
# Keeping this command handy for VM testing...
sudo chef-client -z -N vm-macos-sierra -c ~/.chef_zero/chef_zero.rb -j ~/.chef_zero/nodes/vm-macos.json
```

_NOTE: Sometimes the chef-client tends to fail during the execution when it's running the homebrew cask installations.
If/when that happens, just rerun the command to continue the process. All of the Chef commands are idempotent and it 
doesn't hurt to run the process multiple times._

