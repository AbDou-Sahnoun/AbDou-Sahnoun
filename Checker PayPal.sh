#!/bin/bash

NC='\033[0m'
GREEN='\e[38;5;82m'
CYAN='\e[38;5;45m'
RED='\e[38;5;196m'
echo ""
printf "\n";		
printf	"\e[38;5;82m	 ____  _   _ _  _   _   _ ______   __		\n"		
printf	"\e[38;5;82m	|  _ \| | | | || | | \ | |  _ \ \ / /		\n"		
printf	"\e[38;5;82m	| | | | |_| | || |_|  \| | | | \ V /		\n"		
printf	"\e[38;5;82m	| |_| |  _  |__   _| |\  | |_| || |			\n"		
printf	"\e[38;5;82m	|____/|_| |_|  |_| |_| \_|____/ |_|			\n"		
printf "==============================================\n"
printf "${NC}         PayPal Valid V21              \n"
printf "${RED}==============================================${NC}\n\n"

usage() { 
  echo "Usage: ./myscript.sh COMMANDS: [-i <list.txt>] [-r <folder/>] [-l {1-1000}] [-t {1-10}] OPTIONS: [-d] [-c]

Command:
-i (20k-US.txt)     File input that contain email to check
-r (result/)        Folder to store the result live.txt and die.txt
-l (60|90|110)      How many list you want to send per delayTime
-t (3|5|8)          Sleep for -t when check is reach -l fold

Options:
-d                  Delete the list from input file per check
-c                  Compress result to compressed/ folder and
                    move result folder to haschecked/
-h                  Show this manual to screen

Report any bugs to: dh44ndy@gmail.com
"
  exit 1 
}

# Assign the arguments for each
# parameter to global variable
while getopts ":i:r:l:t:dchu" o; do
    case "${o}" in
        i)
            inputFile=${OPTARG}
            ;;
        r)
            targetFolder=${OPTARG}
            ;;
        l)
            sendList=${OPTARG}
            ;;
        t)
            perSec=${OPTARG}
            ;;
        d)
            isDel='y'
            ;;
        c)
            isCompress='y'
            ;;
        h)
            usage
            ;;
        u)
            updater
            ;;
    esac
done

if [[ $inputFile == '' || $targetFolder == '' || $sendList == '' || $perSec == '' ]]; then
  cli_mode="interactive"
else
  cli_mode="interpreter"
fi

# Assign false value boolean
# to both options when its null
if [ -z "${isDel}" ]; then
  isDel='n'
fi

if [ -z "${isCompress}" ]; then
  isCompress='n'
fi

SECONDS=0

# Asking user whenever the
# parameter is blank or null
if [[ $inputFile == '' ]]; then
  # Print available file on
  # current folder
  # clear
  tree
  read -p "Enter mailist file: " inputFile
fi

if [[ $targetFolder == '' ]]; then
  read -p "Enter target folder: " targetFolder
  # Check if result folder exists
  # then create if it didn't
  if [[ ! -d "$targetFolder" ]]; then
    echo "[+] Creating $targetFolder/ folder"
    mkdir $targetFolder
  else
    read -p "$targetFolder/ folder are exists, append to them ? [y/n]: " isAppend
    if [[ $isAppend == 'n' ]]; then
      exit
    fi
  fi
else
  if [[ ! -d "$targetFolder" ]]; then
    echo "[+] Creating $targetFolder/ folder"
    mkdir $targetFolder
  fi
fi

if [[ $isDel == '' || $cli_mode == 'interactive' ]]; then
  read -p "Delete list per check ? [y/n]: " isDel
fi

if [[ $isCompress == '' || $cli_mode == 'interactive' ]]; then
  read -p "Compress the result ? [y/n]: " isCompress
fi

if [[ $sendList == '' ]]; then
  read -p "How many list send: " sendList
fi

if [[ $perSec == '' ]]; then
  read -p "Delay time: " perSec
fi


urlencode() {
    # urlencode <string>

    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%s' "$c" | xxd -p -c1 |
                   while read c; do printf '%%%s' "$c"; done ;;
        esac
    done
}


dh4ndy_request() {
  RED='\033[0;31m'
  CYAN='\033[0;36m'
  YELLOW='\033[1;33m'
  ORANGE='\033[0;33m' 
  PURPLE='\033[0;35m'
  NC='\033[0m'
  SECONDS=0
  useragent=('Mozilla/5.0 (Windows NT 6.0) AppleWebKit/5362 (KHTML, like Gecko) Chrome/14.0.848.0 Safari/5362' 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0; Trident/5.0)' 'Opera/8.77 (Windows NT 6.0; U; en-US) Presto/2.9.179 Version/10.00' 'Mozilla/5.0 (Windows NT 5.1; en-US; rv:1.9.0.20) Gecko/20130614 Firefox/3.6.8' 'Mozilla/5.0 (Windows NT 6.0; en-US; rv:1.9.0.20) Gecko/20141216 Firefox/7.0' 'Mozilla/5.0 (compatible; MSIE 7.0; Windows NT 5.0; Trident/5.1)' 'Mozilla/5.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/5.1)' 'Mozilla/5.0 (compatible; MSIE 7.0; Windows NT 5.0; Trident/4.1)' 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/5350 (KHTML, like Gecko) Chrome/15.0.827.0 Safari/5350' 'Mozilla/5.0 (Windows NT 5.0; en-US; rv:1.9.2.20) Gecko/20110914 Firefox/5.0.1' 'Mozilla/5.0 (Windows NT 6.0) AppleWebKit/5311 (KHTML, like Gecko) Chrome/13.0.808.0 Safari/5311' 'Mozilla/5.0 (compatible; MSIE 8.0; Windows NT 5.0; Trident/4.1)' 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/5352 (KHTML, like Gecko) Chrome/15.0.874.0 Safari/5352' 'Mozilla/5.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/3.0)' 'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.0; Trident/4.0)' 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/5361 (KHTML, like Gecko) Chrome/13.0.833.0 Safari/5361' 'Mozilla/5.0 (Windows NT 6.1; en-US; rv:1.9.0.20) Gecko/20120410 Firefox/3.8')
  declare -A countryCodeList=( [AF]="Afghanistan" [AX]="Aland Islands" [AL]="Albania" [DZ]="Algeria" [AS]="American Samoa" [AD]="Andorra" [AO]="Angola" [AI]="Anguilla" [AQ]="Antarctica" [AG]="Antigua and Barbuda" [AR]="Argentina" [AM]="Armenia" [AW]="Aruba" [AU]="Australia" [AT]="Austria" [AZ]="Azerbaijan" [BS]="Bahamas" [BH]="Bahrain" [BD]="Bangladesh" [BB]="Barbados" [BY]="Belarus" [BE]="Belgium" [BZ]="Belize" [BJ]="Benin" [BM]="Bermuda" [BT]="Bhutan" [BO]="Bolivia, Plurinational State of" [BQ]="Bonaire, Sint Eustatius and Saba" [BA]="Bosnia and Herzegovina" [BW]="Botswana" [BV]="Bouvet Island" [BR]="Brazil" [IO]="British Indian Ocean Territory" [BN]="Brunei Darussalam" [BG]="Bulgaria" [BF]="Burkina Faso" [BI]="Burundi" [KH]="Cambodia" [CM]="Cameroon" [CA]="Canada" [CV]="Cape Verde" [KY]="Cayman Islands" [CF]="Central African Republic" [TD]="Chad" [CL]="Chile" [CN]="China Domestic" [C2]="China International" [CX]="Christmas Island" [CC]="Cocos (Keeling) Islands" [CO]="Colombia" [KM]="Comoros" [CG]="Congo" [CD]="Congo, The Democratic Republic of the" [CK]="Cook Islands" [CR]="Costa Rica" [CI]="Cote d'Ivoire" [HR]="Croatia" [CU]="Cuba" [CW]="Curacao" [CY]="Cyprus" [CZ]="Czech Republic" [DK]="Denmark" [DJ]="Djibouti" [DM]="Dominica" [DO]="Dominican Republic" [EC]="Ecuador" [EG]="Egypt" [SV]="El Salvador" [GQ]="Equatorial Guinea" [ER]="Eritrea" [EE]="Estonia" [ET]="Ethiopia" [FK]="Falkland Islands (Malvinas)" [FO]="Faroe Islands" [FJ]="Fiji" [FI]="Finland" [FR]="France" [GF]="French Guiana" [PF]="French Polynesia" [TF]="French Southern Territories" [GA]="Gabon" [GM]="Gambia" [GE]="Georgia" [DE]="Germany" [GH]="Ghana" [GI]="Gibraltar" [GR]="Greece" [GL]="Greenland" [GD]="Grenada" [GP]="Guadeloupe" [GU]="Guam" [GT]="Guatemala" [GG]="Guernsey" [GN]="Guinea" [GW]="Guinea-Bissau" [GY]="Guyana" [HT]="Haiti" [HM]="Heard Island and McDonald Islands" [VA]="Holy See (Vatican City State)" [HN]="Honduras" [HK]="Hong Kong" [HU]="Hungary" [IS]="Iceland" [IN]="India" [ID]="Indonesia" [IR]="Iran, Islamic Republic of" [IQ]="Iraq" [IE]="Ireland" [IM]="Isle of Man" [IL]="Israel" [IT]="Italy" [JM]="Jamaica" [JP]="Japan" [JE]="Jersey" [JO]="Jordan" [KZ]="Kazakhstan" [KE]="Kenya" [KI]="Kiribati" [KP]="Korea, Democratic People's Republic of" [KR]="Korea, Republic of" [KW]="Kuwait" [KG]="Kyrgyzstan" [LA]="Lao People's Democratic Republic" [LV]="Latvia" [LB]="Lebanon" [LS]="Lesotho" [LR]="Liberia" [LY]="Libya" [LI]="Liechtenstein" [LT]="Lithuania" [LU]="Luxembourg" [MO]="Macao" [MK]="Macedonia, The Former Yugoslav Republic of" [MG]="Madagascar" [MW]="Malawi" [MY]="Malaysia" [MV]="Maldives" [ML]="Mali" [MT]="Malta" [MH]="Marshall Islands" [MQ]="Martinique" [MR]="Mauritania" [MU]="Mauritius" [YT]="Mayotte" [MX]="Mexico" [FM]="Micronesia, Federated States of" [MD]="Moldova, Republic of" [MC]="Monaco" [MN]="Mongolia" [ME]="Montenegro" [MS]="Montserrat" [MA]="Morocco" [MZ]="Mozambique" [MM]="Myanmar" [NA]="Namibia" [NR]="Nauru" [NP]="Nepal" [NL]="Netherlands" [NC]="New Caledonia" [NZ]="New Zealand" [NI]="Nicaragua" [NE]="Niger" [NG]="Nigeria" [NU]="Niue" [NF]="Norfolk Island" [MP]="Northern Mariana Islands" [NO]="Norway" [OM]="Oman" [PK]="Pakistan" [PW]="Palau" [PS]="Palestine, State of" [PA]="Panama" [PG]="Papua New Guinea" [PY]="Paraguay" [PE]="Peru" [PH]="Philippines" [PN]="Pitcairn" [PL]="Poland" [PT]="Portugal" [PR]="Puerto Rico" [QA]="Qatar" [RE]="Reunion" [RO]="Romania" [RU]="Russian Federation" [RW]="Rwanda" [BL]="Saint Barthelemy" [SH]="Saint Helena, Ascension and Tristan Da Cunha" [KN]="Saint Kitts and Nevis" [LC]="Saint Lucia" [MF]="Saint Martin (French part)" [PM]="Saint Pierre and Miquelon" [VC]="Saint Vincent and the Grenadines" [WS]="Samoa" [SM]="San Marino" [ST]="Sao Tome and Principe" [SA]="Saudi Arabia" [SN]="Senegal" [RS]="Serbia" [SC]="Seychelles" [SL]="Sierra Leone" [SG]="Singapore" [SX]="Sint Maarten (Dutch part)" [SK]="Slovakia" [SI]="Slovenia" [SB]="Solomon Islands" [SO]="Somalia" [ZA]="South Africa" [GS]="South Georgia and the South Sandwich Islands" [SS]="South Sudan" [ES]="Spain" [LK]="Sri Lanka" [SD]="Sudan" [SR]="Suriname" [SJ]="Svalbard and Jan Mayen" [SZ]="Swaziland" [SE]="Sweden" [CH]="Switzerland" [SY]="Syrian Arab Republic" [TW]="Taiwan, Province of China" [TJ]="Tajikistan" [TZ]="Tanzania, United Republic of" [TH]="Thailand" [TL]="Timor-Leste" [TG]="Togo" [TK]="Tokelau" [TO]="Tonga" [TT]="Trinidad and Tobago" [TN]="Tunisia" [TR]="Turkey" [TM]="Turkmenistan" [TC]="Turks and Caicos Islands" [TV]="Tuvalu" [UG]="Uganda" [UA]="Ukraine" [AE]="United Arab Emirates" [GB]="United Kingdom" [UK]="United Kingdom" [US]="United States" [UM]="United States Minor Outlying Islands" [UY]="Uruguay" [UZ]="Uzbekistan" [VU]="Vanuatu" [VE]="Venezuela, Bolivarian Republic of" [VN]="Viet Nam" [VG]="Virgin Islands, British" [VI]="Virgin Islands, U.S." [WF]="Wallis and Futuna" [EH]="Western Sahara" [YE]="Yemen" [ZM]="Zambia" [ZW]="Zimbabwe" )
  rand_useragent=${useragent[$RANDOM % ${#useragent[@]}]}

# posted=`curl "https://history.paypal.com/cgi-bin/webscr" --data "cmd=_cart&upload=1&business=$1&item_name_1=Iyaharuuum&amount_1=12.35&shipping_1=2.45" --compressed -D - -s --cookie-jar drop.cook --cookie asu`
  posted=`curl "https://history.paypal.com/cgi-bin/webscr" --data "item_name=Sunbury$RAND.COM+-+Monthly+Email+Address&p3=1&t3=Y&cmd=_xclick-subscriptions&currency_code=AUD&sra=1&src=1&business=$1" --compressed -D - -s --cookie-jar cookiejar.txt --cookie cookie.txt`
  duration=$SECONDS
  
# echo -n $1;echo "$posted" | grep 'merchantCountry'
  # countryCode="$(echo "$posted" | grep 'merchantCountr' | grep -o -P '(?<=merchantCountry=).*(?=\")')"
  countryCode="$(echo "$posted" | grep -o -P '(?<=paypal.com).*(?=cgi-bin)' | tail -1 | awk -F[\/\/] '{print $2}' | tr '[:lower:]' '[:upper:]')"
  header="`date +%H:%M:%S` $inputFile -> $targetFolder"
  footer="[Dh4ndy | PayPal Valid]\n"

  if [[ $countryCode == '' ]]; then
    printf "$2/$3. [${RED}DIE${NC}]${RED} $1 ${NC} $footer"
    echo "$1" >> $4/die.txt
    # echo "$posted" > $1.html
  else
    country=${countryCodeList[$countryCode]}
    printf "$2/$3. [\e[38;5;82mLIVE${NC}] \e[38;5;82m[$country] \e[38;5;82m($countryCode) \e[38;5;82m$1 ${NC} $footer"
    echo "[$country] ($countryCode) => $1" >> $4/live.txt
  fi

  printf "\r"
}

# Preparing file list 
# by using email pattern 
# every line in $inputFile
echo "[+] Cleaning your mailist file"
grep -Eiorh '([[:alnum:]_.-]+@[[:alnum:]_.-]+?\.[[:alpha:].]{2,6})' $inputFile | tr '[:upper:]' '[:lower:]' | sort | uniq > temp_list && mv temp_list $inputFile

# Finding match mail provider
echo "########################################"
# Print total line of mailist
totalLines=`grep -c "@" $inputFile`
echo "There are $totalLines of list."
echo " "
echo "Hotmail: `grep -c "@hotmail" $inputFile`"
echo "Yahoo: `grep -c "@yahoo" $inputFile`"
echo "Gmail: `grep -c "@gmail" $inputFile`"
echo "Yandex: `grep -c "@yandex" $inputFile`"
echo "AOL: `grep -c "@aol" $inputFile`"
echo ".de: `grep -c ".de" $inputFile`"
echo "Outlook: `grep -c "@outlook" $inputFile`"
echo "########################################"

# Extract email per line
# from both input file
IFS=$'\r\n' GLOBIGNORE='*' command eval  'mailist=($(cat $inputFile))'
con=1

echo "[+] Sending $sendList email per $perSec seconds"

for (( i = 0; i < "${#mailist[@]}"; i++ )); do
  username="${mailist[$i]}"
  indexer=$((con++))
  tot=$((totalLines--))
  fold=`expr $i % $sendList`
  if [[ $fold == 0 && $i > 0 ]]; then
    header="`date +%H:%M:%S`"
    duration=$SECONDS
    echo "[$header] Waiting $perSec second. $(($duration / 3600)) hours $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed, With $sendList req / $perSec seconds."
    sleep $perSec
  fi
  
  dh4ndy_request "$username" "$indexer" "$tot" "$targetFolder" "$inputFile" &

  if [[ $isDel == 'y' ]]; then
    grep -v -- "$username" $inputFile > "$inputFile"_temp && mv "$inputFile"_temp $inputFile
  fi
done 

# waiting the background process to be done
# then checking list from garbage collector
# located on $targetFolder/unknown.txt
echo "[+] Waiting background process to be done"
wait
wc -l $targetFolder/*

if [[ $isCompress == 'y' ]]; then
  tgl=`date`
  tgl=${tgl// /-}
  zipped="$targetFolder-$tgl.zip"

  echo "[+] Compressing result"
  zip -r "compressed/$zipped" "$targetFolder/die.txt" "$targetFolder/live.txt" "$targetFolder/limited.txt"
  echo "[+] Saved to compressed/$zipped"
  mv $targetFolder haschecked
  echo "[+] $targetFolder has been moved to haschecked/"
fi
#rm $inputFile
duration=$SECONDS
echo "Checking done in $(($duration / 3600)) hours $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
echo "+==========+ Dh4ndy Copyhack 2013 +==========+"