FROM sandersliu/ubuntu14
MAINTAINER sandersliu sandersliu@hotmail.com
# RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ trusty multiverse" | sudo tee -a /etc/apt/sources.list
RUN sudo apt-get install -y language-pack-en vim wget curl
RUN update-locale LANG=en_US.UTF-8
RUN dpkg-reconfigure locales
RUN cat /etc/default/locale
RUN uname -m
RUN cat /etc/lsb-release
RUN grep "multiverse" /etc/apt/sources.list

RUN sudo apt-get -y update
RUN sudo apt-get -y dist-upgrade

# Add the BigBlueButton key
RUN wget http://ubuntu.bigbluebutton.org/bigbluebutton.asc -O- | sudo apt-key add -

# Add the BigBlueButton repository URL and ensure the multiverse is enabled
RUN echo "deb http://ubuntu.bigbluebutton.org/trusty-090/ bigbluebutton-trusty main" | sudo tee /etc/apt/sources.list.d/bigbluebutton.list
RUN cat /etc/apt/sources.list.d/bigbluebutton.list

#Add multiverse repo
# RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ lucid multiverse" | tee -a /etc/apt/sources.list
RUN sudo apt-get -y update
# RUN apt-get -y dist-upgrade

# install ffmpeg
ADD install-ffmpeg.sh ./
RUN chmod +x install-ffmpeg.sh
RUN ./install-ffmpeg.sh
RUN ffmpeg -version

#Install Tomcat prior to bbb installation
RUN apt-get install -y tomcat7 && apt-get -y clean

#install BigBlueButton
RUN apt-get -y update
RUN echo "------- build agin apt-get install -y bigbluebutton pos = 1------------------"
RUN su - -c "apt-get install -y bigbluebutton && apt-get -y clean"
RUN echo "------- build agin apt-get install -y bigbluebutton pos = 2------------------"
# RUN sudo apt-get install -y bigbluebutton
# RUN echo "------- build agin apt-get install -y bigbluebutton pos = 3------------------"

#install bbb demo
RUN sudo apt-get install -y bbb-demo


#Install LibreOffice
# RUN wget http://bigbluebutton.googlecode.com/files/openoffice.org_1.0.4_all.deb
# RUN dpkg -i openoffice.org_1.0.4_all.deb
# RUN apt-get install -y python-software-properties
# RUN apt-add-repository ppa:libreoffice/libreoffice-4-0
# RUN apt-get -y update
# RUN apt-get install -y libreoffice-common libreoffice

#Install required Ruby version
# RUN apt-get install -y libffi5 libreadline5 libyaml-0-2
# RUN wget https://bigbluebutton.googlecode.com/files/ruby1.9.2_1.9.2-p290-1_amd64.deb
# RUN dpkg -i ruby1.9.2_1.9.2-p290-1_amd64.deb
# RUN update-alternatives --install /usr/bin/ruby ruby /usr/bin/ruby1.9.2 500 \
#                         --slave /usr/bin/ri ri /usr/bin/ri1.9.2 \
#                         --slave /usr/bin/irb irb /usr/bin/irb1.9.2 \
#                         --slave /usr/bin/erb erb /usr/bin/erb1.9.2 \
#                         --slave /usr/bin/rdoc rdoc /usr/bin/rdoc1.9.2
# RUN update-alternatives --install /usr/bin/gem gem /usr/bin/gem1.9.2 500

#Install ffmpeg
# RUN apt-get install -y build-essential git-core checkinstall yasm texi2html libvorbis-dev libx11-dev libxfixes-dev zlib1g-dev pkg-config
# ADD deb/ffmpeg_5:2.0.1-1_amd64.deb .
# RUN dpkg -i ffmpeg_5:2.0.1-1_amd64.deb

#Install Tomcat prior to bbb installation
# RUN apt-get install -y tomcat6

#Replace init script, installed one is broken
# ADD scripts/tomcat6 /etc/init.d/

#Install BigBlueButton
# RUN su - -c "apt-get install -y bigbluebutton bbb-demo" 

EXPOSE 80 9123 1935

#Add helper script to start bbb
ADD bbb-start.sh /usr/bin/

CMD ["/usr/bin/bbb-start.sh"]
