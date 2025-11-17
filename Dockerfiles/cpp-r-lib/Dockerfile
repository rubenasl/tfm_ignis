ARG REGISTRY=""
ARG NAMESPACE="ignishpc/"
ARG TAG=""
FROM ${REGISTRY}${NAMESPACE}builder${TAG}

ARG DOCK_DIR=""
ENV IGNIS_HOME=/opt/ignis

USER root

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y \
    r-base r-base-dev \
    libcurl4-openssl-dev libssl-dev libxml2-dev \
    libreadline-dev libx11-dev libxt-dev \
    gfortran libbz2-dev liblzma-dev libpcre2-dev \
    wget git make g++ libtirpc-dev && \
    apt-get clean

# Instalar RInside y Rcpp desde CRAN
RUN Rscript -e "install.packages(c('RInside', 'Rcpp'), repos='https://cloud.r-project.org')"

# Copiar headers de RInside
RUN mkdir -p /usr/local/include/RInside && \
    cp -r /usr/local/lib/R/site-library/RInside/include/* /usr/local/include/RInside && \
    cp /usr/local/lib/R/site-library/RInside/lib/libRInside.so* /usr/local/lib/ || true

# Copiar headers de Rcpp
RUN mkdir -p /usr/local/include/Rcpp && \
    cp -r /usr/local/lib/R/site-library/Rcpp/include/* /usr/local/include/Rcpp

# Compilar r_demo
COPY ${DOCK_DIR}lib/main.cpp /tmp/main.cpp
RUN g++ -std=c++11 -o /opt/ignis/bin/r_demo /tmp/main.cpp \
    -I/usr/local/include/RInside \
    -I/usr/local/include/Rcpp \
    $(R CMD config --cppflags) \
    $(R CMD config --ldflags) \
    -L/usr/local/lib -lRInside

# Copiar scripts binarios y de instalación
COPY ${DOCK_DIR}bin/* ${IGNIS_HOME}/bin/
RUN chmod +x ${IGNIS_HOME}/bin/* || true
RUN ${IGNIS_HOME}/bin/ignis-cpp-r-install.sh || true

# Copiar runtime personalizado
COPY ${DOCK_DIR}bin/r.runtime /opt/ignis/bin/r.runtime
RUN chmod +x /opt/ignis/bin/r.runtime


COPY ${DOCK_DIR}bin/exec_r_demo.sh /opt/ignis/bin/exec_r_demo.sh
RUN chmod +x /opt/ignis/bin/exec_r_demo.sh


COPY ${DOCK_DIR}lib/ignis.R /opt/ignis/lib/R/ignis.R




RUN ln -sf /opt/ignis/bin/r.runtime /usr/bin/Rscript

ENV LD_LIBRARY_PATH="/usr/lib/R/lib:/usr/local/lib:/usr/local/lib/R/site-library/RInside/lib:$LD_LIBRARY_PATH"

ENTRYPOINT ["Rscript"]
