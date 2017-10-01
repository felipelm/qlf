#!/bin/bash
source activate quicklook 

export QLF_PROJECT=$(pwd)/qlf/qlf
export QLF_ROOT=$(pwd)

cd $QLF_PROJECT

for package in desispec desiutil; do
	echo "Setting $package..."
	export PATH=$QLF_ROOT/$package/bin:$PATH
	export PYTHONPATH=$QLF_ROOT/$package/py:$PYTHONPATH
done

echo "Initializing QLF database..."
# Test user for the development db
export TEST_USER=nobody
export TEST_USER_EMAIL=nobody@example.com
export TEST_USER_PASSWD=nobody

# Initialize the development database
DEVDB="db.sqlite3"
if [ -f $DEVDB ];
then
    rm $DEVDB
fi

python -Wi manage.py makemigrations
python -Wi manage.py migrate > /dev/null
python -Wi manage.py createsuperuser --noinput --username $TEST_USER --email $TEST_USER_EMAIL

echo "QLF web application is running at http://localhost:8000 you may start Quick Look from the pipeline interface."

bokeh serve --allow-websocket-origin=localhost:8000 dashboard/bokeh/qasnr dashboard/bokeh/monitor dashboard/bokeh/exposures dashboard/bokeh/footprint &
python -Wi manage.py runserver 0.0.0.0:8000 &

cd $QLF_ROOT

echo "Initializing QLF Daemon..."

# Start QLF daemon
python -Wi qlf/bin/qlf_daemon.py