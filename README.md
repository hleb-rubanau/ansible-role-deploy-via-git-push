## 

### requirements.yml

Add following to `requirements.yml`: 

```
- src: https://github.com/hleb-rubanau/ansible-role-deploy-via-git-push
  name: deploy-via-git-push
```

Run `ansible-galaxy install -r requirements.yml roles/`

### Ansible variables


1. ```deployment_project``` -- symbolic name of the recipes set (is used in logging etc.)
2. ```deployment_command``` -- command to run inside git repo to deploy the configuration (default: deploy.sh)
3. ```deployment_user```  (optional, default: `deploy`)  -- system user who serves as git receiver
4. ```deployment_commiters``` (optional, default: `[]`) -- keys for users allowed to push as `deployment\_user`
5. ```deployment_git_branch``` (optional, default: `master`)) -- branch to switch to
6. ```deployment_subdir``` (optional, default: `''`) -- subdirectory inside git repo to switch to before running command
    
# In playbook:
Add role deploy-via-git-push

# Simplest ad-hoc invocation:

```
< setting config variables skipped >

ansible-galaxy install -p roles git+https://github.com/hleb-rubanau/ansible-role-deploy-via-git-push
ansible localhost -m import_role -a name=ansible-role-deploy-via-git-push
```
