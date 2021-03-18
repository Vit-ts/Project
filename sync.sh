#!/bin/bash
check=1

sync_upload() {
    aws s3 sync media/images/ s3://$BACKET_NAME/
}
sync_download() {
    aws s3 sync s3://$BACKET_NAME/ media/images/
}

while :
do
    sync_download

    if [ $check -eq 1 ]; then
        check=$(( $check - 1 ))
        count=`ls -l media/images/ | wc -l`
    fi
    if [ $count -ne `ls -l media/images/ | wc -l` ]; then
        sync_upload
        count=`ls -l media/images/ | wc -l`
    fi

    sleep 5

done

