# Dallas Formula Racing Techinical Wiki

There are two options for opening this wiki - however, Docker Container is recommended for easy deployment across platforms.

Please note that CTRL+C will end the session on either method. Use another terminal tab if necessary.

## METHOD 1: Running on a Docker Container

1. Download Docker, and ensure it is running.

2. At the root project directory, build the Docker image:

```
docker build -t ubuntu-wiki-image .
```

> _Note:_ Building the image may take a while if it is your first time.

3. Using this image, create and run a Docker container allowing for port-forwarding and mounting the project files:

```
docker run --rm -it --init -p 8000:8000 --name docs-wiki-container -v .:/Wiki ubuntu-wiki-image
```

4. Open the provided address in browser or use `open`.

> _Note_: You may run into an error when you try to run if you did not close your last container properly. Open the collapsible below if this happens.

<details>

<summary>docker daemon error guide</summary>

Your error will look something like this:

```
docker: Error response from daemon: Conflict. The container name "/docs-wiki-container" is already in use by container "<<RANDOMLETTERS&NUMBERS>>". You have to remove (or rename) that container to be able to reuse that name.
```

To fix, run the `docker ps -a` to list all active containers.

Then either `remove` or `stop` the container(s) that you want with their `CONTAINER_ID`: to remove an idle container, use `docker rm CONTAINER_ID` and to stop an active container, use `docker stop CONTAINER_ID`.

After you run the appropriate command(s), attempt to build and run again.

</details>

## METHOD 2: Running Natively

> _Note for MacOS users_: You may experience errors while using `pip install`. Open the collapsible below if needed or skip to step 1 if this does not apply to you.

<details>

<summary>pip error guide</summary>

### 0. `pip` error workaround:

1. Install Python if needed

   If, in the past, you installed Xcode through the terminal, you already have Python3.

   Otherwise download through the official website, curl it or `brew install python`.

2. Create a python virtual environment within your project directory

   Navigate to your project directory.

```
cd /XXXX/YYYY/Wiki/wiki-site
```

3. In your project directory, create the virtual environment called `venv` with

```
python3 -m venv venv
```

4. Activate `venv` using

```
source venv/bin/activate
```

5.  Add the following code to your .gitignore file to ensure you do not have ten thousand unstaged changes:

```
wiki-site/site/

/build/
/dist/
wiki-site/venv/
wiki-site/venv/bin/
wiki-site/venv/include/
wiki-site/venv/lib/
```

6. Go to Step 1 below and start installing dependencies.

   When you are finished browsing the wiki, exit/deactivate the virtual environment with `deactivate`.

</details>

### 1. Install dependencies:

```
pip install mkdocs
pip install mkdocs-material
pip install mkdocs-glightbox
pip install mkdocs-git-revision-date-localized-plugin
```

### 2. Building

> _Note for Windows users_: You may need to prepend `python3 -m` to the `mkdocs` commands below.

Switch to the directory with the `mkdocs.yml` file with

```
cd wiki-site/
```

Then execute the following:

```
mkdocs build
mkdocs serve
```

If you run into trouble here, try deactivating and reactivating your virtual environment.

Access the pages through the browser through [localhost:8000](http://localhost:8000/).
