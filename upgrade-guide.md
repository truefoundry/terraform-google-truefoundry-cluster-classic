# terraform-google-truefoundry-cluster-autopilot

This guide will help you to migrate your terraform code across versions. Keeping your terraform state to the latest version is always recommeneded

## Upgrade guide from 0.3.x to 0.4.x

Changes, we introduced `use_existing_cluster` variable, which allows you to use an existing cluster.
Few Modules are shifted to using count block to support this feature.

1. Ensure that you are running on the latest version of 0.3.x
2. Move to `0.4.0` and run the following command

    ```bash
    terraform init -upgrade

    terraform state mv 'google_container_cluster.cluster' 'google_container_cluster.cluster[0]'
    terraform state mv 'google_container_node_pool.generic' 'google_container_node_pool.generic[0]'
    terraform state mv 'google_container_node_pool.control_plane_pool' 'google_container_node_pool.control_plane_pool[0]' # If control plane is enabled, else skip this step
    ```

3. Run terraform plan to check if there are is diff

    ```bash
    terraform plan
    ```
