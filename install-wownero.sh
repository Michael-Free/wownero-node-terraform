#!/bin/bash
WOWNERO_DEB_URL=https://git.wownero.com/attachments/e9e6fa73-9e3a-4391-af04-64fba8cc6d9e
WOWNERO_DEB_FILE=wownero.deb
WOWNERO_SVC_FILE=wownero.service
WOWNERO_CONFIG_FILE=wownero.conf

check_root() {
   if [[ $EUID -ne 0 ]];
      then
        return 1
      else
        return 0
      fi
}

check_os() {
   lsb_release -d | awk -F"\t" '{print $2}'
}

check_config() {
   if curl -J -L $WOWNERO_DEB_URL --output $WOWNERO_DEB_FILE;
   then
      echo "success!"
      return 0
   else
      echo "bad downloaD"
      return 1
   fi
}

check_vars() {
   if [ -f $WOWNERO_DEB_FILE ];
   then
      if [ -f "$WOWNERO_SVC_FILE" ];
      then
         echo "it works"
         return 0
      else
         echo "ERROR-03 FILE ERROR - No $WOWNERO_SVC_FILE Found"
         return 1
      fi
   else
      echo "ERROR-03 FILE NOT FOUND - $WOWNERO_DEB_FILE"
      return 1
   fi
}
install_req(){
   # Update APT sources
   if apt update;
   then
      # install tor file!
      if apt install tor -y;
      then
         echo "itworks"
         return 0
      else
         echo "ERROR-04 - INSTALL REQUIREMENTS - TOR PACKAGE INSTALL FAILED"
         return 1
      fi
   else
      echo "ERROR-04 - INSTALL REQUIREMENTS - UPDATE APT SOURCES FAILED"
      return 1
   fi
}

install_deb() {
   if dpkg -i "$WOWNERO_DEB_FILE";
   then
      if cat "$WOWNERO_CONFIG_FILE" > "/root/$WOWNERO_CONFIG_FILE";
      then
         echo "its working"
         return 0
      else
         echo "ERROR-05 - COPY OF $WOWNERO_CONFIG_FILE TO ROOT DIR FAILED"
         return 1
      fi
   else
      echo "ERROR-05 - INSTALL OF $WOWNERO_DEB_FILE FAILED"
      return 1
   fi
}
install_svc() {
   if cat "$WOWNERO_SVC_FILE" > "/etc/systemd/system/$WOWNERO_SVC_FILE";
   then
      # reload systemd services
      if systemctl daemon-reload;
      then
         #start service
         if systemctl start wownero.service;
         then
            # enable the wownero service on reboot
            if systemctl enable wownero.service;
            then
               return 0
            else
               echo "ERROR-06 - COULDN'T ENABLE WOWNERO SERVICE"
               return 1
            fi
         else
            echo "ERROR-06 - COULDN'T START WOWNERO SERVICE"
            return 1
         fi
      else
         echo "ERROR-06 - COULD NOT RELOAD SYSTTEMCTL DAEMON"
         return 1
      fi
   else
      echo "ERROR-06 - COPY OF $WOWNERO_SVC_FILE FILE FAILED TO /etc/systemd/system/"
      return 1
   fi
}

# i should be using case statements - but if statements for now!
# just wanted to get the functions working properly
# Check if we're root
if check_root;
then
   # Check if the OS is correct
   if check_os | grep -q 'Ubuntu 20.04.2 LTS';
   then
      # Check if there's a config file
      if check_config;
      then
         # Check file variables
         if check_vars;
         then
            # install system requriements
            if install_req;
            then
               if install_deb;
               then
               # create wownero service
                  if install_svc;
                  then
                     echo "wegood"
                     exit 0
                  else
                    exit 1
                  fi
               else
                 exit 1
               fi
            else
               exit 1
            fi
         else
            echo "ERROR-03 - CONFIG FILE"
            exit 1
         fi
      else
         echo "ERROR-02 NO CONFIG FILE!"
         exit 1
      fi
   else
      echo "ERROR-01 WRONG OS!"
      exit 1
   fi
else
   echo "ERROR-00 NOT ROOT!"
   exit 1
fi
