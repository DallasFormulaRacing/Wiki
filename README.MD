## Running Natively

Install dependencies:
```
pip install mkdocs
pip install mkdocs-material
pip install mkdocs-glightbox
pip install mkdocs-git-revision-date-localized-plugin
```
- And, install git.

Switch to the directory with the `mkdocs.yml` file:
```
cd wiki-site/
```

Build the docs and run a server:

```
mkdocs serve
```

Access the pages through the browser through [localhost:8000](http://localhost:8000/).

*Note*: On Windows, the `mkdocs` commands may have to be preceded with `python3 -m`.

## Running on a Docker Container

At the root project directory, build the Docker image:

```
docker build -t ubuntu-wiki-image .
```

Using this image, create and run a Docker container allowing for port-forwarding and mounting the project files:

```
docker run --rm -it --init -p 8000:8000 --name docs-wiki-container -v .:/Wiki ubuntu-wiki-image
```