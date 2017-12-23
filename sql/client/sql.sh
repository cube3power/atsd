#!/bin/sh
scriptDir="$(readlink -f $0 | xargs dirname)"
. $scriptDir/atsd.config
ATSD_URL="$url"
ATSD_INSECURE="$insecure"
ATSD_USER="$user"
ATSD_PASSWORD="$password"
output=""
input=""
query=""
format="csv"
metadata="default"

while test $# -gt 0
do
key="$1"
case $key in
    -o|--output)
    output="$2"
    shift # past argument
    ;;
    -i|--input)
    input="$2"
    shift # past argument
    ;;
    -q|--query)
    query="$2"
    shift # past argument
    ;;
    -f|--format)
    format="$2"
    if test "$metadata" = "default"; then
        if test "$format" = "json"; then
            metadata="true"
        else
            metadata="false"
        fi
    fi
    shift # past argument
    ;;
    -m|--metadata)
    metadata="$2"
    shift # past argument
    ;;
    -h|--help)
    echo "available arguments:" 
    echo "-o --output   | Output file to store the result set. If not specified, results are printed to stdout."
    echo "-i --input    | Input file containing SQL query to execute."
    echo "-q --query    | SQL query text enclosed with double quotes. Ignored if query is read from input file."
    echo "-f --format   | Format. Default: csv. Supported options: csv, json"
    echo "-m --metadata | Include metadata. Default: false for csv, true for json."
    echo "-h --help:    | show this message"
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

main() {
    queryBody=""
    if test -n "$input" -a -f "$input"; then
        #echo "Input file is specified as $input. Query will be ignored."
        queryBody=$(cat "$input")
    else
        #echo "Input file is not specified or specified file does not exist. Query value will be used."
        queryBody="${query}"
    fi
    if test -z "$queryBody"; then
        echo "Query body is empty. Exit."
        exit 1
    fi
    queryBody=$(echo "$queryBody" | sed  s/\"/\\\\\"/g)

    command="curl $ATSD_URL"
    if test -n "$output"; then
        command="$command -o $output"
    fi
    if test "$ATSD_INSECURE" = "true"; then
        command="$command --insecure"
    fi
    command="${command} --user $ATSD_USER:$ATSD_PASSWORD --request POST"
    command="${command} --data \"outputFormat=${format}&metadata=${metadata}\""
    command="${command} --data-urlencode \"q=${queryBody}\""
    eval "$command"
}

main
