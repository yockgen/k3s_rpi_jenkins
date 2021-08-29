# k3s_rpi_jenkins
Jenkins container on RPI (Raspberry PI 3) Kubernetes K3s cluster

## To build RPI 3 board cluster   

### Setting up at least 2 Pi Board (1 master, and N number of worker)
Setting static ip (you could use whatever ip you like):     
pi-master 192.168.0.201      
pi-worker01 192.168.0.202     

### Pi USB Card Preparation

    1. nano /etc/hosts 
        127.0.0.1       localhost
        ::1             localhost ip6-localhost ip6-loopback
        ff02::1         ip6-allnodes
        ff02::2         ip6-allrouters

        127.0.1.1               pi-master01
        
    2. nano /etc/hostname
        pi-master01
         
    4. cd /boot
    5. touch ssh
    
    
***Do the same steps above for worker USB card but replace 'pi-master' text with 'pi-worker01' for example, the same steps if you have more than 1 pi-workerX)***
    
    
### Boot Pi Board with USB card - setup environment  (login to the Pi board using ssh or whatever prefer method)
    1. sudo -i
    2. passwd
    3. sudo apt update && sudo apt dist-upgrade
    4. sudo nano /boot/cmdline.txt
    5. nano /boot/cmdline.txt
        console=serial0,115200 console=tty1 root=PARTUUID=9d986cdb-02 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory ip=192.168.0.201
        
     6. free -m
     7. sudo dphys-swapfile swapoff
     8. free -m
     9. sudo dphys-swapfile uninstall
    10. sudo apt purge dphys-swapfile
    11. sudo reboot 
    12. curl -sSL get.docker.com | sh
    13. sudo usermod -aG docker pi
    14. sudo nano  /etc/docker/daemon.json 
        {
         "exec-opts": ["native.cgroupdriver=systemd"],
         "log-driver": "json-file",
         "log-opts": {
           "max-size": "100m"
         },
         "storage-driver": "overlay2"
       }
       
   12. reboot


### Kubernetes (k3s) Setup - Master  (login to the Pi board using ssh or whatever prefer method)
    1. sudo -i
    2. curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644
    3. kubectl get pods -A
    4. sudo cat /var/lib/rancher/k3s/server/token
        to get token for worker pi
        
        
32. To add worker cluster:
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.0.201:6443 K3S_TOKEN=K10fed596e32cd619187e5351dcdbf52335aaea39ba52ca6933e3dd0c722483a1a9::server:55846f592aeffabb8c7ac70b7e3c3899 sh -



