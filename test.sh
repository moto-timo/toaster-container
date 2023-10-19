GITREPO="git://git.yoctoproject.org/poky"
#GITREPO="git://git.yoctoproject.org/poky-contrib"
BRANCH="dunfell"
#BRANCH="timo/toaster-fixtures"
REPO="crops/toaster-${BRANCH}"
#IMAGE="crops/timo/toaster-updates"
TOASTERIP=0.0.0.0
TOASTERPORT=18000:8000
#docker build --build-arg GITREPO="${GITREPO}" --build-arg BRANCH="${BRANCH}" -t ${REPO} .
bash -c "cd tests; SELENIUM_TIMEOUT=1800 IMAGE=${REPO} SHOW_LOGS_ON_FAILURE=1 TOASTERIP=${TOASTERIP} TOASTERPORT=${TOASTERPORT} ./runtests.sh"
docker ps | awk "/crops\/toaster-${BRANCH}/ {print $1}" | xargs docker stop
docker ps | awk '/selenium/ {print $1}' | xargs docker stop
