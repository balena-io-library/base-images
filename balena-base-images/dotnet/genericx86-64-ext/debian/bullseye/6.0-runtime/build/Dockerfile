# AUTOGENERATED FILE
FROM balenalib/genericx86-64-ext-debian:bullseye-build

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        \
# .NET Core dependencies
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        libicu67 \
        libssl1.1 \
        libstdc++6 \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Configure web servers to bind to port 80 when present
ENV ASPNETCORE_URLS=http://+:80 \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true

# Install .NET Core
ENV DOTNET_VERSION 6.0.13

RUN curl -SL --output dotnet.tar.gz "https://dotnetcli.blob.core.windows.net/dotnet/Runtime/$DOTNET_VERSION/dotnet-runtime-$DOTNET_VERSION-linux-x64.tar.gz" \
    && dotnet_sha512='af52e1df5e48a1b7465f8137048e9ec292104526c65e415055e5f4630a13f1d4974ae831a143dd4f17e2a813502d90e2c0aef37c6b1eb7a23d01af7ffca5400a' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

CMD ["echo","'No CMD command was set in Dockerfile! Details about CMD command could be found in Dockerfile Guide section in our Docs. Here's the link: https://balena.io/docs"]

 RUN curl -SLO "https://raw.githubusercontent.com/balena-io-library/base-images/44e597e40f2010cdde15b3ba1e397aea3a5c5271/scripts/assets/tests/test-stack@dotnet.sh" \
  && echo "Running test-stack@dotnet" \
  && chmod +x test-stack@dotnet.sh \
  && bash test-stack@dotnet.sh \
  && rm -rf test-stack@dotnet.sh 

RUN [ ! -d /.balena/messages ] && mkdir -p /.balena/messages; echo 'This base image is deprecated and will no longer receive updates. Please see our blog post (https://blog.balena.io/deprecate-balenalib-images/) for migration guidance and suggested alternatives. Here are a few details about this Docker image (For more information please visit https://www.balena.io/docs/reference/base-images/base-images/): \nArchitecture: Intel 64-bit (x86-64) \nOS: Debian Bullseye \nVariant: build variant \nDefault variable(s): UDEV=off \nThe following software stack is preinstalled: \ndotnet 6.0-runtime \nExtra features: \n- Easy way to install packages with `install_packages <package-name>` command \n- Run anywhere with cross-build feature  (for ARM only) \n- Keep the container idling with `balena-idle` command \n- Show base image details with `balena-info` command' > /.balena/messages/image-info