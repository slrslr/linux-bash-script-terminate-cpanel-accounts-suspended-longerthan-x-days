# Linux bash script for cPanel/WHM server
# Terminate cpanel accounts that are suspended for more then X days
# To run this script automatically without prompts, comment out lines 15,16,17,19 (add # at the begnning of the line)
suspend2terminatedays=60

for cpanel in $(ls -A1 /var/cpanel/users|grep -v "system");do
cpacctfile=$(cat /var/cpanel/users/$cpanel|grep SUSPEND)
if [[ "$cpacctfile" != *"SUSPENDED=1"* ]];then
continue
fi
epochnow=$(date +%s)
epochsuspend=$(echo "$cpacctfile"|grep TIME|cut -b13-)
(( secsdifference = $epochnow - $epochsuspend )) && (( daysdifference = $secsdifference / 86400 ))
if [ "$daysdifference" -gt "$suspend2terminatedays" ];then
echo "cPanel $cpanel is suspended for $daysdifference days. Terminate it now? (y=yes, other key=no)"
read term
if [ "$term" == "y" ];then
yes|/scripts/removeacct $cpanel
fi
fi
done
