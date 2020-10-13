cat << EOF


 ####     #####    ####   #####  ##   ##           ####  ##   ## #######  #### ###  ##
  ##     ##   ##  ##  ## ##   ## ###  ##          ##  ## ##   ##  ##   # ##  ## ##  ##
  ##     ##   ## ##      ##   ## #### ##         ##      ##   ##  ## #  ##      ## ##
  ##     ##   ## ##      ##   ## ## ####  ###### ##      #######  ####  ##      ####
  ##   # ##   ## ##  ### ##   ## ##  ###         ##      ##   ##  ## #  ##      ## ##
  ##  ## ##   ##  ##  ## ##   ## ##   ##          ##  ## ##   ##  ##   # ##  ## ##  ##
 #######  #####    #####  #####  ##   ##           ####  ##   ## #######  #### ###  ##

                                                             --version 1.0
 ---INFO-------------------------------------------------------------------
    此脚本检测登陆成功日志中是否有存在曾输入密码错误的IP地址
 ---------------------------------------------------------------------------------------

EOF
_lastb=$(lastb | awk '{s[$3]++} END{for(i in s) if(i~/^[0-9]/) print s[i]," ",i;}')
_last=$(last | awk '{if($3~/[0-9]{1,3}\./) print $3}' | sort -u)
for line in $_last
do
array_last[n]=$line
n=`expr $n + 1`
#echo ${array_last[*]}
done
n=0
for line in $_lastb
do
array_lastb[n]=$line
n=`expr $n + 1`
done
echo "登陆成功的IP数量："${#array_last[*]}
echo "登陆失败的IP数量："${#array_lastb[*]}
echo "checking..."
echo "------------------------------------------------"
for l in $(seq ${#array_last[*]})
do
for i in $(seq 1 2 ${#array_lastb[*]})
do
if test ${array_last[l-1]} = ${array_lastb[i]}
then
echo "[+] 在登陆成功日志中,存在有输入密码错误的情况的IP:${array_last[l-1]},密码尝试次数:${array_lastb[i-1]}"
fi
done
done
echo "------------------------------------------------"
echo "done  "`date "+%Y-%m-%d %H:%M:%S"`
