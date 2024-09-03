# Fetch the Ubuntu image as a base
FROM ubuntu:22.04

# Install dependencies
RUN \
    apt-get update && \
    apt-get install -y git && \
    apt-get install -y python3 && \
    apt-get install -y python3-pip && \
    pip install mkdocs && \
    pip install mkdocs-material && \
    pip install mkdocs-glightbox && \
    pip install mkdocs-git-revision-date-localized-plugin

EXPOSE 8000
# RUN echo $(pwd)
WORKDIR "/Wiki/"
# # RUN echo $(pwd)
CMD ["mkdocs", "serve", "--dev-addr", "0.0.0.0:8000"]