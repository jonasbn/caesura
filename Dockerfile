# check=skip=InvalidDefaultArgInFrom

# REF: https://docs.docker.com/engine/reference/builder/
# REF: https://hub.docker.com/_/perl
# REF: https://github.com/Perl/docker-perl
ARG BASE_IMAGE=perl:5.44.0@sha256:63050301d917c751d6adc2db7669c0e811d3dc75fa4dbca958ff3080e3caf0fd
FROM ${BASE_IMAGE}

# We point to the original repository for the image
LABEL org.opencontainers.image.source="https://github.com/jonasbn/caesura"
LABEL org.opencontainers.image.base.name="registry.hub.docker.com/library/perl:5.44.0"

# We need C compiler and related tools
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends

# This is our Dist::Zilla work directory, we do not want to mix this
# with our staging area
WORKDIR /usr/src/pause

COPY cpanfile .
RUN cpanm App::pause \
    && cpanm --installdeps .


# This is our executable, it consumes all parameters passed to our container
ENTRYPOINT [ "pause" ]
