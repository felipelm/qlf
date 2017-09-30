#!/bin/bash
echo "Setting DESI Quick Look environment..."

for package in desispec desiutil; do
	echo "Setting $package..."
	export PATH=$QLF_ROOT/$package/bin:$PATH
	export PYTHONPATH=$QLF_ROOT/$package/py:$PYTHONPATH
done

# Start QLF daemon
python -Wi $QLF_ROOT/qlf/bin/qlf_daemon.py

