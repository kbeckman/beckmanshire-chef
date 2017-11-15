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
- Install [ChefDK](https://downloads.chef.io/chef-dk/mac/)
- Generate an SSH key pair for the target machine (required for GitHub access to `beckmanshire` homesick repo). After
  creation, add the public key to GitHub.
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

### Vendor Berkshelf Dependencies ###

**beckmanshire-chef** is dependant on the cookbooks defined in this repository as well as some community cookbooks from 
[supermarket.chef.io](https://supermarket.chef.io/). From your host machine, run the following command to gather all 
necessary dependencies locally.

```shell
# From your host machine...
berks vendor
```

This will download all necessary cookbook files to `berks-cookbooks`.

### rsync Cookbook Files and Config to Target System ###

From your host machine, run the following command to copy the **beckmanshire-chef** contents to the target machine.

```shell
# From your host machine...
rsync -r . [username]@[target-machine]:~/.chef_zero
```

### Execute chef-client ###

To make the setup and execution of the `chef-client` easier and more efficient on target machines, a shell script is 
included in this project that contains the necessary command line execution options. The only prerequisite for using 
this script is to ensure that any node JSON definition included in `/nodes` is _named with the target machines's 
**hostname** value_. For example: `nodes/kbeckman-macbook.local.json`

```shell
# From your target machine...
./.chef_zero/chef_client.sh
```

_NOTE: Occasionally the chef-client tends to fail during the execution when it's running homebrew cask installations.
If/when that happens, simply rerun the command to continue the process. All of the Chef commands are idempotent and are
designed to be executed multiple times._
