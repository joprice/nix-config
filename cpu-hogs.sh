#!/usr/bin/env bash
# cpu-hogs — list the top CPU-consuming processes right now.
#
# Uses two `top` samples and reports the SECOND one, because the first
# sample reports CPU averaged since process start (misleading). The second
# sample is the real instantaneous usage over the sampling interval.
#
# Usage:
#   cpu-hogs          # top 15 processes by CPU
#   cpu-hogs 30       # top 30
set -euo pipefail

count="${1:-15}"

# -l 2     : two samples
# -n       : limit process rows
# -o cpu   : order by CPU
# -s 1     : 1s between the two samples
# -stats   : columns to show
top -l 2 -n "$count" -o cpu -s 1 \
    -stats pid,cpu,mem,time,command \
  | awk '
      /^PID +%CPU/ { seen++; if (seen == 2) { header = 1; print; next } }
      header && seen == 2 { print }
    '
