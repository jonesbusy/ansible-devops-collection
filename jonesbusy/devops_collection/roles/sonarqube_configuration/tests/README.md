# Tests

Install roles and collections

```
ansible-galaxy -vv role install -r requirements.yml -f -p roles
ansible-galaxy -vv collection install -r requirements.yml -f -p collections
```

## Run test

```
ansible-playbook -e "@vars/lan.yml" -e "@vars/test-config.yml" -vv --tags users main.yml
```