
# Barebones linux on a chromebook with a testing and flashing script for a Particle.io device.

This was done to an HP chromebook 14-db0080nr

This chromebook has a broken bios like many of the AMD machines from this time period.
Changes made by google apparently break the ability to boot into another os even though 
the loader is there. As far as I know the only way to get another OS on this machine is 
to reflash the bios.

For the most part, These instructions should work for any chromebook.

### Known issues:

 Just a forewarning here. These were problems encountered and solved,
 specific steps will follow below. 

 * Broken Bios, 
   Fix: MrChromebox firmware-util.sh can replace with Seabios.
 * Write protect via CR50. 
   Fix: Requires a SuzyQ cable.
 * nomodeset must be on the boot options. 
   Fix: Press 'e' to edit the boot command from the boot menu and add nomodeset to the end of the options.
   * When booting the installer, You must catch this step, otherwise you'll just have to reboot and try again.
 * The amdgpu module has problems with nomodeset which cause linux to hang on boot. 
 Fix: amdgpu needs to be blacklisted.
 
#### Post install fixes to apply - a preview.
 /boot/entries/arch.conf must be edited after install to add/subtract the following from the options: 

   * Remove __ACPI=off__    
     * The presence of this causes the keyboard to not work, probably many other things as well.
   * Add __nomodeset__      
     * without this the tty1 display will go dark and hang. 
   * Add __modprobe.blacklist=amdgpu__ 
     * amdgpu is in conflict with nomodeset, hangs.
   * A _/etc/modprobe.d/blacklist_ entry must be made for amdgpu as well. 


## Wipe the chromebook and install Arch Linux

The only solution for this is to wipe the emmc and install Sea bios.
This completely removes chrome but makes a functional computer.

This process should work with all chromebooks from 2019 on.  
CR50 is the standard locking mechanism since that time.

Goal:  Wipe the emmc and install sea bios, so we can then install a
barebones Arch linacpinstance.

#, that option is
necessary on many older machines with out of date bios'# But not here. Developer mode.

 * Put chrome book in developer mode.   https://mrchromebox.tech/#devmode 
   * Power on with `Esc-Refresh-power`
   * `Ctrl-d` at rescue screen
   * Enter to confirm
   * When it comes back, ctrl-d to continue in dev mode or wait 30 seconds.
   * Click `lets go`
   * Click `Browse as Guest`
   
   You should, at this point, be in chrome, with developer mode on.
   
### MrChromebox's Firmware-util.sh

 * Get a crosh shell.  `Ctrl-Alt-t`
 * Get a real shell. Invoke `shell` at the prompt to become 'chronos' - there is no password.
 * Read the directions at MrChromeboxtech to 
   [download and install the firmware-util.sh](https://mrchromebox.tech/#fwscript)
   or maybe just do these 3 commands. (copy/paste these to avoid typos)

    cd; curl -LO mrchromebox.tech/firmware-util.sh
    sudo install -Dt /usr/local/bin -m 755 firmware-util.sh
    sudo firmware-util.sh

Once the firmware is running __Choose option 1__  it's the only option that can be done at this point.

Quit the firmware back to the shell to finish turning off the Wriacpirotect.

##, that option is
necessary on many older machines with out of date bios' UBut not here. nlock the firmware write protect.

Unlocking the firmware Write protect must be done via the use of a 
[special USB-C debug cable (often called a Suzy-Q cable - $15 from Sparkfun).](https://www.sparkfun.com/products/14746)

[Follow directions on MrChromeboxtech for the CR50 method](https://wiki.mrchromebox.tech/Firmware_Write_Protect#Disable_WP_.2F_Enable_Firmware_Flashing)
of unlocking a chromebook which uses the SuzyQ cable.

Pay attention, it takes several presses of the power button, each has a 10 second 
timeout so you have to pay attention. It's a PIA. 

### Reflash the bootloader with Sea Bios.

* Start over from the top, cause google said so. 
  * Turn on developer mode
    * Power on with `Esc-Refresh-power`
    * `Ctrl-d` at rescue screen
    * Enter to confirm
    * wait
  * Get a shell
    * Lets Go ->
    * Browse as Guest
    * Get a crosh shell.  `Ctrl-Alt-t`
    * Get a real shell. Invoke 'shell' at the prompt to become 'chronos' - there is no password.
  * download and install the firmware-util.sh again.

    cd; curl -LO mrchromebox.tech/firmware-util.sh
    sudo install -Dt /usr/local/bin -m 755 firmware-util.sh
    sudo firmware-util.sh

__Choose to install uefi firmware this time.__

When successful,  __Reboot__ will return back to the Sea bios flash screen.

Hit __Escape__ to get to the boot menu.


## Boot into an Arch Linux installer - with a boot menu edit.

[Make a linux installer on a usbstick.](https://wiki.archlinux.org/index.php/USB_flash_installation_medium)

[The Official Arch linux installation guide is here.](https://wiki.archlinux.org/index.php/Installation_guide)

When booting into seabios hit __Esc__ for the boot menu and choose your linux installer.

The Arch linux boot menu will appear next.  

* `nomodeset` must be added to the boot command or the display will go blank
during the boot.

   * Highlighting Arch Linux, should be there, press `e` to edit the boot command.
   * Arrow all the way to the end and add `nomodeset`.  
   * Enter to finish, 

At this point Arch linux will boot from the install media and you will be presented
with a prompt. 

### Get Wifi
iwctl is used to get a wifi connection. wlan0 is the wifi device on this computer.

    `iwctl device list`

    __wlan0__

    `iwctl station wlan0 connect <yournetworkname>`
    `iwctl station wlan0 show`

That should be enough to get wifi going. Otherwise refer to the Installation guide.


### Download the install script, make it executable

 This installation process is one that I use personally to easily recreate
 linux boxes in various configurations. It consists of Arch linux Meta packages,
 and my own configuration repositories all tied together with `Make`.
 
 My [Arch-Setup Repository can be found here.](https://github.com/EricGebhart/Arch-Setup)

 * curl the _install-arch_ script from this repo.
    `curl https://raw.githubusercontent.com/EricGebhart/Arch-Setup/master/install-arch  > ./install-arch`
 * Make it executable: 
    `chmod a+x ./install-arch` 
 * Get help 
    `./install-arch -h`
 

### Partition the drive

 * Take a look at the block devices with `lsblk`.

In this case we want to install to the emmc which is /dev/mmcblk1

Chromebooks, or at least this chromebook, had /dev/mmcblk1 chopped up into 12 partitions.

 * Delete all the partitions and create 2 new ones with fdisk. `fdisk /dev/mmcblk1` 

You will need an [EFI system partition](https://wiki.archlinux.org/index.php/EFI_system_partition)
and a root system partition.

It is sufficient to make a new partition `n` of size __1M__ at the default 
start location, with a type `t` of __1__.  

Make another partition `n` with the rest of the disk.  The default type is linux filesystem.

Print the table, make sure gpt is set, and there are 2 partitions, 1 of about 512M for EFI and
1 for linux with the rest.

`w` to write the table and quit.


### Format the partitions.
Now we need to format the partitions. If you made the EFI partition first it will be partition p1.
Use `lsblk` to see what you have if you don't remember.

    `mkfs.fat -F32 /dev/mmcblk1p1`

The Root system should be partition 2.

    `mkfs.ext4 /dev/mmcblk1p2`


### Run the install script

To install with just the defaults along with a hostname of _T5-tester1_ and a user named _robot_ do this.
    ./install-arch -e /dev/mmcblk1p1 -r /dev/mmcblk1p2 -n T5-tester1 -u robot  
    
The default locale and timezone are:
    locale='en_US.utf8'
    timezone='America/New York'
 
### Fix the Boot Loader, blacklist the amdgpu module.

After the script finishes the Boot loader must be fixed so that this computer will
successfully boot.  The script adds _acpi=off_, to the boot command, that option is
necessary on many older machines with out of date bios'. But not here. That must be removed
and we must add _nomodeset_ and blacklist the _amdgpu_ module.

Edit the bootloader entry with vi.

    arch-chroot /mnt vi /boot/loader/entries/arch.conf

    Remove `acpi=off` from the end of the options line.

    Add `nomodeset modprobe.blacklist=amdgpu` to the end of the options line. 

Create modprobe.d/blacklist.conf, blacklisting the _amdgpu_ module.

    echo "blacklist amdgpu" > /etc/modprobe.d/blacklist.conf


## Reboot

 * `reboot`
    
 * unplug the usb installer
    
 * When it returns, login as _robot_ with the password you gave.

## Install our tools.

### install-packages
After reboot, upon login, the `install-packages` script will run automatically.
It only does this once. it can be run manually anytime with 
`~/Arch-Setup/install-packages` or by running `make` in the appropriate projects.
