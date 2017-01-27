# docker-ssh

An Alpine image with OpenSSH tools and rsync. The only user available is root,
so some attention is needed when modifying or mounting content inside this container.

# Uses

Just provide a server to someone

```sh
export PUBLIC_KEY="ssh-rsa ..."
docker run --rm --name sshserver \
           -e AUTHORIZED_KEYS="$PUBLIC_KEY" \
           -it montefuscolo/ssh
           
```


Provide a server with some content, but remember user inside container is root.

```sh
export PUBLIC_KEY="ssh-rsa ..."
docker run --rm --name sshserver \
           -e AUTHORIZED_KEYS="$PUBLIC_KEY" \
           -v /data:/data \
           -it montefuscolo/ssh
           
```


Use it with some CI/CD system, like gitlab. Example of `.gitlab-ci.yml`:

```yml
image: montefuscolo/ssh

before_script:
  - eval $(ssh-agent -s)
  - mkdir -m 700 -p ~/.ssh
  - echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_rsa
  - chmod 600 ~/.ssh/id_rsa
  - ssh-add ~/.ssh/id_rsa

deploy
  script:
    - rsync -av -e 'ssh -o StrictHostKeyChecking=no' html/ remoteuser@remoteserver.com:/var/www/html/
    
```


