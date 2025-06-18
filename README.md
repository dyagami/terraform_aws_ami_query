# AWS quick AMI image list query based on keywords and architecture

A terraform configuration to quickly return all available AMI image IDs in your region along with their human-readable names based on keywords and OS architecture provided. Useful for finding all variants of the operating system you're looking for to use for your EC2, comparing available options Amazon provides and having the list saved locally for future use.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) installed
- AWS account with [IAM credentials](https://www.youtube.com/watch?v=OZsmKaIz_M0)

***

## Setup Instructions

1. **Prepare Your Environment**

2. **Clone this repository** ```git clone https://github.com/dyagami/terraform_aws_ami_query.git```
  
3. **Create an IAM user and generate an Access Key with the following permissions:**
    - `ec2:DescribeImages`

4. **Configure Variables**

   - **Preferrable way:**

        Set up the following environment variables prior to launching the code:

        ```
        TF_VAR_aws_access_key = "YOUR_ACCESS_KEY"
        TF_VAR_aws_secret_key = "YOUR_SECRET_KEY"
        TF_VAR_aws_region     = "YOUR_REGION"        
        ```

   - Unsecure way (storing secrets in plaintext - only do it if you know the repercussions)

        Edit `terraform.tfvars` file in your working directory with:

        ```
        aws_access_key = "YOUR_ACCESS_KEY" 
        aws_secret_key = "YOUR_SECRET_KEY"
        aws_region     = "YOUR_REGION"        
        ```

5. **Run Terraform Commands**

    ```
    terraform init
    terraform apply

    # There's no need for "terraform plan" command, as this code
    # does not create any infrastructure
    ```

    You will be asked to provide OS architecture type and keywords to search names for. After that, all official Amazon AMI images will be queried and exported to a map variable containing AMI IDs with their corresponding image names. The result will be outputted to the terminal and saved in Terraform state.

6. **(Optional) Save the image list to a file**

    After performing the apply operation:
    `terraform output > image_list.json`
