#! /bin/bash
BLOCK_LIST=()

denyIP(){
BLOCK_IP=$(lastb | grep "`date '+%a %b %d %H:%M'`" | uniq -c | awk '{if($1>3) print $4}')
if [[ ${#BLOCK_IP} != 0 ]]
 then
  for line in $BLOCK_IP
   do
    index_num=1
    if ((${#BLOCK_LIST[*]}==0))
     then
      firewall-cmd --zone=public --timeout=60s --add-rich-rule="rule family=ipv4 source address=${line} service name=ssh reject"
      BLOCK_LIST[0]=${line}
     else
      for blocked_ip in ${BLOCK_LIST[*]}
       do
        if [[ $line == $blocked_ip ]]
         then
          break
         else
          if ((${index_num}==${#BLOCK_LIST[*]}))
           then
            firewall-cmd --zone=public --timeout=60s --add-rich-rule="rule family=ipv4 source address=${line} service name=ssh reject"
            BLOCK_LIST[${#BLOCK_LIST[*]}]=${line}
           else
            index_num=${index_num}+1
           fi
         fi          
       done
     fi
   done
 fi
}

END_TIME=$(date -d "+1 minute")
echo "开始执行程序"$(date)
echo "PID:"$$
while [[ `date` < ${END_TIME} ]]
do
denyIP
done
echo "结束程序"$(date)
kill -9 $$
		
