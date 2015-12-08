#/bin/sh

######################################
#PURPOSE:
# 

#####################################
SCRIPTDRIVER=$1

SCRIPTOUTDIR=neo4j-cleanup
INFILEDIR=cleanup

#KEY=OPEN_DATA_50
#CORPDATAJOBNAME="42298.125;OPEN_DATA_50.xml"
#CORPMODJOBNAME="2015-11-17 Adhoc Data Load 01"
#CORPCOUNTRYFILENAME=OPEN_DATA_50-address.csv
#CORPADDRESSFILENAME=OPEN_DATA_50-address.csv
#CORPPOSTALFILENAME=OPEN_DATA_50-address.csv
#CORPFILENAME=OPEN_DATA_50-corp.csv

#DIRDATAJOBNAME="42318;opendatacanada-50.csv"
#DIRMODJOBNAME="2015-11-17 Adhoc Data Load 02"
#DIRCOUNTRYFILENAME=OPEN_DATA_50_DIR-opendatacanada-full.csv
#DIRADDRESSFILENAME=OPEN_DATA_50_DIR-opendatacanada-full.csv
#DIRPOSTALFILENAME=OPEN_DATA_50_DIR-opendatacanada-full.csv
#DIRNAMEFILENAME=OPEN_DATA_50_DIR-opendatacanada-full.csv

if [ -f $SCRIPTDIVER ];

source $SCRIPTDRIVER

else
echo "No Script Driver found: $SCRIPTDRIVER"

fi

ROOTDIR=/home/rlytle/data/scrape/can_fed_corp_info
TEMPLATEDIR=/home/rlytle/data/support/neo4j-templates
DATARECEIVEDFILENAME=/home/rlytle/data/support/data-received-jobs.csv
OUTDIR=$ROOTDIR/$KEY/$SCRIPTOUTDIR

echo "Making $OUTDIR"
mkdir -p $OUTDIR

######################### SETUP ###########################
echo "Processing setup files"
export DATARECEIVEDFILE=$DATARECEIVEDFILENAME
# load any new data received entries
# expects DATARECEIVEDFILE
$TEMPLATEDIR/data-received.sh $OUTDIR/000_data-received.neo

export DATAJOB=$CORPDATAJOBNAME
export MODJOB=$CORPMODJOBNAME

# expects DATAJOB, MODJOB
$TEMPLATEDIR/modjob.sh $OUTDIR/005_corp-modjob.neo


######################## CORP #########################

echo "Processing CORP file set"

export COUNTRYFILE=$ROOTDIR/$KEY/$INFILEDIR/$CORPCOUNTRYFILENAME
export ADDRESSFILE=$ROOTDIR/$KEY/$INFILEDIR/$CORPADDRESSFILENAME
export POSTALFILE=$ROOTDIR/$KEY/$INFILEDIR/$CORPPOSTALFILENAME
export CORPFILE=$ROOTDIR/$KEY/$INFILEDIR/$CORPFILENAME




# check counts of new locations from files
export SANITYFILE=$COUNTRYFILE
#$TEMPLATEDIR/sanity-location.sh $OUTDIR/006_sanity-location-corp-country.neo


# create countries and provinces
# expects COUNTRYFILE
#$TEMPLATEDIR/country-province.sh $OUTDIR/010_corp-country-province.neo

# link countries and provinces
# expects COUNTRYFILE
#$TEMPLATEDIR/link-country-province.sh $OUTDIR/015_corp-link-country-province.neo

export SANITYFILE=$ADDRESSFILE
#$TEMPLATEDIR/sanity-location.sh $OUTDIR/016_sanity-location-corp-address.neo



# link city and provinces
# expects ADDRESSFILE
#$TEMPLATEDIR/city-province.sh $OUTDIR/020_corp-city-province.neo

# city and postal
# expects ADDRESSFILE
#$TEMPLATEDIR/city-postal.sh $OUTDIR/025_corp-city-postal.neo

export SANITYFILE=$POSTALFILE
#$TEMPLATEDIR/sanity-location.sh $OUTDIR/026_sanity-location-corp-postal.neo


# link postal and group
# expects POSTALFILE
#$TEMPLATEDIR/postalgroup.sh $OUTDIR/030_corp-postalgroup.neo

export SANITYFILE=$CORPFILE
#$TEMPLATEDIR/sanity-id-corps.sh $OUTDIR/031_sanity-id-corps.neo

# create id and corp
# expects CORPFILE, MODJOB
#$TEMPLATEDIR/id-corps.sh $OUTDIR/035_corp-id-corps.neo

export SANITYFILE=$ADDRESSFILE
#$TEMPLATEDIR/sanity-corp-name-address.sh $OUTDIR/036_sanity-corp-name-address.neo


# create corp names
# expects ADDRESSFILE, MODJOB
#$TEMPLATEDIR/corp-names.sh $OUTDIR/040_corp-names.neo

# create corp addresses
# expects ADDRESSFILE, MODJOB
#$TEMPLATEDIR/corp-address.sh $OUTDIR/045_corp-address.neo

########################## DIR type 1 ##########################

export DATAJOB=$DIRDATAJOBNAME
export MODJOB=$DIRMODJOBNAME

export COUNTRYFILE=$ROOTDIR/$KEY/$INFILEDIR/$DIRCOUNTRYFILENAME
export ADDRESSFILE=$ROOTDIR/$KEY/$INFILEDIR/$DIRADDRESSFILENAME
export POSTALFILE=$ROOTDIR/$KEY/$INFILEDIR/$DIRPOSTALFILENAME
export DIRNAMEFILE=$ROOTDIR/$KEY/$INFILEDIR/$DIRNAMEFILENAME

# check counts of new locations from files

echo "Processing DIR file set"
# create modjob for dir file
# expects DATAJOB, MODJOB
#$TEMPLATEDIR/modjob.sh $OUTDIR/050_dir-modjob.neo


export SANITYFILE=$COUNTRYFILE
#$TEMPLATEDIR/sanity-location.sh $OUTDIR/051_sanity-location-dir-country.neo


# create countries and provinces
# expects COUNTRYFILE
#$TEMPLATEDIR/country-province.sh $OUTDIR/055_dir-country-province.neo

# link countries and provinces
# expects COUNTRYFILE
#$TEMPLATEDIR/link-country-province.sh $OUTDIR/060_dir-link-country-province.neo


export SANITYFILE=$ADDRESSFILE
#$TEMPLATEDIR/sanity-location.sh $OUTDIR/061_sanity-location-dir-address.neo


# link city and provinces
# expects ADDRESSFILE
#$TEMPLATEDIR/city-province.sh $OUTDIR/065_dir-city-province.neo

# city and postal
# expects ADDRESSFILE
#$TEMPLATEDIR/city-postal.sh $OUTDIR/070_dir-city-postal.neo

export SANITYFILE=$POSTALFILE
#$TEMPLATEDIR/sanity-location.sh $OUTDIR/071_sanity-location-dir-postal.neo



# link postal and group
# expects POSTALFILE
#$TEMPLATEDIR/postalgroup.sh $OUTDIR/075_dir-postalgroup.neo


export SANITYFILE=$DIRNAMEFILE
#$TEMPLATEDIR/sanity-dir-name-address.sh $OUTDIR/076_sanity-dir-name_address.neo


# create and link dirs to corps
# expects DIRNAMEFILE, MODJOB
#$TEMPLATEDIR/dir-name-corp.sh $OUTDIR/080_dir-name-corp.neo

# create and link addresses to dirs 
# expects DIRNAMEFILE, MODJOB
#$TEMPLATEDIR/dir-name-address.sh $OUTDIR/085_dir-name-address.neo

########################## DIR type 2 ##########################

export DATAJOB=$DIR2DATAJOBNAME
export MODJOB=$DIR2MODJOBNAME

if [ "$DIR2DATAJOBNAME" != "" ]
then
echo "Processing second DIR file set"


export COUNTRYFILE=$ROOTDIR/$KEY/$INFILEDIR/$DIR2COUNTRYFILENAME
export ADDRESSFILE=$ROOTDIR/$KEY/$INFILEDIR/$DIR2ADDRESSFILENAME
export POSTALFILE=$ROOTDIR/$KEY/$INFILEDIR/$DIR2POSTALFILENAME
export DIRNAMEFILE=$ROOTDIR/$KEY/$INFILEDIR/$DIR2NAMEFILENAME


# check counts of new locations from files


# create modjob for dir file
# expects DATAJOB, MODJOB
$TEMPLATEDIR/modjob.sh $OUTDIR/090_dir-modjob.neo

export SANITYFILE=$COUNTRYFILE
$TEMPLATEDIR/sanity-location.sh $OUTDIR/091_sanity-location-dir2-country.neo


# create countries and provinces
# expects COUNTRYFILE
$TEMPLATEDIR/country-province.sh $OUTDIR/095_dir2-country-province.neo

# link countries and provinces
# expects COUNTRYFILE
$TEMPLATEDIR/link-country-province.sh $OUTDIR/100_dir2-link-country-province.neo

export SANITYFILE=$ADDRESSFILE
$TEMPLATEDIR/sanity-location.sh $OUTDIR/101_sanity-location-dir2-address.neo


# link city and provinces
# expects ADDRESSFILE
$TEMPLATEDIR/city-province.sh $OUTDIR/105_dir2-city-province.neo

# city and postal
# expects ADDRESSFILE
$TEMPLATEDIR/city-postal.sh $OUTDIR/110_dir2-city-postal.neo


export SANITYFILE=$POSTALFILE
$TEMPLATEDIR/sanity-location.sh $OUTDIR/111_sanity-location-dir2-postal.neo


# link postal and group
# expects POSTALFILE
$TEMPLATEDIR/postalgroup.sh $OUTDIR/115_dir2-postalgroup.neo

export SANITYFILE=$DIRNAMEFILE
$TEMPLATEDIR/sanity-dir-name-address.sh $OUTDIR/116_sanity-dir2-name_address.neo


# create and link dirs to corps
# expects DIRNAMEFILE, MODJOB
$TEMPLATEDIR/dir-name-corp.sh $OUTDIR/120_dir2-name-corp.neo

# create and link addresses to dirs 
# expects DIRNAMEFILE, MODJOB
$TEMPLATEDIR/dir-name-address.sh $OUTDIR/125_dir2-name-address.neo

fi


