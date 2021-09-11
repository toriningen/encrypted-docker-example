FROM ubuntu AS dec-stage
ENV DEDIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y openssl

FROM dec-stage AS enc-stage
RUN apt-get install -y squashfs-tools

# ===== ORIGINAL STARTS HERE =====
FROM python:3.9 AS app-stage

# some dependency
RUN pip3 install pychalk

COPY app /app
WORKDIR /app
CMD ["python3", "./main.py"]
# ===== ORIGINAL ENDS HERE =====

FROM enc-stage AS enc-stage
RUN --mount=type=bind,from=app-stage,source=/,target=/plain-root,readonly mksquashfs /plain-root /image.squashfs
RUN --mount=type=secret,id=run-password openssl enc -aes-256-cbc -pbkdf2 -pass file:/run/secrets/run-password -in /image.squashfs -out /image.squashfs.enc

FROM dec-stage AS dec-stage
COPY --from=enc-stage /image.squashfs.enc /enc/
COPY /enc /enc

ENTRYPOINT ["/enc/entry.sh"]


