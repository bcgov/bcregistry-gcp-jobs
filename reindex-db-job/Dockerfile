FROM python:3.10-slim-buster
USER root

ARG VCS_REF="missing"
ARG BUILD_DATE="missing"

ENV VCS_REF=${VCS_REF}
ENV BUILD_DATE=${BUILD_DATE}
ENV OC_VERSION "v3.11.0"
ENV OC_RELEASE "openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit"

LABEL org.label-schema.vcs-ref=${VCS_REF} \
  org.label-schema.build-date=${BUILD_DATE}

USER root

# Create working directory
RUN mkdir /opt/app-root && chmod 755 /opt/app-root
WORKDIR /opt/app-root

# install the oc client tools
ADD https://github.com/openshift/origin/releases/download/$OC_VERSION/$OC_RELEASE.tar.gz /opt/oc/release.tar.gz
RUN tar --strip-components=1 -xzvf  /opt/oc/release.tar.gz -C /opt/oc/ && \
    mv /opt/oc/oc /usr/bin/ && \
    rm -rf /opt/oc

# Install the requirements
COPY ./requirements.txt .

RUN pip install pip==20.1.1
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Set Python path
ENV PYTHONPATH=/opt/app-root

EXPOSE 8080

CMD [ "/bin/sh", "run.sh" ]
