#!/bin/bash
source activate quicklook 


pip install watchdog
pip install -r qlf/requirements.txt
apt-get install lsof

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

echo "QLF web application is running at http://$HOSTNAME:8000 you may start Quick Look from the pipeline interface."

bokeh serve --allow-websocket-origin=$HOSTNAME --host=$HOSTNAME:5006 --port=5006 dashboard/bokeh/qasnr dashboard/bokeh/graphs dashboard/bokeh/monitor dashboard/bokeh/exposures dashboard/bokeh/footprint &> $QLF_ROOT/bokeh.log &
python -Wi manage.py runserver 0.0.0.0:8000 &


echo "Watching .py files..."

watchmedo shell-command --patterns="*.py;*.txt;*.css" --recursive --command='echo "${watch_src_path}"' . &
watchmedo shell-command --patterns="*.py;*.txt;*.css" --recursive --command='kill -9 `lsof -t -i:5006`' . &
watchmedo shell-command --patterns="*.py;*.txt;*.css" --recursive --command='bokeh serve --allow-websocket-origin=localhost:8000 dashboard/bokeh/qasnr dashboard/bokeh/monitor dashboard/bokeh/exposures dashboard/bokeh/footprint dashboard/bokeh/graphs' . &> $QLF_ROOT/bokeh.log &

cd $QLF_ROOT
echo "Initializing QLF Daemon..."

# Start QLF daemon
python -Wi qlf/bin/qlf_daemon.py