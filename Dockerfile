FROM cmconner156/centos7-ruby-docker:latest
#FROM cmconner156/centos7-ruby-docker-arm32v7:latest
MAINTAINER Chris Conner <chrism.conner@gmail.com>

ENV LOCAL_PATH /usr/local
ENV VAGRANT_HOME /home/vagrant
ENV VAGRANT_PATH ${VAGRANT_HOME}/vagrant
ENV BUNDLE ${LOCAL_PATH}/bin/bundle
ENV VAGRANT_DATA /data
ENV WORKDIR ${VAGRANT_DATA}

RUN set -ex          \
    && yum update -y \
    && yum -y install gcc-c++ \
    && yum -y install openssh openssh-server openssh-clients openssl-libs \
    && yum -y install sudo \
    && yum -y install python-pip \
    && yum -y install ansible \
    && yum clean -y expire-cache

# volumes
VOLUME ${VAGRANT_DATA} \
       ${VAGRANT_HOME}/.ssh 

# Expose SSHD
EXPOSE 22/tcp

ENV PATH ${LOCAL_PATH}/bin:${PATH}

RUN rm -f /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_ed25519_key /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key

COPY sshd_config /etc/ssh/sshd_config

# Create and configure vagrant user
RUN useradd --create-home -d ${VAGRANT_HOME} -s /bin/bash vagrant
WORKDIR ${VAGRANT_HOME}

# Configure SSH access
#RUN mkdir -p ${VAGRANT_HOME}/.ssh && \
#    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCbGgmfZZz+3jH5iMvZl0s7uiyyki5R/bRpwsh6FTVLbtmgLvzxX63UTu5axCNBC+wLqZKQhKt3ulAmGSf+Qz9PVNgd0pfL14ziRoEy0peEf5bOSUKIbQ4WBT1B07K5qrspSdP/zJU83Jaa3PfXaY1qIjTEBtv8sbC53Dk3JBFOma+QxJrgOPXe1b94uqPTlIrvvWrHQ4+jLNHjeR3yHDs+RHE30BN4ul+z+Bd6YFcXVRl/UU2RPp3rMDqST3t1fdIhbYHjm26BA1eiQgko85OXXs/NfE4RaODYIZEz4TC+SVA6fp39PFBsfVQF7TcSMpa6SZbsmKuU0dpKAdEIh2kV vagrant insecure public key" > ${VAGRANT_HOME}/.ssh/authorized_keys && \
#    chown -R vagrant: ${VAGRANT_HOME}/.ssh && \
RUN chown -R vagrant: ${VAGRANT_DATA} && \
    groupadd sudo && \
    usermod -a -G sudo vagrant && \
    `# Enable passwordless sudo for users under the "sudo" group` && \
    echo '%sudo	ALL=(ALL)	NOPASSWD: ALL' > /etc/sudoers.d/sudogroup && \
    echo -n 'vagrant:vagrant' | chpasswd && \
    `# Thanks to http://docs.docker.io/en/latest/examples/running_ssh_service/` && \
    mkdir /var/run/sshd

USER vagrant

RUN git clone https://github.com/hashicorp/vagrant.git
RUN cd ${VAGRANT_PATH} && ${BUNDLE} install
#RUN cd ${VAGRANT_PATH} && sudo ${BUNDLE} install
RUN cd ${VAGRANT_PATH} && ${BUNDLE} --binstubs exec

RUN echo "export BUNDLE=${BUNDLE}" >> ~/.bashrc
RUN echo "export VAGRANT_HOME=${VAGRANT_HOME}" >> ~/.bashrc
RUN echo "export VAGRANT_PATH=${VAGRANT_PATH}" >> ~/.bashrc
RUN echo "export VAGRANT_DATA=${VAGRANT_DATA}" >> ~/.bashrc
RUN echo "export PATH=${VAGRANT_PATH}/exec:${PATH}" >> ~/.bashrc

USER root
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

USER vagrant

# entrypoint
ENTRYPOINT ["/sbin/entrypoint.sh"]
