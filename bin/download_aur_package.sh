#!/usr/bin/env bash

source fonctions_personnelles

: <<"DEVID"
function ask_user_if_agree_to_continue {
# Ask if satisfied to continue
USER_ANSWER=""
QUESTION_YES_NO="Do you agree to continue the script
(Yy/Nn) ? "
question_oui_non USER_ANSWER "$QUESTION_YES_NO"
if [ "$USER_ANSWER" = "n" ]
then
    echo -e "\nYou choosed to stop the script.\n"
    exit 0
fi
}
DEVID

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

# Show PKGBUILD file with less - if wished by user
USER_ANSWER=""
QUESTION_YES_NO="Would you like to check the content of the 'PKGBUILD' file
(Yy/Nn) ? "
question_oui_non USER_ANSWER "$QUESTION_YES_NO"
if [ "$USER_ANSWER" = "o" ]
then
    less "$PATH_PKGBUILD"
fi

ask_user_if_agree_to_continue

# List other file in new git dir with select loop : choice to read them with 'less' or to continue
declare -a ARRAY_OPTIONS
pwd
USER_CHOICE=""
MESSAGE_FOR_USER="Which other file would you like to check the content
?"
STOP_OPTION="Pursue with build and installation"
select_parmi_liste ARRAY_OPTIONS USER_CHOICE "$MESSAGE_FOR_USER" "$STOP_OPTION"
# $1 : TAB_D_OPTIONS (variable)
# $2 : CH_UTILISATEUR (variable)
# $3 : MES_AFFICHE (valeur) -> avant d'afficher les choix
# $4 : OPT_POUR_ARRETER (optionnel) (valeur)

ask_user_if_agree_to_continue

exit 5

# Then package build and installation
echo -e "\nBuild and installation...\n"
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
