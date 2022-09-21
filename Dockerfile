# provide image details
FROM kalilinux/kali-rolling:latest

# add labels
LABEL maintainer="dmdhrumilmistry"

# udpate repo
RUN apt update -y && apt upgrade -y


# set ENV vars
ENV TOOLS_DIR=/opt/tools/
ENV SCRIPTS_DIR=/opt/scripts/

# create directory for tools and scripts in opt
RUN mkdir -p ${TOOLS_DIR}
RUN mkdir -p ${SCRIPTS_DIR}
WORKDIR ${TOOLS_DIR}

# install python
RUN apt install python3 python3-pip -y --force-yes

# install golang
RUN apt install golang -y
ENV GOROOT=/usr/lib/go
ENV GOPATH=$HOME/go
ENV PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# install git 
RUN apt install git -y --force-yes

## install python based tools
# install jwt_tool
RUN git clone --depth=1  https://github.com/ticarpi/jwt_tool
WORKDIR ${TOOLS_DIR}/jwt_tool/
RUN pip install -r requirements.txt
WORKDIR ${TOOLS_DIR}

# install mitmproxy
RUN apt install mitmproxy -y --force-yes
RUN pip install mitmproxy2swagger

# install arjun
RUN pip install arjun

## install go based tools
# install amass
RUN go install -v github.com/OWASP/Amass/v3/...@master
# install gobuster
RUN go install github.com/OJ/gobuster/v3@latest
# install kiterunner
RUN git clone --depth=1 https://github.com/assetnote/kiterunner
RUN cd kiterunner && make build && ln -s $(pwd)/dist/kr /usr/local/bin/kr

## install other necessary tools
RUN apt install -y --force-yes seclists curl wget nmap tor proxychains openssh-server openssh-client apache2

# Copy installation script
# COPY ./install.sh ${SCRIPTS_DIR}/install.sh

## Expose ports for use as required
EXPOSE 1-65535

## set entrypoint
ENTRYPOINT [ "/bin/echo", "-e","Use `apt install kali-linux-headless -y` to install more tools" ]
