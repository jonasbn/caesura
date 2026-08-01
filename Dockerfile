# check=skip=InvalidDefaultArgInFrom

# REF: https://docs.docker.com/engine/reference/builder/
# REF: https://hub.docker.com/_/perl
# REF: https://github.com/Perl/docker-perl
ARG BASE_IMAGE=perl:5.44.0-slim-trixie@sha256:c9aac2fcb8612b25b818df998413423eecf15d8d5175c98d1c10a069ac7e7f8f
FROM ${BASE_IMAGE}

# We point to the original repository for the image
LABEL org.opencontainers.image.source="https://github.com/jonasbn/caesura"
LABEL org.opencontainers.image.base.name="registry.hub.docker.com/library/perl:5.44.0-slim-trixie"

# We need a C compiler and related tools to build XS modules pulled in by
# App::pause's dependency tree (e.g. List::MoreUtils -> Test::LeakTrace),
# which the slim base image does not ship with
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends build-essential \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# This is our Dist::Zilla work directory, we do not want to mix this
# with our staging area
WORKDIR /usr/src/pause

COPY cpanfile .
RUN cpanm App::pause \
    && cpanm --installdeps .


# This is our executable, it consumes all parameters passed to our container
ENTRYPOINT [ "pause" ]
