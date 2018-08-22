#!/bin/bash
cd ~
if [ ! -d "/.pa-nemu/" ]; then
	mkdir .pa-nemu/
fi
if [ ! -d "/.pa-nemu/emotion/" ]; then
	mkdir .pa-nemu/emotion/
fi

cd .pa-nemu/emotion/

T=$[$(date +%s%N)/1000000]
time=$(date "+%Y-%m-%d-%H:%M:%S")
 
dialog --nocancel --title "你现在情绪怎么样?" --menu "\n鼠标或方向键选择，点击OK或回车确定." 20 30 10 1 "跳过" 2 "开心 (●'◡'● )ﾉ♥" 3 "无聊 (一_ 一).zZ" 4 "困惑 (⊙ . ⊙ )?" 5 "沮丧 (。﹏。)#"  2>_m.txt

M=$(cat _m.txt)

#一小时内免打扰
if [ $M = "1" ]; then
	dialog --nocancel --menu "是否希望一小时内免打扰?" 15 20 10  1 "YES" 2 "NO" 2>_m.txt
	D=$(cat _m.txt)
	echo $D" "$T > Disturb.txt

else
	dialog --nocancel --menu "程度如何?" 20 30 10  1 "1(一点点)" 2 "2" 3 "3" 4 "4" 5 "5(非常)" 2>_m.txt
	N=$(cat _m.txt)

	case $M in
		"2")
			M="happy"
			;;
		"3")
			M="bored"
			;;
		"4")
			M="confused"
			;;
		"5")
			M="frustrated"
			;;
	esac

	echo $T" "${M}" "${N}" "$time >> ${T}_emotion.txt
fi

rm _m.txt
