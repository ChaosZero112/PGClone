# PGBlitz-PGClone
 
##### WANT TO HELP? CLICK THE ★ (STAR LOGO) in the Upper-Right! 
<p align="center">
  <a href="https://pgblitz.com/forums" target="_blank" /a><img src="https://pgblitz.com/wikipics/logo-forums.png" width="160"/>   
  <a href="https://github.com/PGBlitz/PGBlitz.com/wiki" target="_blank" /a><img src="https://pgblitz.com/wikipics/logo-wiki.png" width="160"/>
  <a href="https://pgblitz.com/threads/plexguide-install-instructions.243/" target="_blank" /a><img src="https://pgblitz.com/wikipics/logo-pg-install.png" width="160"/> 
  <a href="https://pgblitz.com/account/upgrades" target="_blank" /a><img src="https://pgblitz.com/wikipics/logo-donate.png" width="160"/>
</p>
 
* 📂 [**[Click Here]**](https://goo.gl/7NR3Da) - Google G-Suite (Unlimited Hard Drive Space & Storage)
* 📂 [**[Click Here]**](https://controlpanel.newshosting.com/signup/index.php?promo=partners&a_aid=5a65169240efd&a_bid=5ecfe99b) - Top Performance NewsHost! - Blitz Members Receive a 58% Discount
----
### **Reference Shortcut -** http://wiki.pgblitz.com | Discord ( !wiki )
----

## 1. PG YouTube

<p align="center"><kbd><a href="https://youtu.be/joqL_zjl0pE" /a><img src="https://github.com/PGBlitz/Assets/blob/master/ycovers/mainintro.png" width="400"></kbd></p>
<p align="center"><b>PGBlitz Introduction Video</b></p>

<p align="center"><kbd><a href="https://youtu.be/8lotdbpsrUE" /a><img src="https://github.com/PGBlitz/Assets/blob/master/ycovers/introv10.png" width="400"></kbd></p>
<p align="center"><b>PGBlitz Installation Video</b></p>
  
## 2. PlexGuide Install
  
The prefered deployment method.  
  
[**[Click Here]**](https://pgblitz.com/threads/plexguide-install-instructions.243/) for installation instructions to start the process.

## 3. Standalone Install
Added in version 10, the Standalone install allows you to utalize the capabilites of PGClone/PGBlitz without the need of a full [PlexGuide](https://plexguide.com) deployment.  
The Standalone deployment **is not an offically supported method** and preference should be put on the full PlexGuide deployment which includes PGClone bundled.  
If you already have a Plex / Media Server environment and would just like the benefits of PGClone, then the standalone installer can be utalized.
  
To begin the installation, you can use the following command:  
`curl -SsL https://raw.githubusercontent.com/ChaosZero112/PGClone/v10/install.sh | bash`  
  
Using the above will install PGClone in `/pg/pgclone`. If you would like to override the installation location, you may do so with the `PGBLITZ_DIR` environment variable. eg.  
`curl -SsL https://raw.githubusercontent.com/ChaosZero112/PGClone/v10/install.sh | PGBLITZ_DIR=/usr/local/pgclone bash`  
  
In addition, there is a `PGBLITZ_SRC` variable which will hold the local clone of this repository, the default is `/pg/pgclone-src`.  
  
**Only tested on Ubuntu 20.04 LTS (focal)**
