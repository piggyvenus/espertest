FROM jboss/base-jdk:7

# Add in the esper stuff here

# The jboss/base image adds a jboss user and group with uid of 1000. Can either re-use, or create a new one at 1001.
# See comments in the jboss/base image to understand why.  In this image we will add the esper user to the jboss group
#USER root
#RUN useradd -u 1001 -r -g jboss -m -d /opt/esper -s /sbin/nologin -c "ESPER user" esper && \
#    chmod 755 /opt/esper
#
#COPY files/esperee-5.3.0 /opt/esper/esperee-5.3.0
#
#RUN chown -R jboss:jboss /opt/esper/.

COPY files/esperee-5.4.0 /opt/jboss/esperee-5.4.0

USER root
RUN chown -R jboss:jboss /opt/jboss/esperee-5.4.0/.
RUN mkdir -p /opt/jboss/esperee-5.4.0/temp

# Main Web console
EXPOSE 8400

USER jboss

# Use tail to keep the container running
CMD /opt/jboss/esperee-5.4.0/bin/startup.sh && tail -f /opt/jboss/esperee-5.4.0/logs/esperee.out

#ENTRYPOINT ["/opt/jboss/jws-3.0/bin/startup.sh"]

