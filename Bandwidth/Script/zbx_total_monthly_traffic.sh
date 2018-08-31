#!/bin/bash
    # Current month total bandwidth in Byte

    i=$(vnstat --oneline | awk -F\; '{ print $11 }')

    bandwidth_number=$(echo $i | awk '{ print $1 }')
    bandwidth_unit=$(echo $i | awk '{ print $2 }')

    case "$bandwidth_unit" in
    KiB)    bandwidth_number_B=$(echo "($bandwidth_number*1024)/1" | bc)
        ;;
    MiB)    bandwidth_number_B=$(echo "($bandwidth_number*1024*1024)/1" | bc)
        ;;
    GiB)    bandwidth_number_B=$(echo "($bandwidth_number*1024*1024*1024)/1" | bc)
        ;;
    TiB)    bandwidth_number_B=$(echo "($bandwidth_number*1024*1024*1024*1024)/1" | bc)
        ;;
    esac

echo $bandwidth_number_B