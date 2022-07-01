#!/bin/sh

while read -r URL;
do
    host=$(echo $URL | ./unfurl format %d)
    ./gospider --site $URL --other-source --include-other-source --depth 3 --user-agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0.3 Safari/605.1.15" --quiet --robots --sitemap | grep -Eiv '\.(css|jpg|jpeg|png|svg|img|gif|mp4|flv|ogv|webm|webp|mov|mp3|m4a|m4p|ppt|pptx|scss|tif|tiff|ttf|otf|woff|woff2|bmp|ico|eot|htc|swf|rtf|image)'
done