#!/bin/bash

# The number of nodes for installing OpenStack on
#   - for minimal non-HA installation, specify 2 (1 controller + 1 compute)
#   - for minimal non-HA with Cinder installation, specify 3 (1 ctrl + 1 compute + 1 cinder)
#   - for minimal HA installation, specify 4 (3 controllers + 1 compute)
cluster_size=2

# Every Fuel Web machine name will start from this prefix
env_name_prefix=fw-okravchenko-

#Use bridge interface: 0 - false, 1 - true. If you have existing bridge with pysical NIC you can use it for VMs. Bridged network will be created as eth1 in guest OS.
use_bridge=0
#Bridge name (if use_bridge=1)
br_name="br100"
# If you need to automatically configure network interface on master node after its deployment, follow these steps:
# 1. set 'iface' name (example: iface="eth1.325")
# 2. uncomment ./actions/create_pub_net_master.sh script in launch.sh
# 3. create ./ifcfg-${iface} config file with needed settings for interfae
iface="eth1"

#networks definition: id, list of host IP's for ech network. The first network will be used for provisioning
idx=160
netmask=255.255.255.0

# Generate network params
for ip in 10.20.101.1 172.16.2.1; do
#for ip in 10.20.0.1 240.0.1.1 172.16.0.1; do
  host_net_name[$idx]="${env_name_prefix}${idx}"
  host_net_bridge[$idx]="virbr${idx}"
  host_nic_ip[$idx]="$ip"
  host_nic_mask[$idx]="255.255.255.0"
  idx_list+=" $idx"
  idx=$((idx+1))
done

# Master node settings
vm_master_cpu_cores=2
vm_master_memory_mb=1224
vm_master_disk_gb=40

# These settings will be used to check if master node has installed or not.
# If you modify networking params for master node during the boot time
#   (i.e. if you pressed Tab in a boot loader and modified params),
#   make sure that these values reflect that change.
vm_master_ip=10.20.101.2
vm_master_username=root
vm_master_password=r00tme
vm_master_prompt='root@fuelweb ~]#'

# Slave node settings
vm_slave_cpu_cores=2

# This section allows you to define RAM size in MB for each slave node.
# Keep in mind that PXE boot might not work correctly with values lower than 768.
# You can specify memory size for the specific slaves, other will get default vm_slave_memory_default
vm_slave_memory_default=768
vm_slave_memory_mb[1]=1280   # for controller node 768 MB should be sufficient
vm_slave_memory_mb[2]=1280  # for compute node 1GB is recommended, otherwise VM instances in OpenStack may not boot
vm_slave_memory_mb[3]=768   # for a dedicated Cinder node 768 MB should be sufficient

# This section allows you to define HDD size in MB for all the slaves nodes.
# All the slaves will have identical disk configuration. Each slave will have three disks of the following sizes.
vm_slave_first_disk_mb=25600
vm_slave_second_disk_mb=25600
vm_slave_third_disk_mb=23000


domain_name="mirtest.net"
