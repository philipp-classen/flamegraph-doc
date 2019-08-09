#!/bin/bash
#
# Processed OpenResty profiling output and visualize them as flamegraphs.
#

if [[ $# -eq 0 ]]; then
    echo "Usage: create-flamegraph.sh [INPUT]"
    echo "  where"
    echo "INPUT: the profiling output (often called 'a.bt')"
    exit
fi

set -e
docker build -t flamegraph-builder .

# touch all files first, otherwise Docker will create them as root
mkdir -p -- "$(pwd)/shared"
touch "$(pwd)/shared/flamegraph.svg"
cp "$1" "$(pwd)/shared/a.bt"

# Note: As a workaournd, filter non-ascii characters, otherwise, you will get errors
# like this utf8 "\xEA" does not map to Unicode at ./flamegraph.pl line 606, <> line 393
# ... and the the final svg will be corrupted
docker run --rm -v "$(pwd)/shared:/shared" -it flamegraph-builder /bin/bash -c './stackcollapse-stap.pl /shared/a.bt | grep -P "^[[:ascii:]]+$" > a.cbt && ./flamegraph.pl -encoding="ISO-8859-1" --color=io --title="flamegraph" a.cbt > /shared/flamegraph.svg' || { rm -f "$(pwd)/shared/flamegraph.svg" ; exit 1 ; }

rm -f "$(pwd)/shared/a.bt"
echo "File successfully generated as: $(pwd)/shared/flamegraph.svg  (it is recommended to use a browser to inspect it)"
