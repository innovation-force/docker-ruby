FROM quay.io/cambia/debian

ENV RUBY_VERSION 2.3.0
ENV RUBY_SHA1SUM 2dfcf7f33bda4078efca30ae28cb89cd0e36ddc4

RUN BUILD_DIR="/tmp/ruby-build" \
 && apt-get update \
 && apt-get -y install wget build-essential zlib1g-dev libssl-dev \
    libreadline6-dev libyaml-dev \
 && mkdir -p "$BUILD_DIR" \
 && cd "$BUILD_DIR" \
 && wget -q "http://cache.ruby-lang.org/pub/ruby/ruby-${RUBY_VERSION}.tar.gz" \
 && echo "${RUBY_SHA1SUM}  ruby-${RUBY_VERSION}.tar.gz" | sha1sum -c - \
 && tar xzf "ruby-${RUBY_VERSION}.tar.gz" \
 && cd "ruby-${RUBY_VERSION}" \
 && ./configure --enable-shared --prefix=/usr \
 && make \
 && make install \
 && cd / \
 && rm -r "$BUILD_DIR"

RUN gem install bundler

ADD test /tmp/test
RUN bats /tmp/test
