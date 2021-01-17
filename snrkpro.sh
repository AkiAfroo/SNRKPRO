#!/bin/sh 
############################CREATE BY Aki################################################
####### piece of software of my snarkstopper, this script just change the fee random#####
# - snarkstopper is disable
# - and other fuctions are disable and the code is not include
# - this piece of code is just for Fun. dont blame on me. xD
# - feel free to edit, add, remove, the whole code as you wish. 
# - 

MINA_RANDOM_FEE_NUMBER="0" ##>> A # >>>> MAX number you want to be Randomize for your snark work fees. if the number is equal or greater than 1 the script randomize de decimals and MINA_START_DECIMALS is disable
MINA_START_DECIMALS="7"    ##>> B # >>>>>when MINA_RANDOM_FEE_NUMBER is equal to zero then you can set the number after the (.) 
# now is set to 0.7
## if you add 0 to A and 000 to B then you will get a lot of hate in mina community xD. have fun. 
#
function minalogo ()
{
cat <<"EOT"


##########################-DEMO1-############################### 
#  ███████╗███╗   ██╗██████╗ ██╗  ██╗██████╗ ██████╗  ██████╗  # 
#  ██╔════╝████╗  ██║██╔══██╗██║ ██╔╝██╔══██╗██╔══██╗██╔═══██╗ #
#  ███████╗██╔██╗ ██║██████╔╝█████╔╝ ██████╔╝██████╔╝██║   ██║ #
#  ╚════██║██║╚██╗██║██╔══██╗██╔═██╗ ██╔═══╝ ██╔══██╗██║   ██║ #
#  ███████║██║ ╚████║██║  ██║██║  ██╗██║     ██║  ██║╚██████╔╝ #
#  ╚══════╝╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝  ╚═╝ ╚═════╝  #
#######################-MINA SNARKER-###########################      

EOT
echo "CODA VERSION: $(cat /tmp/coda_client_status.json | grep -Po '(?<="commit_id":)\W*\K[^ "]*')"
}

function countdown() {
   date1=$((`date +%s` + $1)); 
   while [ "$date1" -ge `date +%s` ]; do 
     echo -ne "$(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
     sleep 0.2
   done
}

function snarkfee(){
clear
coda client set-snark-worker -address $MINA_PUBLIC_KEY
echo "Launching SNRKPRO.. wait!"
countdown 5 
while true  
do
clear
curl --silent -o /tmp/latest-blocks.json "https://minaexplorer.com/latest-blocks"
coda client status -json > /tmp/coda_client_status.json
MINANET=$(cat /tmp/coda_client_status.json | grep -Po '(?<="sync_status":)\W*\K[^ "]*') 
if [[ ${MINANET}  == "Synced" ]]; then 
MINAUPTIME=$(cat /tmp/coda_client_status.json | grep -Po '(?<="uptime_secs":)\W*\K[^ ,]*')
MINA_LOCAL_BLOCKHEIGHTS="$(cat /tmp/coda_client_status.json | grep -Po '(?<="blockchain_length":)\W*\K[^ ,]*')"
HIGHEST__BLOCK_LENGHT_RECEIVED="$(cat /tmp/coda_client_status.json | grep -Po '(?<="highest_block_length_received":)\W*\K[^ ,]*')"
read mina1 < <(echo $(cat /tmp/latest-blocks.json | jq -cr '.[].BlockchainLength' | sort -n | tail -1 | awk '{ gsub (" ", "", $0); print}'))
read mina2 mina3 < <(echo $(cat /tmp/latest-blocks.json | jq -cr '.[0].User','.[0].Creator' | awk '{ gsub (" ", "", $0); print}'))
if [[ "$MINA_RANDOM_FEE_NUMBER" == 0 ]]; then
    MINAFEE=$(printf "0.${MINA_START_DECIMALS}%04d\n" $(( RANDOM % 1000 ))) 
else
    MINAMAGIC=$[ ( $RANDOM % $MINA_RANDOM_FEE_NUMBER )  + 1 ]
    MINAFEE=$(printf "${MINAMAGIC}.%04d\n" $(( RANDOM % 1000 ))) # COMMENT HERE YOU CAN CHANGE THE INITIAL FEE , NOW IS "0."
fi
minalogo                
                  echo ""
                  echo ""
                  echo "Minaexplorer is Online Getting Last BLock and compare with your Heights"
                  echo "Your Local uptime     :$(date -d@"$MINAUPTIME" -u +%H:%M:%S)"  
                  echo "Your Block Height     :$MINA_LOCAL_BLOCKHEIGHTS"
                  echo "Max O.B Height        :$HIGHEST__BLOCK_LENGHT_RECEIVED" 
                  echo "Explorer Last Block   :"$mina1  
                  echo "Produced By           :"$mina2
                  echo "Mina Address          :"$mina3 
                  echo ""
                  echo "my fees               :${MINAFEE}"
                  coda client set-snark-work-fee "${MINAFEE}"
                  countdown 300
else
minalogo 
echo "daemon is not synced..wait"
countdown 300
fi
done
}
exists()
{
  command -v "$1" >/dev/null 2>&1
}

if exists jq; then
  echo ''
else
  echo "the script need jq: is a command-line tool for parsing JSON"
  echo "installing jq..wait"
  sudo apt install jq -y
fi

snarkfee
