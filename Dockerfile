FROM python:3
ENV PYTHONUNBUFFERED 1
# Install conda
RUN curl -LO https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash Miniconda3-latest-Linux-x86_64.sh -p /miniconda3 -b
RUN rm Miniconda3-latest-Linux-x86_64.sh
ENV PATH /miniconda3/bin:${PATH}
RUN conda update -y conda
RUN conda config --add channels conda-forge
RUN mkdir /app
WORKDIR /app
# Install requirements
ADD requirements.txt .
RUN conda create --name quicklook python=3.5 --yes --file requirements.txt
ENV QLF_PROJECT /app/qlf/qlf
ENV QLF_ROOT /app
RUN /bin/bash -c "source activate quicklook"
ADD qlf/extras.txt .
RUN pip install numpy
RUN pip install -r extras.txt

