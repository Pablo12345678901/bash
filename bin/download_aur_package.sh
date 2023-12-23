#!/usr/bin/env bash

source fonctions_personnelles

# ARGUMENT TEST
URL_GIT_REPO="https://aur.archlinux.org/linux-mainline.git"

###### TEST END  ##########


URL_GIT_REPO="${URL_GIT_REPO%/}" # remove eventual '/' at the end of url
# Get repo name
NEW_GIT_REPO="${URL_GIT_REPO##*/}" # remove all url except basename
NEW_GIT_REPO="${NEW_GIT_REPO%\.git}" # remove the '.git' at the end of url
PACKAGE_BASENAME="$NEW_GIT_REPO"

LOCATION_AT_SCRIPT_BEGINNING="$PWD"

echo "DEBUG : $PWD" # debug

cd "$REPERTOIRE_BUILDS_ARCHLINUX"

# Creation of new git repo if not existing yet
if [ ! -d "./${NEW_GIT_REPO}" ]
then
    # Creation of new git dir and error check
    { git clone "$URL_GIT_REPO" &&
    echo -e "\nNew repo created : \"$NEW_GIT_REPO\" located \"${PWD}/${NEW_GIT_REPO}\"\n"
    } ||
    { STDERR_afficher_message "\nERROR : the git repo could not be created. Do it manually...\n"
    cd "$LOCATION_AT_SCRIPT_BEGINNING"
    exit 1
    }
fi

cd "$NEW_GIT_REPO"

echo "DEBUG : $PWD" # debug

# Test if PKGBUILD file exists in folder
PATH_PKGBUILD="$(find -maxdepth 1 -mindepth 1 -name "PKGBUILD")"

if [ -z "$PATH_PKGBUILD" ]
then
    STDERR_afficher_message "\nERROR : the git repo \"$NEW_GIT_REPO\" located \"$PWD\" has no 'PKGBUILD' file. Check it manually...\n"
    cd "$LOCATION_AT_SCRIPT_BEGINNING"
    exit 1
fi

# Show PKGBUILD file with less
echo "Would you like to check the content of the 'PKGBUILD' file
?"
if [ 1 -eq 1 ]
then
    less "$PATH_PKGBUILD"
fi

##############################
echo "DEBUG EXIT DEV"
exit 5
##############################

# List other file with choice to read them with less or follow on
# with a select loop




# Then installation
{ git pull  && 
  makepkg -s -i -r -c && 
  git clean -dfx
} ||
{ STDERR_afficher_message "\nERROR : the package \"$PACKAGE_BASENAME\" located \"$REPERTOIRE\" could not be built. Do it manually.\n"
    cd "$LOCATION_AT_SCRIPT_BEGINNING"
    exit 1
}
  
# If no build error so showing confirmation message
echo -e "\nThe package \"$PACKAGE_BASENAME\" located \"$REPERTOIRE\" was correctly built\n"
cd "$LOCATION_AT_SCRIPT_BEGINNING"

echo "DEBUG : $PWD"

exit 0
