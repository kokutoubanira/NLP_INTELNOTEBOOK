ARG BASE_CONTAINER=techlab.azurecr.io/jupyter/inteldp-notebook:1.1.5
FROM $BASE_CONTAINER

USER root
RUN apt-get update && apt-get install -y \
  make \
  curl \
  file \
  git \
  libmecab-dev \
  mecab \
  mecab-ipadic-utf8


RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git
RUN mecab-ipadic-neologd/bin/install-mecab-ipadic-neologd -y

RUN wget --trust-server-names "https://ja.osdn.net/projects/comedic/downloads/74810/ComeJisyoUtf8-3.zip/"
RUN unzip ComeJisyoUtf8-3.zip -d Comejisyo
RUN cp ./Comejisyo/ComeJisyoUtf8-3/ComeJisyoUtf8-3.dic /usr/lib/x86_64-linux-gnu/mecab//dic/ComeJisyoUtf8-3.dic
RUN wget --trust-server-names "http://sociocom.jp/~data/2018-manbyo/data/MANBYO_201907_Dic-utf8.dic"
RUN cp MANBYO_201907_Dic-utf8.dic /usr/lib/x86_64-linux-gnu/mecab/dic/MANBYO_201907_Dic-utf8.dic

RUN apt install -y default-jre
RUN pip install mecab

# Tensorboard uses PORT 6006 by default
EXPOSE 6006

# Switch back to jovyan to avoid accidental container runs as root
RUN apt-get install -y vim

USER $NB_UID

RUN pip install -U pip
# RUN pip install sudachipy
# RUN pip install sudachidict_core

# RUN pip install jsonschema==3.0.1
# RUN pip install "https://github.com/megagonlabs/ginza/releases/download/v1.0.2/ja_ginza_nopn-1.0.2.tgz"
RUN git clone 'https://github.com/megagonlabs/ginza.git'
WORKDIR ginza

RUN pip install -U -r requirements.txt
RUN python setup.py develop

WORKDIR ../
USER $NB_UID