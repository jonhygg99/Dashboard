FROM cirrusci/flutter AS build

RUN apt update && apt install -y nginx
#RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
#RUN dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install

WORKDIR /app
#RUN mkdir /app/
COPY ./ .

RUN flutter channel beta
RUN flutter upgrade
RUN flutter config --enable-web
RUN flutter build web

#https://blog.codemagic.io/how-to-dockerize-flutter-apps/