#!/bin/sh
if [ ! -f `pwd`"/subunits.json" ]; then
   rm ./subunits.json
fi
if [ ! -f `pwd`"/places.json" ]; then
   rm ./places.json
fi
cd ne_10m_admin_1_states_provinces
ogr2ogr\
   -f GeoJSON\
   -where "ADM0_A3 IN ('CHN', 'TWN','HKG','MAC')"\
   subunits.json\
   ne_10m_admin_1_states_provinces.shp
mv subunits.json ../
echo '==> Generated subunits.json'
cd ../
cd ne_10m_populated_places
ogr2ogr\
   -f GeoJSON\
   -where "ISO_A2 IN ('CN','TW','HK','MO') AND SCALERANK < 4"\
   places.json\
   ne_10m_populated_places.shp
mv places.json ../
echo '==> Generated places.json'
cd ../
topojson\
   -o china.json\
   --id-property SU_A3\
   --properties name=NAME\
   --   subunits.json\
   places.json



