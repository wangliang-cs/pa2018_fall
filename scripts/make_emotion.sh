#!/bin/bash

#判断间隔时间
while read line
do
    #echo $line 
    var1=`echo $line|awk -F ' ' '{print $1}'`
    var2=`echo $line|awk -F ' ' '{print $2}'`
done < ~/.pa-nemu/emotion/Disturb.txt

D_time=3600000

flag_skip='false'
if [ $var1 = "1" ]; then
    T=$[$(date +%s%N)/1000000]
    T=$[$T-$var2]
    #echo $T
    if [ $T -lt $D_time ]; then
        flag_skip='true'
    else
        flag_skip='false'
    fi
fi

#echo $flag_skip

if [ $flag_skip = 'false' ]; then
        sessionName=$(tmux display-message -p "#S")
        echo "session_name_"$sessionName
        if [ "session_name_"$sessionName != "session_name_PA-NEMU" ];then
            tmux new-session -s "PA-NEMU" -d
        fi

        tmux split-window -h
        tmux select-pane -t 0
        tmux send-keys "make all |& tee make.log; while  [ ! -f  ".lock_tmux" ]; do sleep 0.1; done; rm .lock_tmux; exit" C-m
        tmux select-pane -t 1
        tmux send-keys "scripts/emotion_dialog.sh; touch .lock_tmux; exit" C-m
        tmux attach -t "PA-NEMU" 
else
        make all |& tee make.log 
fi
