# archlive-macbook 
   
   This is about installing Arch Linux on a 
   17" macbook pro 8,2 : late 2011, flawed external video radeon.
   The 15 and 13" are less problematic.
   
   I am uncertain if the b43 drivers via b43-cutter, is necessary.
   Simply because I managed to turn off the video card later on.
   And added kernel parameters and modified EFI parameters...   
   
   Adding nomodeset radeon.modeset=0 got it to boot.
   Adding the aur package b43-cutter fixed wifi and bluetooth.
   
   I should have created swap so I had to make a swapfile,
   and then add kernel parameters on boot for that as well.
   
   Still no hibernation. Install and configure `wsusp` .
   still failing. it wakes but there is a blank screen the same
   as always.
   
   Turned off the radeon graphics card. this took a bit of searching.
   
   Et Voila ! Everything works, minus accelerated graphics.
   

  In the process there is mkarchiso and creating a local repo. That is 
  what this project is about.
  
  make it easy to create a custom live cd for your computer.
