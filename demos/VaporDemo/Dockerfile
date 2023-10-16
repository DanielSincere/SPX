FROM --platform=linux/x86-64 index.docker.io/library/swift:5.9-focal as builder
WORKDIR /src
COPY ./Package.* ./
COPY ./Sources ./Sources
COPY ./Tests ./Tests
RUN swift build -c release --arch x86_64 -Xswiftc -g
RUN mkdir /output
RUN cp $(swift build -c release --arch x86_64 -Xswiftc -g --show-bin-path)/Run /output/Run

FROM index.docker.io/library/swift:5.9-focal-slim as prod_base
RUN useradd --user-group --create-home --system --skel /dev/null --home-dir /app vapor
WORKDIR /app
COPY --from=builder --chown=vapor:vapor /output/* /app
COPY --from=builder /usr/lib/swift/ /usr/lib/swift/
USER vapor:vapor

FROM prod_base as web
ENV PORT 80
EXPOSE $PORT
CMD /app/Run serve --env production --hostname 0.0.0.0 -p $PORT

FROM prod_base as release
CMD /app/Run migrate -y --env production

FROM prod_base as worker
CMD /app/Run queues --env production

FROM prod_base as scheduled-worker
CMD /app/Run queues --scheduled --env production
