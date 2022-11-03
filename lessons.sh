#!/bin/sh

FILE=$1

#Important scripts
getTeachersWhoHaventLessonOnWednesday(){
    echo "RESULT:"

    counter=1
    while read line
    do 
        #echo $line
        res=`echo $line | cut -d ',' -f4 | cut -d ' ' -f 2-`
        #echo $res
        isThereSomething=`echo $res | grep -e "[0-9]"`
        #echo $isThereSomething

        #Check If there is someone
        if [[ -z "$isThereSomething" ]]; then
            name=`echo $line | cut -d ',' -f1`
            echo "\t$counter - $name"
            counter=`expr $counter + 1`
        fi
    done < $FILE

    if [[ $counter -eq 1 ]]; then
        echo "\tNONE"
    fi

    echo ""

    printf "Would you like to close the program? Enter 'Y/y' to close: "
    read OPTION

    if [[ $OPTION == "Y" || $OPTION == 'y' ]]; then
        dismiss
    else
        printHeader
    fi
}

# 

getNumberOfLessonsPerTeacher(){
    echo "RESULT:"

    counter=1
    while read line
    do 
        #echo $line
        isThereSomething=`echo $line | grep "\<[0-9]\+\([0-9]\+\)*\>" -o`
        numberOfLessons=`echo $isThereSomething | wc -w`
        name=`echo $line | cut -d ',' -f1`
        res=`echo $name $numberOfLessons lesson\(s\) | paste - - -`
        printf "\t$counter - $res\n"
        counter=`expr $counter + 1`
        
    done < $FILE

    echo ""

    printf "Would you like to close the program? Enter 'Y/y' to close: "
    read OPTION

    if [[ $OPTION == "Y" || $OPTION == 'y' ]]; then
        dismiss
    else
        printHeader
    fi
}

getWhoDoesNotHaveTheFirstLessonOnAGivenDay(){    
    echo "RESULT:"

    DAY=$1

    counter=1
    while read line
    do 
        #echo $line
        
        res=`echo $line | cut -d ',' -f 2- | grep -o "\$DAY.*," | cut -d ',' -f 1`
        #echo "$res"
        isThereOne=`echo $res | grep -o "\b1\b"`
        #echo "$isThereOne"

        if [[ -z "$isThereOne" ]]; then
            name=`echo $line | cut -d ',' -f1`
            printf "\t$counter - $name\n"
            counter=`expr $counter + 1`
        fi

    done < $FILE


    if [[ $counter -eq 1 ]]; then
        echo "\EMPTY"
    fi

    echo ""

    printf "Would you like to close the program? Enter 'Y/y' to close: "
    read OPTION

    if [[ $OPTION == "Y" || $OPTION == 'y' ]]; then
        dismiss
    else
        printHeader
    fi
}

# Print the MAIN MENU
printHeader(){
    clear
    now=`date`
    echo "================================================="
    echo "HOMEWORK 2 :: OPTION 3 "
    echo "Student: MARTINS Alfredo | HEIOPO | $now"
    echo "=================================================="
    echo ":: WELCOME TO SCHOOL QUERY SYSTEM ::"
    echo "OPTIONS:"
        echo "\t:: T - Teachers who haven't lesson on Wednesday ::"
        echo "\t:: N - Number of lessons per teacher ::"
        echo "\t:: W - Who does not have the first lesson on a given day? ::"
        echo "\t:: E - Exit::"
    
    askOption
}

teachersDont(){
    echo ":: TEACHERS WHO HAVEN'T LESSON ON WEDNESDAY ::"
    getTeachersWhoHaventLessonOnWednesday

    printf "Would you like to close the program? Enter 'Y' to close: "
    read OPTION

    if [[ $OPTION == "Y" || $OPTION == 'y' ]]; then
        dismiss
    else 
        printHeader
    fi
}

numberOfLessons(){
    echo ":: NUMBER OF LESSONS' PER TEACHER ::"
    getNumberOfLessonsPerTeacher

    printf "Would you like to close the program? Enter 'Y' to close: "
    read OPTION

    if [[ $OPTION == "Y" || $OPTION == 'y' ]]; then
        dismiss
    else 
        printHeader
    fi
}

isValidOption(){
    PARAM=$1
    TEXT="M Tu W Th F"

    if [[ "$OPTION" == `echo $TEXT | grep -o "$OPTION"` ]]; then
        return 1
    else
        return 0
    fi
}

whoDoesNotHave(){
    echo ":: WHO DOES NOT HAVE THE FIRST LESSON ON A GIVEN DAY? ::"
    echo " "
    echo "OPTIONS:"
        echo "\t:: M - Monday ::"
        echo "\t:: Tu - Tuesday ::"
        echo "\t:: W - Wednesday ::"
        echo "\t:: Th - Thursday ::"
        echo "\t:: F - Friday ::"
    printf "Please enter the day: "
    read OPTION

    isValidOption $OPTION
    res=$?
    
    if test $res -eq 1
    then
        getWhoDoesNotHaveTheFirstLessonOnAGivenDay $OPTION
    else 
        echo ""
        printfInvalidOperation
        echo "Try again, please!"
        echo ""
        sleep 1
        whoDoesNotHave
    fi

}

dismiss(){
    echo ""
    echo "THANK YOU FOR USING MY SCRIPT :) $(date)"
    echo "Copyright© ComSys ELTE 2022, Alfredo Martins (Student) & Dr. Bakonyi Viktória (Teacher)"
    exit 0
}

printfInvalidOperation(){
    echo "!!! ALERT !!!"
    echo "==> Invalid operation <=="
}

askOption(){

    printf "Enter the option: "
    read OPTION
    echo ""
    case "$OPTION" in 
        "T") teachersDont ;;
        "N") numberOfLessons ;;
        "W") whoDoesNotHave ;;
        "E") dismiss ;;
        *) 
            printfInvalidOperation
            sleep 1
            printHeader
    esac
}

echo "$FILE"

# The script execution starts here ...
#File if the file exist and if any parameter was given

if [[ $# -eq 0 ]]
then
    echo "Wait, you forgot to pass the parameter via terminal line. Please, do It next time. :)"
elif [[ -f "$FILE" ]]; then
    printHeader
else 
    echo "Sorry, the file was not found in the system. => $FILE!"
    dismiss
fi