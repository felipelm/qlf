#!/bin/bash
source activate quicklook 

pip install -U Twisted[tls,http2]
pip install watchdog
pip install -r qlf/requirements.txt
apt-get install lsof
apt-get install redis-server
pip install daphne

export QLF_PROJECT=$(pwd)/qlf/qlf
export QLF_ROOT=$(pwd)

cd $QLF_ROOT
echo "Initializing QLF Daemon..."

# Start QLF daemon
python -Wi qlf/bin/qlf_daemon.py &

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
echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'pass')" | python manage.py shell

echo "QLF web application is running at http://$QLF_HOSTNAME:8000 you may start Quick Look from the pipeline interface."

bokeh serve --allow-websocket-origin=$QLF_HOSTNAME --allow-websocket-origin=$QLF_HOSTNAME:8000 --host=$QLF_HOSTNAME:5006 --port=5006 dashboard/bokeh/qasnr dashboard/bokeh/monitor dashboard/bokeh/exposures dashboard/bokeh/footprint &> $QLF_ROOT/bokeh.log &
python -u manage.py runserver 0.0.0.0:8000


echo "Watching .py files..."

#watchmedo shell-command --patterns="*.py;*.txt;*.css" --recursive --command='echo "${watch_src_path}"' . &
#watchmedo shell-command --patterns="*.py;*.txt;*.css" --recursive --command='kill -9 `lsof -t -i:5006`' . &
#watchmedo shell-command --patterns="*.py;*.txt;*.css" --recursive --command='bokeh serve --allow-websocket-origin=localhost:8000 dashboard/bokeh/qasnr dashboard/bokeh/monitor dashboard/bokeh/exposures dashboard/bokeh/footprint dashboard/bokeh/graphs' . &> $QLF_ROOT/bokeh.log &

