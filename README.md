# k3s_rpi_jenkins - How To Setup Jenkins on RPI Kubernetes Cluster
Jenkins server container on RPI (Raspberry PI 3) k3s (Kubernetes) cluster, the instruction is based on two RPI board cluster (1 master node and 1 worker node)

## A. Setup Kubernetes Kluster 

### Setting up at least 2 Pi Board (1 master, and N number of worker)
Setting static ip (you could use whatever ip you like):     
pi-master 192.168.0.201      
pi-worker01 192.168.0.202     

### Pi USB Card Preparation - master

    1. Download lite version of Raspbian Raspberry Pi OS Lite
        https://downloads.raspberrypi.org/raspios_lite_armhf/images/raspios_lite_armhf-2021-05-28/2021-05-07-raspios-buster-armhf-lite.zip
    
    2. Unzip and flash the image file to USB drive with at least 32 GB (using balenaEtcher or any prefer tool)
        https://www.balena.io/etcher/
        
    3. nano /etc/hosts 
        127.0.0.1       localhost
        ::1             localhost ip6-localhost ip6-loopback
        ff02::1         ip6-allnodes
        ff02::2         ip6-allrouters

        127.0.1.1               pi-master01
        
    4. nano /etc/hostname
        pi-master01
         
    5. cd /boot
    6. touch ssh
    
    
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
       - to get token for worker pi
        

### Kubernetes (k3s) Setup - Worker  (login to the Pi board using ssh or whatever prefer method)
    1. To add worker cluster:
       curl -sfL https://get.k3s.io | K3S_URL=https://192.168.0.201:6443 K3S_TOKEN=K10fed596e32cd619187e5351dcdbf52335aaea39ba52ca6933e3dd0c722483a1a9::server:55846f592aeffabb8c7ac70b7e3c3899 sh -

***Do the same steps above if you have more than 1 pi-workerX***


## B. Setup Jenkins Server on k3s (Kubernetes) cluster   
***YAML files mentioned below uploaded to this repo***   
***Customized Jenkins Docker Image Dockerfile could be found in this repo and upstream to https://hub.docker.com/repository/docker/yockgen/rpijenkins***  

    1. kubectl create namespace jenkins
    2. kubectl create -f jenkins-pvc.yaml -n jenkins
    3. kubectl create -f jenkins-deployment.yaml -n jenkins
    4. kubectl get pods -n jenkins -o wide
    5. kubectl create -f jenkins-service.yaml --namespace jenkins
    6. kubectl get services -n jenkins -o wide
    8. kubectl logs -n jenkins jenkins-deployment-{...random hash....}

## C. Access Jenkins via browser

http://[master server ip]:30000/

## D. To remove everything from namespace  
kubectl delete all --all -n jenkins  
kubectl delete namespace jenkins  

## F. To refresh deployment   
kubectl rollout restart deployment/jenkins-deployment
