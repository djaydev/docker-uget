# djaydev/uget

# Pull base image.
FROM jlesage/baseimage-gui:debian-9

WORKDIR /tmp

# Install dependencies.
RUN echo "deb http://deb.debian.org/debian sid main non-free contrib" >> /etc/apt/sources.list && \
	  apt update && \
	  DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y \
        uget aria2 dbus-x11 breeze-gtk-theme && \
    # Cleanup
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    apt-get clean -y && \
    apt-get purge -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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
    apt update && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y npm && \
    APP_ICON_URL=http://icons.iconarchive.com/icons/alecive/flatwoken/512/Apps-Uget-icon.png && \
    install_app_icon.sh "$APP_ICON_URL" && \
		# Cleanup
		apt-get remove npm -y && \
		apt-get autoremove -y && \
		apt-get autoclean -y && \
		apt-get clean -y && \
		apt-get purge -y && \
		rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy the start script.
COPY startapp.sh /startapp.sh
RUN chmod +x /startapp.sh

# Change web background color
RUN printf "sed-patch 's/<body>/<body><style>body { background-color: dimgrey; }<\/style>/' /opt/novnc/index.html" >> /etc/cont-init.d/10-web-index.sh

# Theme chooser
ENV THEME=light

# Set the name of the application.
ENV APP_NAME="uGet"
