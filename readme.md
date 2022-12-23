# archlive-macbook 
   
   This is about installing Arch Linux on a 
   17" macbook pro 8,2 : late 2011, flawed external video radeon.
   The 15 and 13" are less problematic for lack of the AMD radeon gpu.
   
   The idea is that this project uses Archiso and a custom library and
   some Make magic to create an installation disk and repeatable process to put 
   Arch Linux on this macbook pro. 

  Arch Linux has a very helpful page for [these macbooks.](https://wiki.archlinux.org/title/MacBookPro8,1/8,2/8,3_(2011))
  
There are some difficulties with this macbook. The worst is the Broadcom b43
network driver and the AMD Radeon gpu.  On initial live usb boot it hung.
The second time there were no network devices. A custom repo and B43-fwcutter
installed, it booted and installed.  From then on the only real problems were 
hibernation and SSH always timing out. Also the fragility of the GPU was a concern,
as well as being one of the possible problems.
  
## The problems/steps in order
   - make regular Arch Live USB
   - Hang on boot.     
     - Add _nomodeset radeon.modeset=0_ to kernel parameters
   - no wifi - wires are hard to come by.
     - Create a [custom repo](https://wiki.archlinux.org/title/Pacman/Tips_and_tricks#Custom_local_repository) for [mkarchiso.](https://wiki.archlinux.org/title/Archiso )
     - mkarchiso with [b43-fwcutter](https://archlinux.org/packages/core/x86_64/b43-fwcutter/) from custom repo so the live usb has it. It lives in the AUR. Added _yay_ just in case.
   - Live USB works! Network works !

   - [Install my Arch](https://github.com/EricaLinaG/Arch-Setup)

   - Hibernation has blank screen on wake. Unresponsive. Power turns it off.

   - I didn't make swap space. - It is needed by hibernate.  
     - [Make 20G swapfile](https://wiki.archlinux.org/title/Swap#Swap_file_creation). It has 16G it might have to hibernate. 
   - Assign [swap space to the resume/hibernation kernel parms.]https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Required_kernel_parameters) 

   - Hibernation still has blank screen on wake.

   - Turn off AMD Radeon GPU with EFI Vars. - see below, [originally found here](https://forums.macrumors.com/threads/force-2011-macbook-pro-8-2-with-failed-amd-gpu-to-always-use-intel-integrated-gpu-efi-variable-fix.2037591/).
     - The _xf86-video-ati_ driver does actually work with it. I dont trust the HW.

   - Hibernation still has blank screen on wake like always! 
   Probably not Radeon related.
   
   - [Found the Arch page !!!!!](https://wiki.archlinux.org/title/MacBookPro8,1/8,2/8,3_(2011))

   - [Configure Uswsusp](https://wiki.archlinux.org/title/Uswsusp)
   - [Use Uwsusp to suspend the b43 driver.](https://wiki.archlinux.org/title/MacBookPro8,1/8,2/8,3_(2011)#Suspend_and_hibernate)
   
   - Hibernation Works !!!
   
   - SSH to github always times out. 
   other computers, same network, sama sama, work fine. Tried a lot of things.
     - Added __IPQos 0x00__ to _~/.ssh/config_
     - Here is all of `~/.ssh/config`:

    ```   
    User EricaLinaG
    Host *
    IPQos 0x00

    Host github.com
      User git
      Hostname ssh.github.com
      Port 443

    Host gitlab.com
      User git
      Hostname altssh.gitlab.com
      port 443

    PreferredAuthentications publickey   
    IdentityFile ~/.ssh/id_ed25519
    ```   
   
   That's about it, everything seems to be working. Its in need of
   an SSD. It is slow. I saw someone who put two drives in and then
   striped them with raid 0. That machine had faster I/O than most
   new laptops.  I might do that just to see, it used to have 2 drives.
   
   
## Uncertainties
   I do not know if I actually needed to turn off my GPU yet. I trust
   that it would die at some point so it seemed reasonable to do.
   It did also seem to be a source of trouble with hibernation, but that 
   might just have been the broadcom B43 network driver.
   
   Before turning off the radeon gpu, any boot with i915 parameters would hang.
   Which makes sense in a way, although I did try configuring 2 video cards in X.
   
   I am also uncertain if the b43 drivers via b43-cutter, is necessary.
   I read somewhere later that it could be possible to blacklist it and
   force usage of the wlan driver. I tried blacklisting it, but didn't do 
   the magic for invoking wlan. So I just dont know. What I have is working.
   I have a custom repo so I can include b43-cutter from the AUR on the ArchLive.
   
## Hibernation and wake  

 - If no swap space. Create swapfile a little bigger than total memory size. 
 - Follow the [directions]https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Required_kernel_parameters) to set up the kernel parameters which configure swap for hibernation.
 - Set up hibernation with Uswsusp.
   - `yay -S uswsusp`
    - [Configure uswsusp](https://wiki.archlinux.org/title/Uswsusp)
    - [Tell it to suspend the B43 network driver](https://wiki.archlinux.org/title/MacBookPro8,1/8,2/8,3_(2011)#Suspend_and_hibernate)
 
## turn off the external AMD radeon 6xxx gpu

 The full text was [originally found here.](https://forums.macrumors.com/threads/force-2011-macbook-pro-8-2-with-failed-amd-gpu-to-always-use-intel-integrated-gpu-efi-variable-fix.2037591/).

The 8,2 17" macbook had a manufacturing defect which caused the gpu to fracture
after some time. Mine originally lasted 2 years before Apple replaced it.
Of course its just going to happen again, and besides this radeon board causes
all sorts of problems because it doesn't play nice with others.

If for some reason you no longer have OS X installed, turning off the external gpu
is a little bit involved. I have seen that grub can send some codes and accomplish the same thing. I'm not using grub. So here is what I did.

### Edit EFI vars: 

efivars should be mounted. So you can take look. There are a bunch
of files which end with UUIDs.
  - `ls /sys/firmware/efi/efivars`
  - `ls /sys/firmware/efi/efivars __gpu-power-prefs-*`

  If it is there, it will have a name like this. 
     _gpu-power-prefs-fa4ce28d-b62f-4c99-9cc3-6815686e30f9_


The OP stated this:
Looking at this [gpu-switch text file](https://github.com/0xbb/gpu-switch/blob/master/gpu-switch), indicated doing this:

```
printf "\x07\x00\x00\x00\x01\x00\x00\x00" > /sys/firmware/efi/efivars/gpu-power-prefs-fa4ce28d-b62f-4c99-9cc3-6815686e30f9
```

I had the file and I did the printf and all seems fine.

At this point you can reboot and the computer will have only the intel i915 
onboard video from now on. So boot into the full i915 boot choice.

### kernel parameters used in this process.

Now we can turn on some extra things in the kernel.
These parameters do not work if the external AMD GPU is still enabled.

Some kernel parm choices, split lines for readability.

_nomodeset_ allows the live media to boot.
```
options  root=PARTUUID=90dbd8b6-e79c-814c-a529-7d092e15ea69 rw 
nomodeset 
```
Adding radeon.modeset=0 makes sure we don't use it. It fixed something!
This is enough to get to installing.
```
options  root=PARTUUID=90dbd8b6-e79c-814c-a529-7d092e15ea69 rw 
nomodeset 
radeon.modeset=0 
```
Add _resume_ and *resume_offset* to point at the swapfile for hibernation.
```
options  root=PARTUUID=90dbd8b6-e79c-814c-a529-7d092e15ea69 rw 
nomodeset 
radeon.modeset=0 
resume=UUID=a3ea2712-1f90-4b78-8caa-cee4344cfc90 resume_offset=3512320
```
These will hang if the Radeon GPU is still active.

Turn on the i915 module I don't believe I have tested this successfully.
```
options  root=PARTUUID=90dbd8b6-e79c-814c-a529-7d092e15ea69 rw 
nomodeset 
radeon.modeset=0 
i915.modeset=1 
resume=UUID=a3ea2712-1f90-4b78-8caa-cee4344cfc90 resume_offset=3512320
```
Turn on 2 channel LVDS.
````
options  root=PARTUUID=90dbd8b6-e79c-814c-a529-7d092e15ea69 rw 
nomodeset 
radeon.modeset=0 
i915.modeset=1 
i915.lvds_channel_mode=2 
resume=UUID=a3ea2712-1f90-4b78-8caa-cee4344cfc90 resume_offset=3512320
```
