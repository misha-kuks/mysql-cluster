## This project deploy 9 VMs ubuntu-server 20.04 on PVE.
- 2 VMs haproxy loadbalancer
- 2 VMs frontend stateless servers with nginx web server.
- 2 VMs backend with GlusterFS cluster, which include statefull content for web servers.
- 3 VM mariadb-server, Galera cluster inside worpdpress database here.


## Create terraform.tfvars file which include:
- pve_ip_address = "IPv4" 
- pm_user = "root@pam" 
- pm_password = "PASS" 
- proxmox_host = "HOSTNAME" 
- template = "ubuntu-focal64 or you template" 
- storage = "YOUR STORAGE"

## To start deploy run:
1. terraform apply
2. ansible-playbook site.yml

## Scheme:

![image](screens/mysql-cluster.png)

## Galera cluster check status from db1:

- show status like 'wsrep_cluster_status';
- show status like 'wsrep_cluster_size';
- show status like 'wsrep_local_state_comment';

![image](screens/wsrep_db1.png)

### Check after crash 1 VM:

- show status like 'wsrep_cluster_status';
- show status like 'wsrep_cluster_size';
- show status like 'wsrep_local_state_comment';

![image](screens/wsrep_db2_after_crash.png)

- visit http://demosite.local

![image](screens/demo_after_dbcrash.png)

- All work fine!!!

## Check keepalived on haproxy2 after down haproxy1:

### haproxy2:

![image](screens/keepalived_haproxy2.png)

### haproxy1:

![image](screens/keepalived_haproxy1.png)

### Check glusterfs volume on backends nodes:


![image](screens/gluster_volume.png)

## Check glusterfs client on web servers:

### web1:

![images](screens/web1_glusterclient.png)

### web2:

![images](screens/web2_gluster_client.png)

## Check content of /srv/www/demosite.local

![image](screens/content_back1.png)

![image](screens/content_back2.png)

![image](screens/content_web1.png)

![image](screens/content_web2.png)

## Check http://demosite.local

![image](screens/demosite.png)

