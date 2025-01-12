FROM python:3.12.0a4-bullseye
LABEL maintainer="junhyunglee@duck.com"

ENV streamlinkCommit=34c5f5ee5953412c6214ad4a3c18dd08d1229c24
ENV PATH "${HOME}/.local/bin:${PATH}"

RUN apt-get update && apt-get install gosu && apt-get install python3-pip -y

RUN pip3 install --upgrade git+https://github.com/streamlink/streamlink.git@${streamlinkCommit}

RUN echo 'export PATH="${HOME}/.local/bin:${PATH}"'

RUN mkdir /home/download
RUN mkdir /home/script
RUN mkdir /home/plugins

#RUN git clone https://github.com/Damianonymous/streamlink-plugins.git
#RUN cp /streamlink-plugins/*.py /home/plugins/

COPY ./streamlink-recorder.sh /home/script/
COPY ./entrypoint.sh /home/script/

RUN ["chmod", "+x", "/home/script/entrypoint.sh"]

ENTRYPOINT [ "/home/script/entrypoint.sh" ]

CMD /bin/bash ./home/script/streamlink-recorder.sh ${streamOptions} ${streamLink} ${streamQuality} ${streamName}
