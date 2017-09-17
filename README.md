# QLF


## Create your qlf.cfg file

```
cd $QLF_ROOT/qlf/config
cp qlf.cfg.template qlf.cfg
```
Edit `qlf.cfg` (follow the instructions there)

## Test Data

```
mkdir -p $QLF_ROOT/spectro # or any other place, make sure this path is consistent with qlf.cfg in step 5.
cd $QLF_ROOT/spectro

# Test data for local run of QLF: night 20190101, exposures 3 and 4.

wget -c http://portal.nersc.gov/project/desi/data/quicklook/20190101_small.tar.gz 

tar xvzf 20190101_small.tar.gz
```

## Running

```
$ git -v
$ docker -v
$ docker-compose -v
$ git clone https://github.com/felipelm/qlf && cd qlf
$ git submodule init && git submodule update
$ docker-compose up
```