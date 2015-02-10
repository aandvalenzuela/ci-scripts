#!/bin/sh

#
# Common functionality for builds steered by Jenkins
#

die() {
  local msg="$1"
  echo "$msg"
  exit 1
}

is_linux() {
  [ x"$(uname)" = x"Linux" ]
}

is_macos() {
  [ x"$(uname)" = x"Darwin" ]
}

get_package_type() {
  which dpkg > /dev/null 2>&1 && echo "deb" && return 0
  which rpm  > /dev/null 2>&1 && echo "rpm" && return 0
  [ x"$(uname)" = x"Darwin" ] && echo "pkg" && return 0
  return 1
}

get_number_of_cpu_cores() {
  if is_linux; then
    nproc
  elif is_macos; then
    sysctl -n hw.ncpu
  else
    echo "1"
  fi
}

BUILD_PACKAGE_TYPE="$(get_package_type)"

echo
echo "Jenkins Environment"
echo "~~~~~~~~~~~~~~~~~~~"
echo "Job Name:              $JOB_NAME"
echo "Building:              $BUILD_NUMBER"
echo "Timestamp:             $(date)"
echo "Build Node:            $NODE_NAME"
echo "Labels:                $NODE_LABELS"
echo "workspace:             $WORKSPACE"
echo "Build URL:             $BUILD_URL"
echo "Job URL:               $JOB_URL"
echo "Working Dir:           $(pwd)"
echo ""
echo "System"
echo "~~~~~~"
echo "System (uname -srn):   $(uname -srn)"
echo "User:                  $(whoami)"
echo "Package Type:          $BUILD_PACKAGE_TYPE"
echo "CPU cores:             $(get_number_of_cpu_cores)"
echo
