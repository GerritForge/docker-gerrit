FROM centos:7.3.1611
MAINTAINER GerritForge

# Allow remote connectivity and sudo
RUN yum -y install openssh-client initscripts sudo

# Add Gerrit packages repository
RUN rpm -i https://gerritforge.com/gerritforge-repo-1-2.noarch.rpm

# Install OpenJDK and Gerrit in two subsequent transactions
# (pre-trans Gerrit script needs to have access to the Java command)
RUN yum -y install java-1.8.0-openjdk
RUN yum -y install gerrit-2.14.2-1

USER gerrit
RUN java -jar /var/gerrit/bin/gerrit.war init --batch --install-all-plugins -d /var/gerrit
RUN java -jar /var/gerrit/bin/gerrit.war reindex -d /var/gerrit

# Allow incoming traffic
EXPOSE 29418 8080

# Start Gerrit
CMD git config -f /var/gerrit/etc/gerrit.config gerrit.canonicalWebUrl http://$HOSTNAME:8080/ && /var/gerrit/bin/gerrit.sh start && tail -f /var/gerrit/logs/error_log
