#!/bin/bash

IFS=$'\n' read -d '' -r -a URLS < ./current.txt
SIZE=${#URLS[@]}
for (( i=0; i<$SIZE; i++ ));
do
        TEMP=$(curl -s -D - -o /dev/null "${URLS[$i]}" | awk -v FS=": " ' /^location|^Location/{print substr($2, 1, length($2)-1)}')
        LINK=$(echo "$TEMP" | awk -F/ '{print $1"//"$3}')
        echo $LINK
        if [ "$LINK" == "//" ]
        then
                if [[ "$i" -eq 0 ]]
                then
                        echo "${URLS[$i]}" > current.txt
                else
                        echo "${URLS[$i]}" >> current.txt
                fi

                IFS=$'\n' read -d '' -r -a pathes < ./pathes.txt

                if [[ "$i" -eq 0 ]]
                then
                        echo -e "${pathes[$i]}\t${URLS[$i]}\t301" > ./_redirects
                else
                        echo -e "${pathes[$i]}\t${URLS[$i]}\t301" >> ./_redirects
                fi

        else
                if [[ "$i" -eq 0 ]]
                then
                        echo "$LINK" > current.txt
                else
                        echo "$LINK" >> current.txt
                fi

                IFS=$'\n' read -d '' -r -a pathes < ./pathes.txt

                if [[ "$i" -eq 0 ]]
                then
                        echo -e "${pathes[$i]}\t$LINK\t301" > ./_redirects
                else
                        echo -e "${pathes[$i]}\t$LINK\t301" >> ./_redirects
                fi
        fi

        

        
done


