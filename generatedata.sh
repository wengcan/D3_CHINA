#!/bin/sh
cd  temp/
ls|grep '.zip'|xargs -n1  unzip -O CP936
mkdir _temp 
ls|grep -v '.zip'|grep -v '_temp'|xargs -i -n1 mv `pwd`'/'{}/{} ./_temp
ls|grep -v '.zip'|grep -v '_temp'|xargs -i -n1 rm -r `pwd`'/'{}
cd _temp/
_pwd=`pwd`
for floder in `ls`  
do  
	cd $_pwd'/'$floder
	ls|grep '.json'|xargs -i rm {}
	for j in `ls|grep '.shp'`
	do
		_name=$(basename $j .shp)
		ogr2ogr  -f GeoJSON '_'$_name.json $_name.shp
		topojson -o $_name.json -- '_'$_name.json
		rm '_'$_name.json
		mv $_name.json ../../../html/json 
	done
done