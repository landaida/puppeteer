# DOCKER-VERSION 1.8.1
# METEOR-VERSION 1.2.1
FROM debian:jessie

# Create user meteor who will run all entrypoint instructions
RUN useradd meteor -G staff -m -s /bin/bash
WORKDIR /home/meteor

# Install git, curl
RUN apt-get update && \
   apt-get install -y build-essential git curl bzip2 libfontconfig \
   gconf-service \ 
    libasound2 \ 
    libatk1.0-0 \ 
    libc6 \ 
    libcairo2 \ 
    libcups2 \ 
    libdbus-1-3 \ 
    libexpat1 \ 
    libfontconfig1 \ 
    libgcc1 \ 
    libgconf-2-4 \ 
    libgdk-pixbuf2.0-0 \ 
    libglib2.0-0 \ 
    libgtk-3-0 \ 
    libnspr4 \ 
    libpango-1.0-0 \ 
    libpangocairo-1.0-0 \ 
    libstdc++6 \ 
    libx11-6 \ 
    libx11-xcb1 \ 
    libxcb1 \ 
    libxcomposite1 \ 
    libxcursor1 \ 
    libxdamage1 \ 
    libxext6 \ 
    libxfixes3 \ 
    libxi6 \ 
    libxrandr2 \ 
    libxrender1 \ 
    libxss1 \ 
    libxtst6 \ 
    ca-certificates \ 
    fonts-liberation \ 
    libappindicator1 \ 
    libnss3 \ 
    lsb-release \ 
    xdg-utils \ 
    wget && \
   (curl -sL https://deb.nodesource.com/setup_9.x | bash) && \
   apt-get install -y nodejs jq && \
   apt-get install nano && \
   apt-get clean && \
   rm -Rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN export TERM=xterm
#RUN npm install forever -g
RUN npm install -g semver
RUN npm install nodemon -g

# Install entrypoint
COPY entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

# Add known_hosts file
COPY known_hosts .ssh/known_hosts

RUN chown -R meteor:meteor .ssh /usr/bin/entrypoint.sh
RUN chown -R meteor /usr/local

# Allow node to listen to port 80 even when run by non-root user meteor
#RUN setcap 'cap_net_bind_service=+ep' /usr/bin/nodejs
RUN setcap 'cap_net_bind_service=+ep' $(readlink -f $(which node))




# Download Meteor installer
RUN echo "Downloading Meteor install script..."
RUN curl ${CURL_OPTS} -o /tmp/meteor.sh https://install.meteor.com?release=${RELEASE}

# Install Meteor tool
RUN echo "Installing Meteor ${RELEASE}..."
RUN sh /tmp/meteor.sh
RUN rm /tmp/meteor.sh




EXPOSE 80

# Execute entrypoint as user meteor
ENTRYPOINT ["su", "-c", "/usr/bin/entrypoint.sh", "meteor"]
CMD []
