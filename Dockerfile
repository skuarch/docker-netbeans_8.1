FROM ubuntu:16.04

MAINTAINER skuarch "skuarch@yahoo.com.mx"

ADD ./netbeans-8.1-javase-linux.sh ./jdk-8u91-linux-x64.tar.gz ./netbeans.conf ./run_netbeans /tmp/

## create user
RUN mkdir -p /home/developer && \
    echo "developer:x:1000:1000:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:1000:" >> /etc/group && \
    mkdir /etc/sudoers.d/ && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown developer:developer -R /home/developer 

## install java
RUN mkdir /usr/lib/jvm && \    
    mv /tmp/jdk1.8.0_91 /usr/lib/jvm/ && \
    chmod 777 -R /usr/lib/jvm && \        
    update-alternatives --install "/usr/bin/java" "java" "/usr/lib/jvm/jdk1.8.0_91/bin/java" 1 && \
    update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/jvm/jdk1.8.0_91/bin/javac" 1 && \
    update-alternatives --install "/usr/bin/javah" "javah" "/usr/lib/jvm/jdk1.8.0_91/bin/javah" 1 && \
    export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_91 && \
    export PATH=$PATH:/usr/lib/jvm/jdk1.8.0_91/bin/java && \

## install netbeans
   echo "installing netbeans..." && \
   chmod +x /tmp/netbeans-8.1-javase-linux.sh && \
   sleep 2 && \
   /tmp/netbeans-8.1-javase-linux.sh --silent && \
   cp /tmp/run_netbeans / && \
   chmod +x /run_netbeans && \
   mkdir /NetBeansProjects && \
   chmod +x -R /NetBeansProjects && \
   rm /usr/local/netbeans-8.1/etc/netbeans.conf && \
   cp /tmp/netbeans.conf /usr/local/netbeans-8.1/etc/netbeans.conf && \

## clean 
   rm -rf /tmp/*

USER developer
ENV HOME /home/developer
WORKDIR /NetBeansProjects
VOLUME /usr/local/netbeans-8.1
VOLUME /home/developer
VOLUME /NetBeansProjects
CMD /run_netbeans
