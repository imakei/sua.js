#!/bin/bash
#
# sua.js build command.
#

pushd `dirname $0` >/dev/null 2>&1
[ $? -eq 1 ] && exit 1
__script_dir=`pwd`
popd >/dev/null 2>&1


__uglify="${__script_dir}/node_modules/uglify-js/bin/uglifyjs"
__hint="${__script_dir}/node_modules/jshint/bin/jshint"
__src="${__script_dir}/sua.js"
__min="${__script_dir}/sua.min.js"

[ ! -f ${__uglify} ] && echo "error: uglify command not found. please $ npm install ." && exit 1
[ ! -f ${__hint} ] && echo "error: jshint command not found. please $ npm install ." && exit 1

#
# set version
#
./setver

#
# jshint
#
echo
echo "info: jshint start."
${__hint} ${__src}
[ $? -ne 0 ] && echo "jshint running error." && exit 1

#VERSION=`cat ${__script_dir}/package.json | grep version | cut -c 17-21`
VERSION=`node -e 'console.log(require("./sua").VERSION)'`

echo
echo "info: uglify start."
echo "/**" > ${__min}
echo " * @name sua.min.js" >> ${__min}
echo " * @version ${VERSION}" >> ${__min}
echo " * @overview Simple user agent detection library." >> ${__min}
echo " */" >> ${__min}


${__uglify} ${__src} -m -c unused=false >> ${__min}
[ $? -ne 0 ] && echo "error: uglify running error." && exit 1

echo "info: output -> ${__min}"

exit 0
