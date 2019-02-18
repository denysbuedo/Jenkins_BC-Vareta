#!/bin/bash
file="/var/lib/jenkins/jobs/"$1"/builds/QueueJobs/#"$2".xml"
echo '<Data job="'$1'" build="'$2'" name="'$3'" email="'$4'" EEG="'$5'" LeadField="'$6'" Surface="'$7'" Scalp="'$8'"></Data>' >> $file
file="/var/lib/jenkins/jobs/$1/builds/$2/fileParameters/data.txt"
echo $5 $6 $7 $8 >> $file
mv /var/lib/jenkins/jobs/$1/builds/$2/fileParameters/EEG /var/lib/jenkins/jobs/$1/builds/$2/fileParameters/$5
mv /var/lib/jenkins/jobs/$1/builds/$2/fileParameters/LeadField /var/lib/jenkins/jobs/$1/builds/$2/fileParameters/$6
mv /var/lib/jenkins/jobs/$1/builds/$2/fileParameters/Surface /var/lib/jenkins/jobs/$1/builds/$2/fileParameters/$7
mv /var/lib/jenkins/jobs/$1/builds/$2/fileParameters/Scalp /var/lib/jenkins/jobs/$1/builds/$2/fileParameters/$8

