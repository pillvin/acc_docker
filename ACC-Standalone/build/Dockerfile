# ADOBE CAMPAIGN CLASSIC DOCKER PROJECT
# --------------------------
# This is the dockerfile for Adobe Campaign Classic (standalone version)
# 
# REQUIRED FILES TO BUILD THIS IMAGE
# ----------------------------------
# (1) nlserver6-v7-[BUILD]-amd64_deb9.deb
# (2) setup-client-7.0.[BUILD].exe
#
#     Download Adobe Campaign Classic from Support Portal 
#     https://support.neolane.net/webApp/extranetLogin
#
# HOW TO BUILD THIS IMAGE
# -----------------------
# Copy Campaign application and client console files in the /sources directory
# Run script build.sh to build docker acc_standalone
# Run script start.sh to start docker acc_standalone
#
# Pull base image
# ---------------
FROM ubuntu:18.04

# Maintainer
# ----------
MAINTAINER pillvin@iit.edu

WORKDIR /root/acc-install

# Build to install 
# ---------------------------------------------
ENV BUILD *.deb

# Environment variables required for PostgreSQL 
# ---------------------------------------------
ENV PG_DB_NAME_VAR neolane_db
ENV PG_USER_VAR neolane_user 
ENV PG_PASSWORD_VAR neolane_pwd

# Environment variables required for Campaign 
# -------------------------------------------
ENV INSTANCE acc1
ENV CAMPAIGN_ADMIN_PASSWORD_VAR neo 
ENV CAMPAIGN_INTERNAL_PASSWORD_VAR neo 

# prerequisites 
# ----------------------
RUN apt-get update \
 	&& apt-get upgrade -y  \
 	&& apt remove libssl1.1 -y \
 	&& apt remove libssl1.0.0 -y \
	&& echo 'tzdata tzdata/Areas select Europe' | debconf-set-selections \
	&& echo 'tzdata tzdata/Zones/Europe select Paris' | debconf-set-selections \
	&& DEBIAN_FRONTEND="noninteractive" apt install -y tzdata \
	&& apt-get install -y apt-utils systemd-container 

RUN apt install -y wget \
	&& wget http://launchpadlibrarian.net/317614660/libicu57_57.1-6_amd64.deb \
 	&& apt install ./libicu57_57.1-6_amd64.deb -y \
  	&& wget https://debian.sipwise.com/debian-security/pool/main/o/openssl1.0/libssl1.0.2_1.0.2u-1~deb9u2_amd64.deb \
	&& apt install ./libssl1.0.2_1.0.2u-1~deb9u2_amd64.deb -y --allow-downgrades

RUN	apt install -y unixodbc wget bzip2 mlocate vim wget apache2 telnet elinks openssh-server bc libicu-dev protobuf-compiler libcurl3 libc-ares2 openjdk-8-jdk postgresql-client postgresql locales openssl \
    && apt-get install build-essential chrpath libxft-dev -y \
	&& apt-get install libfreetype6 libfreetype6-dev -y \
	&& apt-get install libfontconfig1 libfontconfig1-dev -y 

# COPY sources/openssl.cnf /etc/ssl	

RUN	cd ~ \
	&& export PHANTOM_JS="phantomjs-2.1.1-linux-x86_64" \
	&& wget https://github.com/Medium/phantomjs/releases/download/v2.1.1/$PHANTOM_JS.tar.bz2 \
	&& tar xvjf $PHANTOM_JS.tar.bz2 \
	&& mv $PHANTOM_JS /usr/local/share \
	&& ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin \
	&& phantomjs --version \
	&& apt-get clean all \
	&& rm -rf /var/lib/apt/lists/* 

#Locales
# ----------------------
RUN sed -i 's/# en_US ISO-8859-1/en_US ISO-8859-1/' /etc/locale.gen && sed -i 's/# en_US.ISO-8859-15 ISO-8859-15/en_US.ISO-8859-15 ISO-8859-15/' /etc/locale.gen && sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen

# Campaign installer and configuration scripts
# --------------------------------------------
COPY acc_install.sh apache.sh monitor.sh acc_start.sh setup_instance.js ./
COPY sources/ext ./sources
COPY sources/dist/ubuntu/v9/nlserver6-v7-9364-amd64_deb9.deb ./sources
RUN chmod a+x ./*.sh &&\
	chmod a+x ./*.js &&\
	chmod 755 /root

# PostgreSQL configuration
# ------------------------
RUN sed -i -e "s/^[# ]*\\(listen_addresses[ ]*=[ ]*'\\)[^']*\\('.*\\)$/\\1*\\2/" /etc/postgresql/10/main/postgresql.conf &&\
	sed -i 's/peer/trust/g' /etc/postgresql/10/main/pg_hba.conf

RUN service postgresql start &&\
	su postgres -c "createuser -d -r -s root" &&\
	createuser $PG_USER_VAR &&\
	createdb $PG_DB_NAME_VAR -O $PG_USER_VAR &&\
	psql $PG_DB_NAME_VAR -c "alter user $PG_USER_VAR with encrypted password '$PG_PASSWORD_VAR';" &&\
	psql $PG_DB_NAME_VAR -c "create extension pgcrypto;" &&\
    service postgresql stop

# Campaign installation & configuration
# -------------------------------------
RUN dpkg -i ./sources/$BUILD 
RUN ./acc_install.sh 

RUN service postgresql start &&\
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/neolane/nl6/lib &&\
	export PATH=$PATH:/usr/local/neolane/nl6/bin &&\
	export LD_LIBRARY_PATH=/usr/lib/jvm/java-8-openjdk-amd64/jre/lib/amd64/:$LD_LIBRARY_PATH &&\
	su neolane -c "/usr/local/neolane/nl6/bin/nlserver javascript -instance:$INSTANCE -file setup_instance.js" &&\
    service postgresql stop

# Apache configuration (port 80 and 443)
# --------------------------------------
RUN ./apache.sh 

# Snowflake FDA
# -----------------------------------------------------
# RUN /usr/local/neolane/nl6/bin/fda-setup-scripts/snowflake_odbc-setup.sh

# Google Big Query FDA 
# -----------------------------------------------------
# RUN /usr/local/neolane/nl6/bin/fda-setup-scripts/bigquery_odbc-setup.sh
#RUN /usr/local/neolane/nl6/bin/fda-setup-scripts/bigquery_sdk-setup.sh

# DB Analyser plugin (optional)
# -----------------------------
COPY /sources/ext/dbanalyser /usr/local/neolane/nl6/web/dbanalyser
COPY /sources/ext/dbajssp /usr/local/neolane/nl6/datakit/xtk/eng/jssp

# Client console availability
# ---------------------------
COPY /sources/dist/setup-*.exe /usr/local/neolane/nl6/datakit/nl/eng/jsp/

# Default neolane user rights
# ---------------------------
RUN cd /usr/local/ &&\
	chown -R neolane:neolane neolane &&\
	chmod -R 775 neolane &&\
	chmod 755 neolane

# Docker internal network ports
# -----------------------------
EXPOSE 80
EXPOSE 443
EXPOSE 8080
EXPOSE 22 

# Default script to start Campaign + Apache + PostgreSQL
# ------------------------------------------------------
ENTRYPOINT ./acc_start.sh
