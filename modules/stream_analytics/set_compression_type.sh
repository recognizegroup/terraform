#!/bin/bash

# Azure does not see changing 'compression.type' as a change. Therefor we statically
# update 'partitionKey' as well.

while getopts :g:j:i:c: flag
do
    case "${flag}" in
        g) resource_group=${OPTARG};;
        j) job_name=${OPTARG};;
        i) input_name=${OPTARG};;
        c) compression_type=${OPTARG};;
    esac
done

az stream-analytics input update \
--properties "{\"type\":\"Stream\",\"compression\":{\"type\":\"$compression_type\"},\"partitionKey\":\"\"}" \
-g $resource_group \
--job-name $job_name \
-n $input_name
