# BUILD Stage
FROM alpine:latest AS builder

LABEL maintainer="imquanquan <imquanquan99@gmail.com>"

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \ 
	apk update && apk add --no-cache git && rm -rf /var/cache/apk/* && \
	git clone https://github.com/SCAULUG/Mirrors-Scripts.git

# DIST Stage
FROM alpine:latest


RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && \
	apk update && apk add --no-cache ca-certificates dcron bash rsync tzdata&& \
	rm -rf /var/cache/apk/* && \
        ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
        echo "Asia/Shanghai" > /etc/timezone && \
	mkdir /mirrors

COPY --from=builder /Mirrors-Scripts /Mirrors-Scripts
COPY ./rsync-cron /etc/crontabs/root

CMD crond && tail -f /Mirrors-Scripts/README.md
