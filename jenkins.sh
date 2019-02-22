#!/bin/bash
if [[ $1 = 'run' ]];
  then
      /usr/local/MATLAB/R2018a/bin/matlab -nodisplay < /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/Main.m
  elif [[ $1 = 'delivery' ]];
    then
      tar fcz /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/$2.tar.gz --absolute-names /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/results/
      rm -f /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/data/run/$3
      rm -f /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/data/run/$4
      rm -f /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/data/run/$5
      rm -f /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/data/run/$6
      rm -f /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/data/run/data.txt
      if [ -d "/media/DATA/FTP/Matlab/BC-Vareta/$2" ]
       then
	   mv /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/$2.tar.gz /media/DATA/FTP/Matlab/BC-Vareta/$2
       else
           mkdir /media/DATA/FTP/Matlab/BC-Vareta/$2
           mv /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/$2.tar.gz /media/DATA/FTP/Matlab/BC-Vareta/$2
       fi
    else
      echo "Invalid action"
  fi