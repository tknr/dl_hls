#!/bin/bash
export IFS=$'\n'
DIR=$(cd $(dirname $0); pwd)
cd $DIR
CMDNAME=`basename $0`
FILENAME_QUEUE="queue_hls.txt"
if [ $# -ne 0 ]; then
    ${FILENAME_QUEUE}=${1}
fi
echo "reading from "${FILENAME_QUEUE}"..."

for LINE in `cat ${FILENAME_QUEUE} | grep -v "^#"`
do
	echo ${LINE}

	TITLE=`echo ${LINE} | cut -d "," -f 1`
	URL=`echo ${LINE} | cut -d "," -f 2`

	echo ${TITLE}
	echo ${URL}

	ffmpeg -y -i "${URL}" "${TITLE}.mp4" \
	|| continue
	sed -i -e "s|${TITLE}|#${TITLE}|g" ${FILENAME_QUEUE}
done
