# Galaxy for BRIDGE
# VERSION       0.2
# FROM bgruening/galaxy-stable
FROM bgruening/galaxy-stable:19.05.1
LABEL \
  description="Galaxy BRIDGE" \
  maintainer="chrisbarnettster@gmail.com, snptha002@myuct.ac.za, dlskyl001@myuct.ac.za"

ENV GALAXY_CONFIG_BRAND BRIDGE

# --- This section to be removed soon, as tools get added to the Galaxy Toolshed #
# Install manual tools 
RUN /tool_deps/_conda/bin/conda install -c conda-forge mamba
RUN /tool_deps/_conda/bin/mamba create  -y --override-channels --channel kdilsook --channel michellab --channel bioconda --channel r --channel conda-forge --channel anaconda --channel defaults --channel iuc --channel cbarnett --channel omnia --channel psi4 --channel rdkit --channel pytorch --channel bioconda --name __protocaller@1.2.2 protocaller
WORKDIR /galaxy-central
COPY BRIDGE /galaxy-central/tools/bridge
COPY my_tools.xml /galaxy-central/config/tool_conf.xml
COPY galaxy.yml /galaxy-central/config/galaxy.yml
#ADD  executables /galaxy-central/tools/bridge/md_tools/
# Changing the ownership
RUN chown -R $GALAXY_USER:$GALAXY_USER /galaxy-central/tools/bridge
RUN chown $GALAXY_USER:$GALAXY_USER /galaxy-central/config/galaxy.yml
RUN chown $GALAXY_USER:$GALAXY_USER /export//tool_deps/_conda/bin/mamba
# ---

# Styling
ADD welcome.html /etc/galaxy/web/welcome.html
ADD welcome.html /galaxy-central/static/welcome.html
ADD welcome.html /galaxy-central/static/welcome.html.sample

# Expose port 80 (webserver), 21 (FTP server), 8800 (Proxy)
EXPOSE :80
EXPOSE :21
EXPOSE :8800

# Autostart script that is invoked during container start
CMD ["/usr/bin/startup"]

