#!/bin/bash

# First run of budget script
# By: William Trelawny
# Copyright 2020 William Trelawny

# ref: https://docs.graylog.org/en/3.3/pages/gelf.html


# Init vars:
source /opt/budget/etc/vars.conf
_SELF=$(basename "$0" | cut -d"." -f1)
# GELF_HEADER="version=1.1 host=$_SELF timestamp=`date +%s`"
MSG=

# General kill command:
function die {
    echo "$1" 1>&2
    exit 1
}

# If no arguments provided, die:
if [ "$#" == 0 ]; then
    die "ERROR: No arguments supplied, exiting..."
fi


while true; do
    case $1 in
        -h|--help)
            ;;
        -a|--add)
            shift
            echo "DEBUG -- ARGS_1:$@"
            # If arguments are provided, pass them to add.sh:
            $BUDGETPATH/add.sh $@

            # add.sh return status:
            if [ $? == 0 ]; then
                echo "Transaction added!"
            else
                die "ERROR: Failed to add transaction."
            fi
            shift
            ;;
        -i|--import)
            if [ "$2" ]; then
                $BUDGETPATH/import-csv.sh $2
            else
                die "ERROR: No file specified for import."
            fi
            
            if [ $? == 0 ]; then
                echo "$2 imported!"
            else
                die "ERROR: Failed to import transaction."
            fi
            shift
            ;;
        -v|--verbose)
            verbose=$((verbose + 1)) # Each -v adds 1 to verbosity.
            ;;
        -?*)
            #printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *) # Default case: No more options so break out of the loop.
            break
    esac
    shift
done

#fields = ["tid", "transaction_date", "posted_date", "description", "amount", "tags"]

exit






# while true; do
#     case $1 in
#         -1)
#             echo "$1"
#             break
#             ;;
#         -2)
#             if [ "$2" ]; then
#                 echo "$2"
#                 shift
#                 echo "$2"
#             else
#                 echo "No second arg"
#             fi
#             break
#             ;;
#     esac
# done
