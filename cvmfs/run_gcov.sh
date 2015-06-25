#/bin/sh


#
# This script builds cvmfs_unittest_debug runs the gcov and reports the test coverage status.
# It stores the final result in $CVMFS_
#

set -e

BUILD_SCRIPT_LOCATION=$(cd "$(dirname "$0")"; pwd)
. ${BUILD_SCRIPT_LOCATION}/../jenkins/common.sh
. ${BUILD_SCRIPT_LOCATION}/common.sh

# sanity checks
[ ! -z $CVMFS_BUILD_LOCATION  ] || die "CVMFS_BUILD_LOCATION missing"
[ ! -z $CVMFS_SOURCE_LOCATION ] || die "CVMFS_SOURCE_LOCATION missing"
[ ! -z $CVMFS_BUILD_CLEAN     ] || die "CVMFS_BUILD_CLEAN missing"

CVMFS_XML_FILE="$CVMFS_BUILD_LOCATION/unittest.xml"

# setup a fresh build workspace on first execution or on request
if [ ! -d "$CVMFS_BUILD_LOCATION" ] || [ x"$CVMFS_BUILD_CLEAN" = x"true" ]; then
  rm -fR "$CVMFS_BUILD_LOCATION"
  mkdir -p "$CVMFS_BUILD_LOCATION"
fi

# run the build
echo "switching to ${CVMFS_BUILD_LOCATION} and invoking build script..."
cd "${CVMFS_BUILD_LOCATION}"
cmake -DBUILD_UNITTESTS_DEBUG=yes ${CVMFS_SOURCE_LOCATION}
make -j 4

# run cvmfs_unittest_debug (all tests always)
echo "Running the tests (with XML output ${CVMFS_XML_FILE})"
${CVMFS_BUILD_LOCATION}/test/unittests/cvmfs_unittests_debug \
                                          --gtest_shuffle    \
                                          --gtest_output=xml:$CVMFS_XML_FILE

# create the directories
rm -rf html && mkdir html
rm -rf xml && mkdir xml

# run gcovr to get the html
gcovr --object-directory=${CVMFS_BUILD_LOCATION}/test/unittests/CMakeFiles/cvmfs_unittests_debug.dir/    \
      --root=${CVMFS_SOURCE_LOCATION}/.. --branches --gcov-filter=".*cvmfs#cvmfs.*" --print-summary      \
      --html --html-detail --output=html/coverage.html

# run gcovr to get the xml
gcovr --object-directory=${CVMFS_BUILD_LOCATION}/test/unittests/CMakeFiles/cvmfs_unittests_debug.dir/    \
      --root=${CVMFS_SOURCE_LOCATION}/.. --branches --gcov-filter=".*cvmfs#cvmfs.*" --print-summary      \
      --xml --xml-pretty --output=xml/coverage.xml

