# Oracle Cloud Foundation Terraform Solution - Oracle MovieStream for LiveLabs - Use graph analytics to recommend movies

![](https://oracle-livelabs.github.io/adb/movie-stream-story-lite/introduction/images/moviestream.jpeg)

## Table of Contents
1. [Overview](#overview)
1. [Deliverables](#deliverables)
1. [Architecture](#Architecture-Diagram)
1. [Executing Instructions](#instructions)
    1. [Deploy Using Oracle Resource Manager](#Deploy-Using-Oracle-Resource-Manager)
    1. [What to do after the Deployment via Resource Manager](#After-Deployment-via-Resource-Manager)
    1. [Deploy Using the Terraform CLI](#Deploy-Using-the-Terraform-CLI)
    1. [What to do after the Deployment via Terraform CLI](#After-Deployment-via-Terraform-CLI)
1. [Documentation](#documentation)
1. [The Team](#team)
1. [Feedback](#feedback)
1. [Known Issues](#known-issues)
1. [Contribute](#CONTRIBUTING.md)


## <a name="overview"></a>Overview
----------------

Location of the lab:  [Integrate, Analyze and Act on All data using Autonomous Database](https://apexapps.oracle.com/pls/apex/r/dbpm/livelabs/view-workshop?wid=889) - **Lab 7: Use Graph analytics for product recommendations**

In this lab, you will use Oracle Graph analytics to detect and create customer communities based on movie viewing behavior. Once you've created communities - make recommendations based on what your community members have watched.

Watch the video below for a quick walk-through of the lab. [_click here_](https://cdnapisec.kaltura.com/html5/html5lib/v2.98/mwEmbedFrame.php/p/2171811/uiconf_id/35965902/entry_id/1_ret5ywcn?wid=_2171811&iframeembed=true&playerId=kaltura_player&entry_id=1_ret5ywcn&flashvars[streamerType]=auto#).


About graph

When you model your data as a graph, you can run graph algorithms to analyze connections and relationships in your data. You can also use graph queries to find patterns in your data, such as cycles, paths between vertices, anomalous patterns, and others. Graph algorithms are invoked using a Java or Python API, and graph queries are run using PGQL (Property Graph Query Language, see pgql-lang.org).

In this lab you will use a graph created from the tables MOVIE, CUSTOMER_PROMOTIONS, and CUSTSALES_PROMOTIONS. MOVIE and CUSTOMER_PROMOTIONS are vertex tables (every row in these tables becomes a vertex). CUSTSALES_PROMOTIONS connects the two tables, and is the edge table. Every time a customer in CUSTOMER_PROMOTIONS rents a movie in the table MOVIE, that is an edge in the graph. This graph has been created for you for use in this lab.

You have the choice of over 60 pre-built algorithms when analyzing a graph. In this lab you will use the Personalized SALSA algorithm, which is a good choice for product recommendations. Customer vertices map to hubs and movies map to authorities. Higher hub scores indicate a closer relationship between customers. Higher authority scores indicate that the vertex (or movie) is plays a more important role in establishing that closeness.

Objectives

In this lab, you will use the Graph Studio feature of Autonomous Database to:

Use a notebook
Run a few PGQL graph queries
Use python to run Personalized SALSA from the algorithm library
Query and save the recommendations



Oracle Cloud provides an amazing platform to productively deliver secure, insightful, scalable and performant solutions. MovieStream designed their solution leveraging the world class Oracle Autonomous Database and Oracle Cloud Infrastructure (OCI) Data Lake services. Their data architecture is following the Oracle Reference Architecture [_Enterprise Data Warehousing - an Integrated Data Lake_](https://docs.oracle.com/en/solutions/oci-curated-analysis/index.html) - which is used by Oracle customers around the world. It's worthwhile to review the architecture so you can understand the value of integrating the data lake and data warehouse - as it enables you to answer more complex questions using all your data.


## <a name="deliverables"></a>Deliverables
----------------

 This repository encloses one deliverable:

- A reference implementation written in Terraform HCL (Hashicorp Language) that provisions fully functional resources in an OCI tenancy. 

## <a name="architecture"></a>Architecture-Diagram
----------------

In this workshop, we'll start with two key components of MovieStream's architecture. MovieStream is storing their data across Oracle Object Storage and Autonomous Database. Data is captured from various sources into a landing zone in object storage. This data is then processed (cleansed, transformed and optimized) and stored in a gold zone on object storage. Once the data is curated, it is loaded into an Autonomous Database where it is analyzed by many (and varied) members of the user community.


![](https://oracle-livelabs.github.io/adb/movie-stream-story-lite/introduction/images/architecture.png)


## <a name="instructions"></a>Executing Instructions
----------------

## Prerequisites

- Permission to `manage` the following types of resources in your Oracle Cloud Infrastructure tenancy: `autonomous database`
- Quota to create the following resources: 1 ADW database instance inside OCI.
If you don't have the required permissions and quota, contact your tenancy administrator. See [Policy Reference](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Reference/policyreference.htm), [Service Limits](https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/servicelimits.htm), [Compartment Quotas](https://docs.cloud.oracle.com/iaas/Content/General/Concepts/resourcequotas.htm).

# <a name="Deploy-Using-Oracle-Resource-Manager"></a>Deploy Using Oracle Resource Manager

1. Click [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/oracle-devrel/terraform-oci-oracle-cloud-foundation/releases/download/v1.0.0/MovieStream_live_lab-RM.zip)


    If you aren't already signed in, when prompted, enter the tenancy and user credentials.

2. Review and accept the terms and conditions.
3. Select the region where you want to deploy the stack.
4. Follow the on-screen prompts and instructions to create the stack.
5. After creating the stack, click **Terraform Actions**, and select **Plan**.
6. Wait for the job to be completed, and review the plan.
    To make any changes, return to the Stack Details page, click **Edit Stack**, and make the required changes. Then, run the **Plan** action again.
7. If no further changes are necessary, return to the Stack Details page, click **Terraform Actions**, and select **Apply**. 

## <a name="After-Deployment-via-Resource-Manager"></a>What to do after the Deployment via Resource Manager
----------------

- After the solution was deployed successfully from Terraform CLI you will have some outputs on the screen. 

Example of output:

```
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

ADW_Database_db_connection = tolist([
  {
    "all_connection_strings" = tomap({
      "HIGH" = "adb.eu-amsterdam-1.oraclecloud.com:1522/sz5km3vsrs3lie5_moviestreamlabseven_high.adb.oraclecloud.com"
      "LOW" = "adb.eu-amsterdam-1.oraclecloud.com:1522/sz5km3vsrs3lie5_moviestreamlabseven_low.adb.oraclecloud.com"
      "MEDIUM" = "adb.eu-amsterdam-1.oraclecloud.com:1522/sz5km3vsrs3lie5_moviestreamlabseven_medium.adb.oraclecloud.com"
    })
    "dedicated" = ""
    "high" = "adb.eu-amsterdam-1.oraclecloud.com:1522/sz5km3vsrs3lie5_moviestreamlabseven_high.adb.oraclecloud.com"
    "low" = "adb.eu-amsterdam-1.oraclecloud.com:1522/sz5km3vsrs3lie5_moviestreamlabseven_low.adb.oraclecloud.com"
    "medium" = "adb.eu-amsterdam-1.oraclecloud.com:1522/sz5km3vsrs3lie5_moviestreamlabseven_medium.adb.oraclecloud.com"
    "profiles" = tolist([
      {
        "consumer_group" = "HIGH"
        "display_name" = "moviestreamlabseven_high"
        "host_format" = "FQDN"
        "protocol" = "TCPS"
        "session_mode" = "DIRECT"
        "syntax_format" = "LONG"
        "tls_authentication" = "MUTUAL"
        "value" = "(description= (retry_count=20)(retry_delay=3)(address=(protocol=tcps)(port=1522)(host=adb.eu-amsterdam-1.oraclecloud.com))(connect_data=(service_name=sz5km3vsrs3lie5_moviestreamlabseven_high.adb.oraclecloud.com))(security=(ssl_server_dn_match=yes)))"
      },
      {
        "consumer_group" = "LOW"
        "display_name" = "moviestreamlabseven_low"
        "host_format" = "FQDN"
        "protocol" = "TCPS"
        "session_mode" = "DIRECT"
        "syntax_format" = "LONG"
        "tls_authentication" = "MUTUAL"
        "value" = "(description= (retry_count=20)(retry_delay=3)(address=(protocol=tcps)(port=1522)(host=adb.eu-amsterdam-1.oraclecloud.com))(connect_data=(service_name=sz5km3vsrs3lie5_moviestreamlabseven_low.adb.oraclecloud.com))(security=(ssl_server_dn_match=yes)))"
      },
      {
        "consumer_group" = "MEDIUM"
        "display_name" = "moviestreamlabseven_medium"
        "host_format" = "FQDN"
        "protocol" = "TCPS"
        "session_mode" = "DIRECT"
        "syntax_format" = "LONG"
        "tls_authentication" = "MUTUAL"
        "value" = "(description= (retry_count=20)(retry_delay=3)(address=(protocol=tcps)(port=1522)(host=adb.eu-amsterdam-1.oraclecloud.com))(connect_data=(service_name=sz5km3vsrs3lie5_moviestreamlabseven_medium.adb.oraclecloud.com))(security=(ssl_server_dn_match=yes)))"
      },
    ])
  },
])
Database_Actions = [
  "https://SZ5KM3VSRS3LIE5-MOVIESTREAMLABSEVEN.adb.eu-amsterdam-1.oraclecloudapps.com/ords/sql-developer",
]
adb_admin_password = "WlsAtpDb1234#"
database_fully_qualified_name = "sz5km3vsrs3lie5-moviestreamlabseven.adb.eu-amsterdam-1.oraclecloudapps.com"
graph_password = "watchS0meMovies#"
graph_studio_url = [
  "https://SZ5KM3VSRS3LIE5-MOVIESTREAMLABSEVEN.adb.eu-amsterdam-1.oraclecloudapps.com/graphstudio/",
]
graph_username = "MOVIESTREAM"
machine_learning_user_management_url = [
  "https://SZ5KM3VSRS3LIE5-MOVIESTREAMLABSEVEN.adb.eu-amsterdam-1.oraclecloudapps.com/omlusers/",
]

```

## Oracle MovieStream demonstration deployment

This stack installs everything required to run the Oracle MovieStream Live Lab. Now you can follow the steps for the MovieStream Live lab 7 from https://apexapps.oracle.com/pls/apex/r/dbpm/livelabs/run-workshop?p210_wid=889&p210_wec=&session=112456050571777 

You can find details for connecting to these services in the Stack's Job Details Output. 

## Connect to Autonomous Database
Go to Autonomous Database in the OCI console. The default name given to the database instance is: **OracleMovieStream**. You specified the ADMIN password when deploying the Oracle MovieStream stack. 

A database user was created during the deployment. You can connect as that user to look at the database schema, use analytic features, etc. 

* User: `MOVIESTREAM`, Password: `watchS0meMovies#`
* User: `ADMIN`, Password: `WlsAtpDb1234#`

Please change these passwords after deployment.

## Using database tools and applications

All of the Autonomous Database tools are available to you, including SQL worksheet, Data Studio, Machine Learning and Graph notebooks, etc. Go to Database Actions to access these tools. 

* **Database Actions:** Load, explore, transform, model, and catalog your data. Use an SQL worksheet, build REST interfaces and low-code apps, manage users and connections, build and apply machine learning models. 

Access Link is the graph_studio_url URL from the output. Example:
https://RDDAINSUH6U1OKC-ORACLEMOVIESTREAM.adb.us-ashburn-1.oraclecloudapps.com/ords/sql-developer


* **Graph Studio:** Oracle Graph Studio lets you create scalable property graph databases. Graph Studio automates the creation of graph models and in-memory graphs from database tables. It includes notebooks and developer APIs that allow you to execute graph queries using PGQL (an SQL-like graph query language) and over 50 built-in graph algorithms. Graph Studio also offers dozens of visualization, including native graph visualization. 

Access Link is the graph_studio_url URL from the output. Example:
https://RDDAINSUH6U1OKC-ORACLEMOVIESTREAM.adb.us-ashburn-1.oraclecloudapps.com/graphstudio/


* **Application Express:** Oracle Application Express (APEX) is a low-code development platform that enables you to build scalable, secure enterprise apps that can be deployed anywhere. 

Access Link is the graph_studio_url URL from the output. Example:
https://RDDAINSUH6U1OKC-ORACLEMOVIESTREAM.adb.us-ashburn-1.oraclecloudapps.com/ords/sql-developer


* **Oracle Machine Learning User Notebooks:** Oracle Machine Learning notebooks provide easy access to Oracle's parallelized, scalable in-database implementations of a library of Oracle Advanced Analytics' machine learning algorithms (classification, regression, anomaly detection, clustering, associations, attribute importance, feature extraction, times series, etc.), SQL, PL/SQL and Oracle's statistical and analytical SQL functions. 

The stack's job output also includes URLs that take you directly to the tools.

Access Link is the machine_learning_user_management_url URL from the output. Example:
https://RDDAINSUH6U1OKC-ORACLEMOVIESTREAM.adb.us-ashburn-1.oraclecloudapps.com/omlusers/



# <a name="Deploy-Using-the-Terraform-CLI"></a>Deploy Using the Terraform CLI


## Clone the Module
Now, you'll want a local copy of this repo. You can make that with the commands:

    git clone https://github.com/oracle-devrel/terraform-oci-oracle-cloud-foundation.git
    cd terraform-oci-oracle-cloud-foundation/cloud-foundation/solutions/MovieStream_live_lab
    ls

## Deployment

- Follow the instructions from Prerequisites links in order to install terraform.
- Download the terraform version suitable for your operating system.
- Unzip the archive.
- Add the executable to the PATH.
- You will have to generate an API signing key (public/private keys) and the public key should be uploaded in the OCI console, for the iam user that will be used to create the resources. Also, you should make sure that this user has enough permissions to create resources in OCI. In order to generate the API Signing key, follow the steps from: https://docs.us-phoenix-1.oraclecloud.com/Content/API/Concepts/apisigningkey.htm#How
  The API signing key will generate a fingerprint in the OCI console, and that fingerprint will be used in a terraform file described below.
- You will also need to generate an OpenSSH public key pair. Please store those keys in a place accessible like your user home .ssh directory.

## Prerequisites

- Install Terraform v0.13 or greater: https://www.terraform.io/downloads.html
- Install Python 3.6: https://www.digitalocean.com/community/tutorials/how-to-install-python-3-and-set-up-a-local-programming-environment-on-centos-7
- Generate an OCI API Key
- Create your config under \$home*directory/.oci/config (run \_oci setup config* and follow the steps)
- Gather Tenancy related variables (tenancy_id, user_id, local path to the oci_api_key private key, fingerprint of the oci_api_key_public key, and region)

### Installing Terraform

Go to [terraform.io](https://www.terraform.io/downloads.html) and download the proper package for your operating system and architecture. Terraform is distributed as a single binary.
Install Terraform by unzipping it and moving it to a directory included in your system's PATH. You will need the latest version available.

### Prepare Terraform Provider Values

**variables.tf** is located in the root directory. This file is used in order to be able to make API calls in OCI, hence it will be needed by all terraform automations.

In order to populate the **variables.tf** file, you will need the following:

- Tenancy OCID
- User OCID
- Local Path to your private oci api key
- Fingerprint of your public oci api key
- Region


#### **Getting the Tenancy and User OCIDs**

You will have to login to the [console](https://console.us-ashburn-1.oraclecloud.com) using your credentials (tenancy name, user name and password). If you do not know those, you will have to contact a tenancy administrator.

In order to obtain the tenancy ocid, after logging in, from the menu, select Administration -> Tenancy Details. The tenancy OCID, will be found under Tenancy information and it will be similar to **ocid1.tenancy.oc1..aaa…**

In order to get the user ocid, after logging in, from the menu, select Identity -> Users. Find your user and click on it (you will need to have this page open for uploading the oci_api_public_key). From this page, you can get the user OCID which will be similar to **ocid1.user.oc1..aaaa…**

#### **Creating the OCI API Key Pair and Upload it to your user page**

Create an oci_api_key pair in order to authenticate to oci as specified in the [documentation](https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#How):

Create the .oci directory in the home of the current user

`$ mkdir ~/.oci`

Generate the oci api private key

`$ openssl genrsa -out ~/.oci/oci_api_key.pem 2048`

Make sure only the current user can access this key

`$ chmod go-rwx ~/.oci/oci_api_key.pem`

Generate the oci api public key from the private key

`$ openssl rsa -pubout -in ~/.oci/oci_api_key.pem -out ~/.oci/oci_api_key_public.pem`

You will have to upload the public key to the oci console for your user (go to your user page -> API Keys -> Add Public Key and paste the contents in there) in order to be able to do make API calls.

After uploading the public key, you can see its fingerprint into the console. You will need that fingerprint for your variables.tf file.
You can also get the fingerprint from running the following command on your local workstation by using your newly generated oci api private key.

`$ openssl rsa -pubout -outform DER -in ~/.oci/oci_api_key.pem | openssl md5 -c`

#### **Generating an SSH Key Pair on UNIX or UNIX-Like Systems Using ssh-keygen**

- Run the ssh-keygen command.

`ssh-keygen -b 2048 -t rsa`

- The command prompts you to enter the path to the file in which you want to save the key. A default path and file name are suggested in parentheses. For example: /home/user_name/.ssh/id_rsa. To accept the default path and file name, press Enter. Otherwise, enter the required path and file name, and then press Enter.
- The command prompts you for a passphrase. Enter a passphrase, or press ENTER if you don't want to havea passphrase.
  Note that the passphrase isn't displayed when you type it in. Remember the passphrase. If you forget the passphrase, you can't recover it. When prompted, enter the passphrase again to confirm it.
- The command generates an SSH key pair consisting of a public key and a private key, and saves them in the specified path. The file name of the public key is created automatically by appending .pub to the name of the private key file. For example, if the file name of the SSH private key is id_rsa, then the file name of the public key would be id_rsa.pub.
  Make a note of the path where you've saved the SSH key pair.
  When you create instances, you must provide the SSH public key. When you log in to an instance, you must specify the corresponding SSH private key and enter the passphrase when prompted.

#### **Getting the Region**

Even though, you may know your region name, you will needs its identifier for the variables.tf file (for example, US East Ashburn has us-ashburn-1 as its identifier).
In order to obtain your region identifier, you will need to Navigate in the OCI Console to Administration -> Region Management
Select the region you are interested in, and save the region identifier.


#### **Prepare the variables.tf file**

You will have to modify the **variables.tf** file to reflect the values that you’ve captured.

```
variable "tenancy_ocid" {
  type = string
  default = "" (tenancy ocid, obtained from OCI console - Profile -> Tenancy)
}

variable "region" {
    type = string
    default = "" (the region used for deploying the infrastructure - ex: eu-frankfurt-1)
}

variable "compartment_id" {
  type = string
  default = "" (the compartment used for deploying the solution - ex: compartment1)
}

variable "user_ocid" {
    type = string
    default = "" (user ocid, obtained from OCI console - Profile -> User Settings)
}

variable "fingerprint" {
    type = string
    default = "" (fingerprint obtained after setting up the API public key in OCI console - Profile -> User Settings -> API Keys -> Add Public Key)
}

variable "private_key_path" {
    type = string
    default = ""  (the path of your local oci api key - ex: /root/.ssh/oci_api_key.pem)
}

```

## Repository files


* **modules(folder)** - ( this folder will be pressent only for the Resource Manager zipped files) Contains folders with subsystems and modules for each section of the project: networking, autonomous database, analytics cloud, object storage, data catalog etc.
Also in the modules folder there is a folder called provisioner - that will provision your full infrastructure with the data model.
* **CONTRIBUTING.md** - Contributing guidelines, also called Contribution guidelines, the CONTRIBUTING.md file, or software contribution guidelines, is a text file which project managers include in free and open-source software packages or other open media packages for the purpose of describing how others may contribute user-generated content to the project.The file explains how anyone can engage in activities such as formatting code for submission or submitting patches
* **LICENSE** - The Universal Permissive License (UPL), Version 1.0 
* **local.tf** - Local values can be helpful to avoid repeating the same values or expressions multiple times in a configuration, but if overused they can also make a configuration hard to read by future maintainers by hiding the actual values used.Here is the place where all the resources are defined.
* **main.tf** - Main Terraform script used for instantiating the Oracle Cloud Infrastructure provider and all subsystems modules
* **outputs.tf** - Defines project's outputs that you will see after the code runs successfuly
* **provider.tf** - The terraform provider that will be used (OCI)
* **README.md** - This file
* **schema.yaml** - Schema documents are recommended for Terraform configurations when using Resource Manager. Including a schema document allows you to extend pages in the Oracle Cloud Infrastructure Console. Facilitate variable entry in the Create Stack page by surfacing SSH key controls and by naming, grouping, dynamically prepopulating values, and more. Define text in the Application Information tab of the stack detail page displayed for a created stack.
* **variables.tf** - Project's global variables

Secondly, populate the `terraform.tf` file with the disared configuration following the information:


# Autonomous Data Warehouse

The ADW subsystem / module is able to create ADW/ATP databases.

* Parameters:
    * __db_name__ - The database name. The name must begin with an alphabetic character and can contain a maximum of 14 alphanumeric characters. Special characters are not permitted. The database name must be unique in the tenancy.
    * __db_password__ - The password must be between 12 and 30 characters long, and must contain at least 1 uppercase, 1 lowercase, and 1 numeric character. It cannot contain the double quote symbol (") or the username "admin", regardless of casing. The password is mandatory if source value is "BACKUP_FROM_ID", "BACKUP_FROM_TIMESTAMP", "DATABASE" or "NONE".
    * __db_cpu_core_count__ - The number of OCPU cores to be made available to the database. For Autonomous Databases on dedicated Exadata infrastructure, the maximum number of cores is determined by the infrastructure shape. See Characteristics of Infrastructure Shapes for shape details.
    * __db_size_in_tbs__ - The size, in gigabytes, of the data volume that will be created and attached to the database. This storage can later be scaled up if needed. The maximum storage value is determined by the infrastructure shape. See Characteristics of Infrastructure Shapes for shape details.
    * __db_workload__ - The Autonomous Database workload type. The following values are valid:
        - OLTP - indicates an Autonomous Transaction Processing database
        - DW - indicates an Autonomous Data Warehouse database
        - AJD - indicates an Autonomous JSON Database
        - APEX - indicates an Autonomous Database with the Oracle APEX Application Development workload type. *Note: db_workload can only be updated from AJD to OLTP or from a free OLTP to AJD.
    * __db_version__ - A valid Oracle Database version for Autonomous Database.db_workload AJD and APEX are only supported for db_version 19c and above.
    * __db_enable_auto_scaling__ - Indicates if auto scaling is enabled for the Autonomous Database OCPU core count. The default value is FALSE.
    * __db_is_free_tier__ - Indicates if this is an Always Free resource. The default value is false. Note that Always Free Autonomous Databases have 1 CPU and 20GB of memory. For Always Free databases, memory and CPU cannot be scaled. When db_workload is AJD or APEX it cannot be true.
    * __db_license_model__ - The Oracle license model that applies to the Oracle Autonomous Database. Bring your own license (BYOL) allows you to apply your current on-premises Oracle software licenses to equivalent, highly automated Oracle PaaS and IaaS services in the cloud. License Included allows you to subscribe to new Oracle Database software licenses and the Database service. Note that when provisioning an Autonomous Database on dedicated Exadata infrastructure, this attribute must be null because the attribute is already set at the Autonomous Exadata Infrastructure level. When using shared Exadata infrastructure, if a value is not specified, the system will supply the value of BRING_YOUR_OWN_LICENSE. It is a required field when db_workload is AJD and needs to be set to LICENSE_INCLUDED as AJD does not support default license_model value BRING_YOUR_OWN_LICENSE.
    * __tag__ - Pick the datasets to load. movieapp for the full movieapp appliction or graph-get-started for the graph lab. The default is graph-get-started to start the graph lab.
    * __run_post_load_procedures__ - Run procedures after loading data


Below is an example:

```
variable "db_name" {
  type    = string
  default = "MovieStreamlabseven"
}

variable "db_password" {
  type = string
  default = "<enter-password-here>"
}

variable "db_cpu_core_count" {
  type = number
  default = 1
}

variable "db_size_in_tbs" {
  type = number
  default = 1
}

variable "db_workload" {
  type = string
  default = "DW"
}

variable "db_version" {
  type = string
  default = "19c"
}

variable "db_enable_auto_scaling" {
  type = bool
  default = true
}

variable "db_is_free_tier" {
  type = bool
  default = false
}

variable "db_license_model" {
  type = string
  default = "LICENSE_INCLUDED"
}

variable "tag" {
  type    = string
  default = "graph-get-started"
  # default = "movieapp"
}

variable "run_post_load_procedures" {
  type    = bool
  default = false
  # default = true
}

```

## Running the code

```
# Run init to get terraform modules
$ terraform init

# Create the infrastructure
$ terraform apply --auto-approve

# If you are done with this infrastructure, take it down
$ terraform destroy --auto-approve
```

## <a name="After-Deployment-via-Terraform-CLI"></a>What to do after the Deployment via Terraform CLI
----------------

- After the solution was deployed successfully from Terraform CLI you will have some outputs on the screen. 

Example of output:

```
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

ADW_Database_db_connection = tolist([
  {
    "all_connection_strings" = tomap({
      "HIGH" = "adb.eu-amsterdam-1.oraclecloud.com:1522/sz5km3vsrs3lie5_moviestreamlabseven_high.adb.oraclecloud.com"
      "LOW" = "adb.eu-amsterdam-1.oraclecloud.com:1522/sz5km3vsrs3lie5_moviestreamlabseven_low.adb.oraclecloud.com"
      "MEDIUM" = "adb.eu-amsterdam-1.oraclecloud.com:1522/sz5km3vsrs3lie5_moviestreamlabseven_medium.adb.oraclecloud.com"
    })
    "dedicated" = ""
    "high" = "adb.eu-amsterdam-1.oraclecloud.com:1522/sz5km3vsrs3lie5_moviestreamlabseven_high.adb.oraclecloud.com"
    "low" = "adb.eu-amsterdam-1.oraclecloud.com:1522/sz5km3vsrs3lie5_moviestreamlabseven_low.adb.oraclecloud.com"
    "medium" = "adb.eu-amsterdam-1.oraclecloud.com:1522/sz5km3vsrs3lie5_moviestreamlabseven_medium.adb.oraclecloud.com"
    "profiles" = tolist([
      {
        "consumer_group" = "HIGH"
        "display_name" = "moviestreamlabseven_high"
        "host_format" = "FQDN"
        "protocol" = "TCPS"
        "session_mode" = "DIRECT"
        "syntax_format" = "LONG"
        "tls_authentication" = "MUTUAL"
        "value" = "(description= (retry_count=20)(retry_delay=3)(address=(protocol=tcps)(port=1522)(host=adb.eu-amsterdam-1.oraclecloud.com))(connect_data=(service_name=sz5km3vsrs3lie5_moviestreamlabseven_high.adb.oraclecloud.com))(security=(ssl_server_dn_match=yes)))"
      },
      {
        "consumer_group" = "LOW"
        "display_name" = "moviestreamlabseven_low"
        "host_format" = "FQDN"
        "protocol" = "TCPS"
        "session_mode" = "DIRECT"
        "syntax_format" = "LONG"
        "tls_authentication" = "MUTUAL"
        "value" = "(description= (retry_count=20)(retry_delay=3)(address=(protocol=tcps)(port=1522)(host=adb.eu-amsterdam-1.oraclecloud.com))(connect_data=(service_name=sz5km3vsrs3lie5_moviestreamlabseven_low.adb.oraclecloud.com))(security=(ssl_server_dn_match=yes)))"
      },
      {
        "consumer_group" = "MEDIUM"
        "display_name" = "moviestreamlabseven_medium"
        "host_format" = "FQDN"
        "protocol" = "TCPS"
        "session_mode" = "DIRECT"
        "syntax_format" = "LONG"
        "tls_authentication" = "MUTUAL"
        "value" = "(description= (retry_count=20)(retry_delay=3)(address=(protocol=tcps)(port=1522)(host=adb.eu-amsterdam-1.oraclecloud.com))(connect_data=(service_name=sz5km3vsrs3lie5_moviestreamlabseven_medium.adb.oraclecloud.com))(security=(ssl_server_dn_match=yes)))"
      },
    ])
  },
])
Database_Actions = [
  "https://SZ5KM3VSRS3LIE5-MOVIESTREAMLABSEVEN.adb.eu-amsterdam-1.oraclecloudapps.com/ords/sql-developer",
]
adb_admin_password = "WlsAtpDb1234#"
database_fully_qualified_name = "sz5km3vsrs3lie5-moviestreamlabseven.adb.eu-amsterdam-1.oraclecloudapps.com"
graph_password = "watchS0meMovies#"
graph_studio_url = [
  "https://SZ5KM3VSRS3LIE5-MOVIESTREAMLABSEVEN.adb.eu-amsterdam-1.oraclecloudapps.com/graphstudio/",
]
graph_username = "MOVIESTREAM"
machine_learning_user_management_url = [
  "https://SZ5KM3VSRS3LIE5-MOVIESTREAMLABSEVEN.adb.eu-amsterdam-1.oraclecloudapps.com/omlusers/",
]

```

## Oracle MovieStream demonstration deployment

This stack installs everything required to run the Oracle MovieStream Live Lab. Now you can follow the steps for the MovieStream Live lab 7 from https://apexapps.oracle.com/pls/apex/r/dbpm/livelabs/run-workshop?p210_wid=889&p210_wec=&session=112456050571777 

You can find details for connecting to these services in the Stack's Job Details Output. 

## Connect to Autonomous Database
Go to Autonomous Database in the OCI console. The default name given to the database instance is: **OracleMovieStream**. You specified the ADMIN password when deploying the Oracle MovieStream stack. 

A database user was created during the deployment. You can connect as that user to look at the database schema, use analytic features, etc. 

* User: `MOVIESTREAM`, Password: `watchS0meMovies#`
* User: `ADMIN`, Password: `WlsAtpDb1234#`

Please change these passwords after deployment.

## Using database tools and applications

All of the Autonomous Database tools are available to you, including SQL worksheet, Data Studio, Machine Learning and Graph notebooks, etc. Go to Database Actions to access these tools. 

* **Database Actions:** Load, explore, transform, model, and catalog your data. Use an SQL worksheet, build REST interfaces and low-code apps, manage users and connections, build and apply machine learning models. 

Access Link is the graph_studio_url URL from the output. Example:
https://RDDAINSUH6U1OKC-ORACLEMOVIESTREAM.adb.us-ashburn-1.oraclecloudapps.com/ords/sql-developer


* **Graph Studio:** Oracle Graph Studio lets you create scalable property graph databases. Graph Studio automates the creation of graph models and in-memory graphs from database tables. It includes notebooks and developer APIs that allow you to execute graph queries using PGQL (an SQL-like graph query language) and over 50 built-in graph algorithms. Graph Studio also offers dozens of visualization, including native graph visualization. 

Access Link is the graph_studio_url URL from the output. Example:
https://RDDAINSUH6U1OKC-ORACLEMOVIESTREAM.adb.us-ashburn-1.oraclecloudapps.com/graphstudio/


* **Application Express:** Oracle Application Express (APEX) is a low-code development platform that enables you to build scalable, secure enterprise apps that can be deployed anywhere. 

Access Link is the graph_studio_url URL from the output. Example:
https://RDDAINSUH6U1OKC-ORACLEMOVIESTREAM.adb.us-ashburn-1.oraclecloudapps.com/ords/sql-developer


* **Oracle Machine Learning User Notebooks:** Oracle Machine Learning notebooks provide easy access to Oracle's parallelized, scalable in-database implementations of a library of Oracle Advanced Analytics' machine learning algorithms (classification, regression, anomaly detection, clustering, associations, attribute importance, feature extraction, times series, etc.), SQL, PL/SQL and Oracle's statistical and analytical SQL functions. 

The stack's job output also includes URLs that take you directly to the tools.

Access Link is the machine_learning_user_management_url URL from the output. Example:
https://RDDAINSUH6U1OKC-ORACLEMOVIESTREAM.adb.us-ashburn-1.oraclecloudapps.com/omlusers/


## <a name="documentation"></a>Documentation

[Autonomous Databases Overview](https://docs.oracle.com/en-us/iaas/Content/Database/Concepts/adboverview.htm)

[Terraform Autonomous Databases Resource](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/database_autonomous_database)


## <a name="team"></a>The Team
- **Owners**: [Panaitescu Ionel](https://github.com/ionelpanaitescu) , [Marty Gubar](https://github.com/martygubar)

## <a name="feedback"></a>Feedback
We welcome your feedback. To post feedback, submit feature ideas or report bugs, please use the Issues section on this repository.	

## <a name="known-issues"></a>Known Issues
**At the moment, there are no known issues for this solution**


