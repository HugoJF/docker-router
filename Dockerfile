FROM ubuntu:16.04

RUN apt-get update \
 && apt-get install -y  iptables \
                        iputils-ping \
                        net-tools \
			dnsutils

# Add health check script
# ADD docker-health.sh /docker-health.sh
# RUN chmod +x /docker-health.sh

ADD route.sh /usr/local/bin/
RUN mv /usr/local/bin/route.sh /usr/local/bin/route \
    && chmod +x /usr/local/bin/route
# Expose ports
# EXPOSE 12679/tcp
# EXPOSE 27015/udp 27015/udp

# Setup health checks
ADD health.sh /health.sh
RUN chmod +x /health.sh
HEALTHCHECK --interval=5s --retries=1 CMD /health.sh

# Setup OGPManager
CMD ["route"]

# Setup HealthCheck
# HEALTHCHECK CMD ./docker-health.sh
