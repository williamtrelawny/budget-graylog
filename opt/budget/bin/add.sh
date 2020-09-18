# Record transactions to Graylog

source /opt/budget/etc/vars.conf


function die {
    echo "$1" 1>&2
    exit 1
}


TRANSACTION_DATE="$1"
# Verify supplied date is in correct format:
if [ -z "$TRANSACTION_DATE" ]; then
read -p "Date: " TRANSACTION_DATE
fi
while ! echo "$TRANSACTION_DATE" | grep -qP "^(?:0[1-9]|1[0-2])(/|-)(?:(?:0[1-9])|(?:[12][0-9])|(?:3[01])|[1-9])(/|-)(?>\d\d){2}$"; do
    echo "ERROR: The date specified does not match the format: MM/DD/YYYY or MM-DD-YYYY"
    read -p "Date: " TRANSACTION_DATE
done

# Verify supplied amount is in correct format:
AMOUNT="$2"
if [ -z "$AMOUNT" ]; then
read -p "Amount: " AMOUNT
fi
while ! echo "$AMOUNT" | grep -qP "^\d+($|\.\d{2}$)"; do
    echo "ERROR: The amount specified is invalid."
    read -p "Amount: " AMOUNT
done
# If no decimals provided, add .00:
# if (echo "$AMOUNT" | grep -qP "^\d+$"); then
#     AMOUNT="$AMOUNT.00"
# fi

# Accept description:
DESC="$3"
if [ -z "$DESC" ]; then
    read -p "Desc: " DESC
fi
while [ -z "$DESC" ]; do
    echo "ERROR: Please enter a brief description for this transaction."
    read -p "Desc: " DESC
done

# Accept tags:
TAGS="$4"
if [ -z "$TAGS" ]; then
    read -p "Tags: " TAGS
fi

# Build message payload:
MSG="short_message=transaction_added"
TRANSACTION_DATE="-s _transaction_date=$TRANSACTION_DATE"
AMOUNT="_amount=$AMOUNT"
# Send payload to GELF Input:
curl -X POST -H 'Content-Type: application/json' -H 'X-Requested-By: cli' -d "$(jo -- $GELF_HEADER $MSG $TRANSACTION_DATE $AMOUNT -s _description="$DESC" -s _tags="$TAGS")" 'http://localhost:12201/gelf'