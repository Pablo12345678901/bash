#!/usr/bin/env bash

source fonctions_personnelles

# TEST ARGUMENT
URL_GIT_REPO="https://aur.archlinux.org/linux-mainline.git/"

###### TEST END  ##########






URL_GIT_REPO="${URL_GIT_REPO%/}" # remove eventual '/' at the end of url
# Get repo name
NEW_GIT_REPO="${URL_GIT_REPO##*/}" # remove all url except basename
NEW_GIT_REPO="${NEW_GIT_REPO%\.git}" # remove the '.git' at the end of url


OLDPWD="$PWD"
pwd # debug
cd "$REPERTOIRE_BUILDS_ARCHLINUX"
pwd # debug

# Creation of new git repo if not existing yet
if [ ! -d "./${NEW_GIT_REPO}" ]
then
    git clone "$URL_GIT_REPO"
fi

cd "$NEW_GIT_REPO"
pwd # debug

# Test if PKGBUILD file exists in folder
find -maxdepth 1 -mindepth 1 -name "PKGBUILD" >/dev/null 2>&1
echo $?
if (($?))
then
    STDERR_afficher_message "\nERROR : the git repo \"$NEW_GIT_REPO\" located \"$PWD\" has no PKGBUILD file. Check it manually...\n"
    cd "$OLDPWD"
    exit 1
fi

# Show PKGBUILD file with less

# List other file with choice to read them with less or follow on
# with a select loop

# Then installation




cd "$OLDPWD"
pwd # debug

exit 0
###########




: <<"DEV"






# Get builds directories into an array
declare -a ARRAY_BUILDS_DIR
while read REPERTOIRE_A_METTRE_A_JOUR
do
    ARRAY_BUILDS_DIR+=("$REPERTOIRE_A_METTRE_A_JOUR")
done < <(find "$REPERTOIRE_BUILDS_ARCHLINUX" -maxdepth 1 -mindepth 1 -type d -print0 |
	     tr '\0' '\n')

declare -a ARRAY_BUILDS_ERROR

# Update all builds directories
for REPERTOIRE in "${ARRAY_BUILDS_DIR[@]}"
do
  OLDPWD="$PWD"
  PACKAGE_BASENAME="${REPERTOIRE##*/}"
  cd "$REPERTOIRE"
  # Check if git directory is up to date
  DIRECTORY_STATUS="$(git pull 2>&1)"
  STATUS=$?
  if [ "$DIRECTORY_STATUS" = "Already up to date." ]
  then
      echo "The package \"$PACKAGE_BASENAME\" located \"$REPERTOIRE\" is already up to date."
  else
      echo "$DIRECTORY_STATUS"
  { [ $STATUS ]  && 
  makepkg -s -i -r -c && 
  git clean -dfx  &&
  echo -e "\nThe package \"$PACKAGE_BASENAME\" located \"$REPERTOIRE\" was correctly updated\n"
  } ||
  { STDERR_afficher_message "\nERROR : the package \"$PACKAGE_BASENAME\" located \"$REPERTOIRE\" could not be updated. Do it manually.\n" &&
    ARRAY_BUILDS_ERROR+=("$PACKAGE_BASENAME")
  } # conservation of builds errors to show at the end 
 fi 
 cd "$OLDPWD"
done

# Showing the update results
if [ "$(tableau_taille ARRAY_BUILDS_ERROR)" != "0" ]
then
    STDERR_afficher_message "\nERROR : issue with the build(s) below :\n\n$(tableau_contenu ARRAY_BUILDS_ERROR)\n\nCheck the above output...\n"
    exit 1
else
    echo -e "\nAll builds were well performed!\n"
    exit 0
fi

DEV
