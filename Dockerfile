FROM python:3.7 as builder

ADD . /app
WORKDIR /app

RUN pip install --no-cache-dir pyinstaller staticx -r requirements.txt

RUN apt-get update && apt-get install -y patchelf

RUN pyinstaller --log-level=DEBUG --onefile --name plexdl plexdl/cli.py
RUN staticx dist/plexdl dist/plexdl-static

FROM busybox

COPY --from=builder /app/dist/plexdl-static /plexdl

ENV PLEXDL_USER PLEXDL_USER
ENV PLEXDL_PASS PLEXDL_PASS

CMD ["/plexdl"]
