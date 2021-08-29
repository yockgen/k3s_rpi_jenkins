# k3s_rpi_jenkins
Jenkins container on RPI (Raspberry PI 3) Kubernetes K3s cluster

## To build RPI 3 board cluster   

### Setting up at least 2 Pi Board (1 master, and N number of worker)
Setting static ip (you could use whatever ip you like):     
pi-master 192.168.0.201      
pi-worker01 192.168.0.202     

### Pi USB Card Preparation

    1. nano /etc/hosts 
    2. nano /etc/hostname
    3. Add static ip in /boot/cmdLine.txt after “wait” 
    4. cd /boot, touch ssh
    5. passwd
    6. cat /proc/cpuinfo
    7. sudo apt update && sudo apt dist-upgrade
    8. sudo nano /boot/cmdline.txt
    9. cat nano /boot/cmdline.txt
    10. console=serial0,115200 console=tty1 root=PARTUUID=9d986cdb-02 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory ip=192.168.0.201   
   
### Boot Pi Board

   1. sudo -i
   2. free -m
   3. sudo dphys-swapfile swapoff
   4. free -m
   5. sudo dphys-swapfile uninstall
   6.  sudo apt purge dphys-swapfile
   7.   sudo reboot 
   8.  curl -sSL get.docker.com | sh
   9.  sudo usermod -aG docker pi
   10.  logout
   11. login again 
   12. sudo nano  /etc/docker/daemon.json 
  {
     "exec-opts": ["native.cgroupdriver=systemd"],
     "log-driver": "json-file",
     "log-opts": {
       "max-size": "100m"
     },
     "storage-driver": "overlay2"
   }
   13. reboot



29 curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644

30 kubectl get pods -A
31 to get token for worker pi
sudo cat /var/lib/rancher/k3s/server/token

32. To add worker cluster:
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.0.201:6443 K3S_TOKEN=K10fed596e32cd619187e5351dcdbf52335aaea39ba52ca6933e3dd0c722483a1a9::server:55846f592aeffabb8c7ac70b7e3c3899 sh -



