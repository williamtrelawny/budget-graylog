#!/bin/bash
# Prepare & Import CSV file transaction data for Graylog Lookup Adapter

# init vars
source /opt/budget/etc/vars.conf

function die {
    echo "$1" 1>&2
    exit 1
}

if [ ! -f "$1" ]; then
    die "ERROR: The file specified cannot be found."
else
    IMPORTFILE="/opt/budget/var/transactions-`date +%Y-%m-%d_%H-%M-%S`.csv"
    cp "$1" $IMPORTFILE
    tail -n +2 $IMPORTFILE >> $GRAYLOGHOME/lookup/transactions.csv
    rm $IMPORTFILE
    exit 0
fi

# # Insert & populate TID column at first column:
# awk -F, '{$1=i++ FS $1;}1' OFS=, $IMPORTFILE > $IMPORTFILE.new
# mv $IMPORTFILE.new $IMPORTFILE
# sed -i 's/^0,/"tid",/' $IMPORTFILE

# Save prepared file to Graylog lookup tables dir:

