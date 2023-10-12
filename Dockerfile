ARG RUBY_VERSION=3.2.2

FROM rubylang/ruby:$RUBY_VERSION-dev-jammy

RUN apt update && apt -y install \
  imagemagick \
  zip \
  ghostscript \
  libpng-dev \
  graphicsmagick \
  ffmpeg \
  libreoffice \
  git \
  dcraw \
  libyaml-dev

RUN mkdir -p /opt/kakadu/downloads
RUN wget http://kakadusoftware.com/wp-content/uploads/KDU805_Demo_Apps_for_Linux-x86-64_200602.zip -O /opt/kakadu/downloads/kakadu.zip \
    && unzip /opt/kakadu/downloads/kakadu.zip \
    && mv KDU805_Demo_Apps_for_Linux-x86-64_200602 kakadu \
    && cp kakadu/*.so /usr/lib \
    && cp kakadu/* /usr/bin

RUN sed -i 's/policy domain="coder" rights="none" pattern="PDF"/policy domain="coder" rights="read|write" pattern="PDF"/' /etc/ImageMagick-6/policy.xml
RUN sed -i 's/decode="dng:decode" command=".*"\/>$/decode="dng:decode" command="\&quot\;dcraw\&quot\; -c -q 3 -H 5 -w \&quot\;\%i\&quot\; \| \&quot\;convert\&quot\; - \&quot\;\%u\.png\&quot\;"\/>/' /etc/ImageMagick-6/delegates.xml

RUN addgroup --system --gid 1001 app && \
  adduser --system --ingroup app --uid 1001 --shell /bin/sh --home /app app

RUN mkdir -p /app/samvera/hydra-derviatives
WORKDIR /app/samvera/hydra-derivatives
COPY ./ /app/samvera/hydra-derivatives
RUN gem install bundler && bundle install --jobs=3 --retry=3 
