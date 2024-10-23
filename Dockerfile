FROM alpine:latest
RUN apk --update add ca-certificates \
                     mailcap \
                     curl \
                     jq

COPY healthcheck.sh /healthcheck.sh
RUN chmod +x /healthcheck.sh

HEALTHCHECK --start-period=2s --interval=5s --timeout=3s \
    CMD /healthcheck.sh || exit 1

VOLUME /srv
EXPOSE 3030

COPY docker_config.json /.filebrowser.json
COPY . /filebrowser/  # This copies all files and directories from the current context to /filebrowser/

ENTRYPOINT [ "/filebrowser" ]
