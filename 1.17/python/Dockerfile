FROM strataviz/flink:1.17
USER root

RUN : \
  && apt-get update -y \
  && apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev libffi-dev \
  && :

ARG PYTHON_VERSION

RUN : \
  && curl -LSso python.tgz https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz \
  && tar --strip-components=1 -xvf python.tgz \
  && ./configure --without-tests --enable-shared \
  && make -j$(getconf _NPROCESSORS_ONLN) \
  && make install \
  && ldconfig /usr/local/lib \
  && ln -s /usr/local/bin/python3 /usr/local/bin/python \
  && :

ADD requirements3.txt .
RUN : \
  # There's an error if pip has not been upgraded, sooo...
  && pip3 install --upgrade pip \
  && pip3 install -r requirements3.txt \
  && :

RUN : \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && :
