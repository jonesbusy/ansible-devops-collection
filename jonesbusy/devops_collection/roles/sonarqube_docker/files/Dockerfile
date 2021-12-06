# 8.x
ARG sonarqube_docker_sonarqube_version=

FROM sonarqube:${sonarqube_docker_sonarqube_version}

# Cleanup
RUN rm -f /opt/sonarqube/extensions/plugins/*.jar

# Plugins
ENV YAML_PLUGIN_VERSION=1.7.0
ENV ANSIBLE_PLUGIN_VERSION=2.5.0
ENV GROOVY_PLUGIN_VERSION=1.8

# Download plugins
RUN wget https://github.com/sbaudoin/sonar-yaml/releases/download/v${YAML_PLUGIN_VERSION}/sonar-yaml-plugin-${YAML_PLUGIN_VERSION}.jar \
    -O /opt/sonarqube/extensions/plugins/sonar-yaml-plugin-${YAML_PLUGIN_VERSION}.jar
RUN wget https://github.com/sbaudoin/sonar-ansible/releases/download/v${ANSIBLE_PLUGIN_VERSION}/sonar-ansible-plugin-${ANSIBLE_PLUGIN_VERSION}.jar \
    -O /opt/sonarqube/extensions/plugins/sonar-ansible-plugin-${ANSIBLE_PLUGIN_VERSION}.jar
RUN wget https://github.com/Inform-Software/sonar-groovy/releases/download/${GROOVY_PLUGIN_VERSION}/sonar-groovy-plugin-${GROOVY_PLUGIN_VERSION}.jar \
    -O /opt/sonarqube/extensions/plugins/sonar-groovy-plugin-${GROOVY_PLUGIN_VERSION}.jar
