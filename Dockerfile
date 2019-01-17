FROM cmconner156/centos7-ruby-docker:latest
#FROM cmconner156/centos7-ruby-docker-arm32v7:latest
MAINTAINER Chris Conner <chrism.conner@gmail.com>

ARG LOCAL_PATH=/usr/local
ARG VAGRANT_PATH=$LOCAL_PATH/vagrant

RUN set -ex                           \
    && yum update -y \
    && yum -y install gcc-c++ \
    && yum clean -y expire-cache

# volumes
VOLUME /vagrant               \      
       /systems               

# ports #tcp for all except 69 and 547 are UDP
#EXPOSE 67/udp 67/tcp

ENV PATH $LOCAL_PATH/bin:$PATH

RUN cd $LOCAL_PATH && git clone https://github.com/hashicorp/vagrant.git
RUN cd $VAGRANT_PATH && bundle install
RUN cd $VAGRANT_PATH && bundle exec vagrant
RUN cd $VAGRANT_PATH && bundle --binstubs exec
RUN $VAGRANT_PATH/exec/vagrant
RUN $VAGRANT_PATH/exec/vagrant init -m hashicorp/precise64
RUN ln -sf $VAGRANT_PATH/exec/vagrant /usr/local/bin/vagrant

# entrypoint
CMD ["/usr/sbin/init"]
