FROM alpine:latest

# Install necessary packages
RUN apk --no-cache add ca-certificates \
                     mailcap \
                     curl \
                     jq

# Copy healthcheck script and make it executable
COPY healthcheck.sh /healthcheck.sh
RUN chmod +x /healthcheck.sh

# Set up healthcheck
HEALTHCHECK --start-period=2s --interval=5s --timeout=3s \
    CMD /healthcheck.sh || exit 1

# Create the /filebrowser directory
RUN mkdir -p /filebrowser

# Expose the necessary port
EXPOSE 3030

# Copy configuration file
COPY docker_config.json /.filebrowser.json

# Copy all other files from the current directory to /filebrowser
COPY . /filebrowser/

# Set the entry point for the container
ENTRYPOINT [ "/filebrowser" ]
