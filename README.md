# Purpose

TKG, also known as TKG multicloud, leverages clusterAPI to allow you to provision a standardized Kubernetes across various infra providers. This repo is a quickstart kit that creates a virtualbox VM which can then be used to install and setup tkgcli.

# Background

TKG works on the premise of a management cluster. The management cluster is a "operational" kubernetes cluster that has custom CRD's installed, which allows you to manage individual kubernetes clusters (also known as workload clusters). These workload clusters are fully conformant complete kubernetes clusters with their own respective master and worker nodes. Before you get to setting up your workload clusters, the management cluster needs to be provisioned (read installed). This management cluster is ideally located on the same infrastructure where you intend to install your workload clusters, hence acting like a "Regional Control Plane".

The vagrantfile in the demo creates a virtualbox VM on your local machine and then, broadly, does the following things:

- You accept the T&C for, and install the tkg cli
- You use the tkg cli to initialize the UI for creating a management cluster on AWS
- You provide you AWS specific keys (essentially identity information)
- tkg cli creates a local small cluster on the VM - it's a "kind" cluster
- The "kind" cluster uses the AWS credentials you specified, to setup a management cluster on AWS
- The local "kind" cluster is deleted
- You point your tkg cli to use the management cluster on AWS
- Using the tkg cli, you can now provision fully functional and compliant kubernetes clusters on AWS - this can be done from the VM or from your local machine - windows, linux, mac etc.

Note: The reason we're doing all this installation from a Vagrant VM is so as to provide a consistent installation experience. This is not to say that the installation cannot be done from a Windows, Mac or any other Linux distro.

We will majorly be following the documentation here to do the installation: https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.1/vmware-tanzu-kubernetes-grid-11/GUID-install-tkg-aws.html 

# Pre-requisites

1. Clone this git repository on your machine
    - Download git on your machine
    - ` git clone https://github.com/karan-kapoor90/tkg-jumpbox.git`
    - Change directory into the repo `cd tkg-jumpbox`
2. Download and install VirtualBox on your machine. If you're running windows, you may need to to disable Hyper-V. Google is your friend.
    - Go to https://www.virtualbox.org/wiki/Downloads 
3. Download and install vagrant on your machine
    - Go to https://www.vagrantup.com/downloads.html 
4. Create an account at https://my.vmware.com if you don't already have one
5. This demo needs vagrant to download a ubuntu/bionic64 VM image - which can take a while
    - Inside the `tkg-jumpbox` directory, run the command `vagrant up`
    - A new virtual machine box will open up, be nice, don't close it.
    - Once the process in the terminal completes, run the command `vagrant halt`
6. Install VirtualBox Guest Add-ons
    - Open VirtualBox application on your machine. On the left hand side, you should see an entry called `tkg-jumpbox`.
    - Right Click on that and click on `Settings`
    - Navigate to the Storage tab and Click the CD icon next to Controller: IDE on the left hand side. If the option is grey, it most likely means that your VM is still running - implying you're forgotten to run `vagrant halt`
    - After clicking on the CD icon, select the `VBoxGuestAdditions.iso` file. If your filename varies slightly, that's ok.
    - Click ok/ Accept etc. and close the dialog box. What you've done is that you've inserted a CD into the Virtual Machine containing the Virtual Box Addons.
    - Now in the command line on your machine where you installed vagrant, run the command `vagrant plugin install vagrant-scp`
    - Once the previous command completes, run the command `vagrant up` to start your VM.
    - **The username and password are vagrant and vagrant respectively**
    - Once the VM comes up, there's a small icon at the bottom of the VM window which looks like a monitor. Use that to increase and decrease the size of the window to suit your screen's aspect ratio.

# Steps:

## Setting up TKG cli

1. If you've followed the pre-requisites correctly, at this point you should have a virtual machine running on your desktop, with a GUI. We now need to download the tkg CLI. Inside the VM, you will be asked to login to the machine. Select the vagrant username and type in `vagrant` as the password. 
2. Inside the virtual machine (alternatively you can download the binary on your host machine and copy it into your VM as well using the vagrant scp command), open a browser windows and login to my.vmware.com using your partner/ personal credentials
3. Navigate to https://my.vmware.com/group/vmware/downloads/details?downloadGroup=TKG-113&productId=988 to download the latest CLI **for Linux** (1.1.3 at the point of this writing). You will need to accept the EULA in order to download the CLI ;)
4. Open a new terminal window inside the VM and run the following commands to install the CLI
    ```bash
    # unzip the gz file you downloaded
    gunzip tkg-linux-amd64-v1.1.3_vmware.1.gz

    # Move the CLI to the user local bin directory
    sudo mv tkg-linux-amd64-v1.1.3_vmware.1 /usr/local/bin/tkg

    # Make the tkg binary executable
    sudo chmod +x /usr/local/bin/tkg
    ```
5. Check that the cli is running properly by executing the command `tkg version`

## Preparing to Deploy a management cluster on AWS

The following steps are a short summarization for the detailed documentation at https://docs.vmware.com/en/VMware-Tanzu-Kubernetes-Grid/1.1/vmware-tanzu-kubernetes-grid-11/GUID-install-tkg-aws.html 

>> The following steps need to be performed inside the VM.

1. Setup the required keys for your AWS account. Substitute the values for your aws account and run the following commands inside a terminal in your VM to set the environment variables.
    ```bash
    export AWS_ACCESS_KEY_ID="your aws access key"
    export AWS_SECRET_ACCESS_KEY="your aws access key secret"
    export AWS_REGION=us-west-2  # or substitute with your AWS region of choice
    ```
Note: If you use multi-factor authentication, your AWS session token is also required
    ```bash
    export AWS_SESSION_TOKEN="your aws session token"
    ```
2. Initialize clusterawsadm
    ```bash
        clusterawsadm alpha bootstrap create-stack
    ```

3. Register an SSH public key with your AWS account
    ```bash
        aws ec2 create-key-pair --key-name default --output json | jq .KeyMaterial -r > default.pem
    ```

4. Set Your AWS Credentials as Environment Variables for Use by Cluster API
    ```bash
        export AWS_CREDENTIALS=$(aws iam create-access-key --user-name bootstrapper.cluster-api-provider-aws.sigs.k8s.io --output json)
        export AWS_ACCESS_KEY_ID=$(echo $AWS_CREDENTIALS | jq .AccessKey.AccessKeyId -r)
        export AWS_SECRET_ACCESS_KEY=$(echo $AWS_CREDENTIALS | jq .AccessKey.SecretAccessKey -r)
        export AWS_B64ENCODED_CREDENTIALS=$(clusterawsadm alpha bootstrap encode-aws-credentials)
    ```

The objective of observability is to go beyond simple monitoring by providing correlation beyond metrics captured across technology layers. Ideally though, monitoring should be a value addition instead of being another tool in the box that needs to be managed. Wavefront (now known as Tanzu Observability), is a SaaS tool that gives you this visibility at "real cloud scale". Tanzu Observability is a vendor neutral observability tool.

https://www.openshift.com/blog/wavefront-automates-and-unifies-red-hat-openshift-observability-full-stack
