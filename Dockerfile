# Pull base build image.
FROM alpine:edge AS builder

# Add testing repo
RUN echo "http://dl-3.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# Install packages.
RUN apk --update --upgrade add \
    curl-dev gtk+3.0-dev automake autoconf intltool \
    musl-dev build-base git curl bash libc6-compat \
    libnotify-dev gnutls-dev openssl-dev gstreamer-dev

WORKDIR /tmp

# Download uGet
RUN git clone git://git.code.sf.net/p/urlget/uget2 urlget-uget2

# Compile uGet
RUN cd urlget-uget2/ && chmod +x autogen.sh && ./autogen.sh && ./configure && make && make install

# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.9

# Add testing repo for edge upgrade
RUN echo "http://dl-3.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    echo "http://dl-3.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories && \
    echo "http://dl-3.alpinelinux.org/alpine/edge/main/" >> /etc/apk/repositories

# Install packages.
RUN apk upgrade --update-cache --available && \
    apk add \
    bash curl aria2 openssl gnutls adwaita-icon-theme \
    dbus-x11 libc6-compat gtk+3.0 libnotify gstreamer \
    && rm -rf /var/cache/apk/* /tmp/* /tmp/.[!.]*

# Adjust the openbox config.
RUN \
    # Maximize only the main/initial window.
    sed-patch 's/<application type="normal">/<application type="normal" title="uGet">/' \
      /etc/xdg/openbox/rc.xml && \
    # Make sure the main window is always in the background.
    sed-patch '/<application type="normal" title="uGet">/a \    <layer>below</layer>' \
      /etc/xdg/openbox/rc.xml

# Generate and install favicons.
RUN \
    APP_ICON_URL=http://icons.iconarchive.com/icons/alecive/flatwoken/512/Apps-Uget-icon.png && \
    install_app_icon.sh "$APP_ICON_URL" \
    && rm -rf /var/cache/apk/*

# Copy the start script.
COPY startapp.sh /startapp.sh

# Copy uGet from base build image.
COPY --from=builder /usr/local /usr/local

# Change web background color
RUN echo "sed-patch 's/<body>/<body><style>body { background-color: dimgrey; }<\/style>\n/' /opt/novnc/index.html" >> /etc/cont-init.d/10-web-index.sh

# Set the name of the application.
ENV APP_NAME="uGet"
