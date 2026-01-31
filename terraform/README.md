## 🛠️ Infrastructure Setup

### 1. Proxmox Permissions (Least Privilege)

To manage the infrastructure with Terraform without using the `root` account, follow these steps to create a dedicated user and role.

#### A. Create the Custom Role

Create the custom role named **TerraformRole** with following privileges (see command) using Proxmox UI by navigating to **Datacenter > Permissions > Roles** or Run this command in the **Proxmox Host Shell** to create a role with the specific privileges required for Cloud-init and VM management:

```bash
pveum role add TerraformRole -privs "Datastore.Allocate Datastore.AllocateSpace Datastore.Audit SDN.Use Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.CPU VM.Config.Cloudinit VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Console VM.PowerMgmt"
```

#### B. Create the User & API Token

1. **Create User**: Go to **Datacenter > Permissions > Users** and add a user named `terraform-user@pve`.
2. **Generate Token**: Go to **API Tokens**, select the user, and set the Token ID to `terraform`.
* **Important**: Uncheck "Privilege Separation" so the token inherits the user's permissions.


3. **Save Secret**: Copy the **Secret Value** immediately; you will need it for your `.env` file.

#### C. Assign ACL Permissions

Assign the role to the user at the Datacenter level to ensure it can manage resources across the node:

1. Go to **Datacenter > Permissions**.
2. Click **Add > User Permission**.
3. Set **Path** to `/`, **User** to `terraform-user@pve`, and **Role** to `TerraformRole`.
4. Ensure **Propagate** is checked.

---

### 2. Local Environment Configuration

This project uses a `.env` file to handle secrets safely.

1. Copy the example template:
```bash
cp .env.example .env
```


2. Fill in your specific Proxmox details in `.env`:
* `TF_VAR_proxmox_api_url`: Your PVE IP (e.g., `https://192.168.18.100:8006/`)
* `TF_VAR_proxmox_api_token_id`: `terraform-user@pve!terraform`
* `TF_VAR_proxmox_api_token_secret`: The secret UUID you saved earlier.

* `TF_VAR_ssh_public_key`: `your_public_ssh_key_here`
* `TF_VAR_ci_password`: `password`

---

### 3. Deployment

The `run_tf.sh` script wraps Docker Compose to run Terraform commands inside a consistent container environment.

```bash
# To preview changes
./run_tf.sh plan pve

# To deploy the cluster
./run_tf.sh apply pve

# To tear down the cluster
./run_tf.sh destroy pve
```

---

### 4. SSH Troubleshooting

If you recreate VMs and get a `REMOTE HOST IDENTIFICATION HAS CHANGED` error, clear the old key from your local machine:

```bash
ssh-keygen -R <VM_IP_ADDRESS>
```

---