# QLF

## Installation

```
git -v
docker -v
docker-compose -v
git clone --recursive https://github.com/felipelm/qlf && cd qlf
```

## Create your qlf.cfg file

```
cp qlf.cfg qlf/config/qlf.cfg
```

## Test Data

```
wget -c http://portal.nersc.gov/project/desi/data/quicklook/20190101_small.tar.gz 

tar xvzf 20190101_small.tar.gz
```

## Running

```
docker-compose up
```
