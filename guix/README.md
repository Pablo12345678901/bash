CONTENT

This repo contains :

- a 'bin' symlink which redirects to the current OS dir with its scripts in production. Most of them are sourcing the 'fonctions_personnelles' script that contains general customized functions. 

- dirs with OS names, containing scripts that can be used in production in such OS.

- a dir called 'scripts_in_dev_or_to_be_tested_before_pushed_to_production' with scripts in development, or previously used scripts on other OS (MacOS, Guix, PureOs and Ubuntu) that therefore need to be tested/adapted before pushed to production.

################################################

USE

To run the scripts with your OS :

1. Add the 'bin' symlink into your environment variable 'PATH'. If needed, adapt the dir to which it should redirect.

2. Set the needed environment variables by setting them in your bash profile. Refer to the content of all corresponding scripts to see if one/several of them are required.

3. Source manually your bash profile or reboot in order to source it.

################################################

IMPORTANT

Please note that :

- my current OS is Arch Linux and that some commands used in the scripts were installed manually so you maybe will need to install them by yourself or process to adaptations in order to run them.

- some scripts use environment variable that should be set into the bash profile. The later should then be sourced if not rebooting your computer.

- You should always read and understand the content of each script before to run it. Some of them use dangerous commands without checks, for example the 'rm -rf' one, combined with environment variables, which if not set, could seriously damage your OS.

################################################
