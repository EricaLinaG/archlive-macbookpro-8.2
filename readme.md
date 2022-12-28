# archlive-macbook 

   This is really just a mkarchiso project. It started as a live install
   for a macbook pro. 

   So, the mac made me create a custom repo, and start using mkarchiso, and here we are.

   But it is really handy to have your own custom live install. I can put my 
   install script on it. I can add the package lists, and create custom boot 
   menu items to accomodate different computers.

   So I'm adding in all the permutations I've needed for the computers I have.
   This one live iso, can boot my chromebook, my macbook pro, my NUC, and my
   Wacom mobile studio pro.  Mostly the kernel parameters are the only real
   problem.
   
   Mostly thats a few kernel parameters and some stuff from the AUR.
   plus my own Arch install script which I have used for 
   
   I have a custom Arch Repo to go with this, it really only has B43-firmware, 
   B43-fwcutter and Yay.  B43 is the network driver needed for the macbook pro.
   
   
## kernel boot parameters
   All these computers just needed some different kernel parameters to get up and
   running. I've added new grub menu items for the moment. But should let make take
   care of that automatically.
   
## The Repo
   That is a separate project that we just need to point at from here. 
   
   I think it would be nice to make that repo part of the Arch-Setup system
   so that the repo can be built and deployed.
   
   More to do.
   
## 2012 macbook pro

   This started with the process of installing Arch Linux on a 
   17" macbook pro 8,2 : late 2011, flawed external radeon video card, 
   onboard intel video.
   The 15 and 13" are less problematic for lack of the AMD radeon gpu.
   
   The details of 
   [installing Arch on a macbook pro are here.](http://github.com/ericalinag/archlive-macbook-8.2/macbook-8.2.md)

## 2019 14" HP Chromebook
   
   It was very interesting intalling Arch on an HP chromebook.
   You can read about
   [Installing Arch linux on an HP chromebook here.](http://github.com/ericalinag/archlive-macbook-8.2/chromebook.md)

