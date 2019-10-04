# Pull base build image.
FROM jlesage/baseimage-gui:alpine-3.10 AS builder

# Install packages.
RUN apk add \
    curl-dev gtk+3.0-dev automake autoconf intltool \
    musl-dev build-base git curl bash libc6-compat \
    gnutls-dev openssl-dev libgcrypt-dev

WORKDIR /tmp

# Download uGet
RUN git clone git://git.code.sf.net/p/urlget/uget2 urlget-uget2

# Compile uGet
RUN cd urlget-uget2/ \
    && chmod +x autogen.sh && ./autogen.sh \
    && ./configure --disable-notify --disable-gstreamer --disable-rss-notify --with-openssl --with-gnutls \
    && make \
    && make install

# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.10

# Install packages.
RUN apk add \
    bash curl aria2 openssl adwaita-icon-theme \
    dbus-x11 libc6-compat gtk+3.0 libgcrypt \
    && rm -rf /var/cache/apk/* /tmp/* /tmp/.[!.]* /usr/share/icons/Adwaita/cursors

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
ENV APP_NAME="uGet" \
    THEME=light