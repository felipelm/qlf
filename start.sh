#!/bin/bash
echo "Initializing QLF database..."

export QLF_PROJECT=/app/qlf/qlf
export QLF_ROOT=/app

# Test user for the development db
export TEST_USER=nobody
export TEST_USER_EMAIL=nobody@example.com
export TEST_USER_PASSWD=nobody

for package in desispec desiutil; do
	echo "Setting $package..."
	export PATH=$QLF_ROOT/$package/bin:$PATH
	export PYTHONPATH=$QLF_ROOT/$package/py:$PYTHONPATH
done

# Start QLF daemon
python -Wi $QLF_ROOT/qlf/bin/qlf_daemon.py

python -Wi $QLF_PROJECT/manage.py makemigrations
python -Wi $QLF_PROJECT/manage.py migrate > /dev/null
python -Wi $QLF_PROJECT/manage.py createsuperuser --noinput --username $TEST_USER --email $TEST_USER_EMAIL

# Start django and bokeh servers and save the process group id

echo "Starting QLF..."

echo "QLF web application is running at http://localhost:8000 you may start Quick Look from the pipeline interface."

python -Wi $QLF_PROJECT/manage.py runserver 0.0.0.0:8000 &> $QLF_ROOT/runserver.log
bokeh serve --allow-websocket-origin=localhost:8000 $QLF_PROJECT/dashboard/bokeh/qasnr $QLF_PROJECT/dashboard/bokeh/monitor $QLF_PROJECT/dashboard/bokeh/exposures $QLF_PROJECT/dashboard/bokeh/footprint


