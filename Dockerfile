FROM debian:8.3

ENV BATMAN_VERSION=2016.5
ENV PACKAGES="build-essential checkinstall pkg-config curl libnl-genl-3-200 libnl-3-dev libnl-genl-3-200 libnl-genl-3-dev golang git"
ENV REMOVE_PACKAGES="build-essential checkinstall pkg-config libnl-3-dev libnl-genl-3-dev"

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y $PACKAGES && \
    cd /usr/src && \
    curl -O https://downloads.open-mesh.org/batman/stable/sources/batctl/batctl-${BATMAN_VERSION}.tar.gz && \
    tar xfz batctl-${BATMAN_VERSION}.tar.gz && \
    cd batctl-${BATMAN_VERSION} && \
    make && checkinstall -y make install && \
    cd .. && rm -rf batctl-${BATMAN_VERSION}* && \
    apt-get remove -y $REMOVE_PACKAGES && apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists

RUN export GOPATH=/usr/local/go && \
    mkdir -p $GOPATH && \
    export PATH=$PATH:$GOPATH/bin && \
    go get github.com/a8m/envsubst/cmd/envsubst && \
    mv $GOPATH/bin/envsubst /usr/local/bin/envsubst && \
    rm -r $GOPATH && \
    unset GOPATH

