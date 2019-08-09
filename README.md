# flamegraph-doc
Shows how to take systemtap profiles from OpenResty and visualize them as a flamegraph.

Ideally, you can just follow the steps in https://github.com/brendangregg/FlameGraph

As I ran into problems myself, here are the steps that worked for me.

Assuming you already have a profile "a.bt", you can turn it into a flamegraph with:

    ./create-flamegraph.sh a.bt
    sensible-browser shared/flamegraph.svg
