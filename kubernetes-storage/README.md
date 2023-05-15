## What is the main difference between EBS and EFS in kubernetes?
**EFS**
- We install EFS CSI driver first 
- EFS file system need to be create first manually, then it can be mounted in the container as a PV using `EFS CSI driver`
- EFS CSI driver cannot create EFS file system resources in AWS.
- EFS CSI driver can only manage pre-created file system

**EBS**
- We install EBS CSI driver first 
- EBS CSI driver can create EBS volume resources in AWS and use the EBS CSI driver to mount the PV in the container