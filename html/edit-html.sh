    #!/bin/bash
    
    # Get kubernetes information and export data from variable
    export CONTAINER_NAME=$(echo $CONTAINER_NAME)
    export POD_IP=$(echo $POD_IP)
    export CLUSTER_NAME=$(echo $CLUSTER_NAME)
    
    # Edit html file placeholders provided by nrich
    sed -i "s/{container_name}/$CONTAINER_NAME/g" /usr/share/nginx/html/index.html
    sed -i "s/{pod_ip}/${POD_IP}/g" /usr/share/nginx/html/index.html
    sed -i "s/{cluster_name}/${CLUSTER_NAME}/g" /usr/share/nginx/html/index.html