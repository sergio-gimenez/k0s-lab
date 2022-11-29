#!/bin/sh
set -x

get_node_names_in(){
    cluster=$1
    all_container_names=$(docker ps --format "{{.Names}}")
    echo "$all_container_names" | grep "k3d-$cluster-server-"
}

configure_rina_cni_in(){
    node_names=$1
    for node_name in $node_names; do        
        get_shell=$(docker exec -it $node_name sh)
        docker exec -it $node_name ash -c "git clone https://github.com/sergio-gimenez/rina-cni-plugin.git"


git clone https://github.com/sergio-gimenez/rina-cni-plugin.git



# Install RINA CNI in node0 and node1
for node in nodes; do
    # Clone the RINA CNI repository
    footloose -c footloose-rina.yaml ssh root@$node -- "git clone https://github.com/sergio-gimenez/rina-cni-plugin.git"
    
    # Copy the RINA plugin into CNI plugins directory
    footloose -c footloose-rina.yaml ssh root@$node -- "cp rina-cni-plugin/rina-cni /bin"
    
    # Set few Iptables rules to enable propper connectivity
    footloose -c footloose-rina.yaml ssh root@$node -- "rina-cni-plugin/demo/base_init.sh"
    
    # Copy the custom configuration file
    footloose -c footloose-rina.yaml ssh root@$node -- "cp rina-cni-plugin/demo/my-cni-demo_master.conf /etc/cni/net.d/"
done

