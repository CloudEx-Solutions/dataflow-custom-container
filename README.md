# Dataflow Pipeline Project

This repository contains a Python-based Apache Beam pipeline designed to be deployed on Google Cloud Dataflow. The project is configured to use a development container for a consistent and reproducible development environment. Infrastructure is managed using Terraform.
This repository only contains the setup, write your own tranformations as needed!
---

## Getting Started

Follow these steps to set up your development environment and deploy the necessary cloud infrastructure.

### Prerequisites

* **Docker Desktop**: Ensure Docker is installed and running on your local machine.
* **Visual Studio Code**: The project is best experienced using VS Code.
* **VS Code Remote - Containers extension**: This extension is required to open and work within the devcontainer.

### 1. Configure and Deploy Infrastructure

The necessary Google Cloud Platform (GCP) infrastructure is defined in the `/terraform` directory.

1.  **Create a Terraform Variables File**: Inside the `terraform/` directory, use the new file named `locals.tf`.
2.  **Add GCP Configuration**: Add your specific GCP project ID and desired region to this file.

    ```hcl
    # terraform/locals.tf

    gcp_project_id = "your-gcp-project-id"
    gcp_region     = "your-gcp-region" # e.g., "us-central1"
    ```

3.  **Deploy the Infrastructure**: Navigate to the `terraform/` directory in your terminal and run the following commands to initialize Terraform and apply the configuration.

    ```bash
    gcloud auth login --update-adc
    cd terraform
    terraform init
    terraform apply
    ```

    You will be promted to login to your GCP account. After finishing the login, you will be prompted to review and confirm the resources that will be created. Type `yes` to proceed. This will build all the required GCP resources, such as GCS bucket and artifact registry Docker hub. The GCS bucket name will be by default `your-dataflow-bucket-[4 randomly generated numbers]`.
You will get two outputs:

* repository_url - The artifact registry repo
* dataflow_bucket_name - The created bucket name.

Note these values

### 2. Launch the Development Environment

After setting up the infrastructure, open the project in Visual Studio Code. You will be prompted to "Reopen in Container". Click this button to build and launch the devcontainer. This process will install all the dependencies specified in `requirements.txt` inside the container, pre-commits and ensuring your environment is ready for development and deployment.


---

## Running the Pipeline

All commands should be executed from the terminal within the running devcontainer. The main entry point for the pipeline is `main.py`.

### Local Execution (DirectRunner)

For development and debugging, you can run the pipeline on your local machine using the **DirectRunner**. This runs the pipeline sequentially in a single process and is ideal for quick tests with small amounts of data.

```bash
python main.py \
    --runner DirectRunner \
```

* `--runner DirectRunner`: Specifies that the pipeline should run locally.
* To run the ffmpeg example, ensure a local file called `sample.mp4` is in the same location as main.py. Alternatively, use the provided `download.sh`:
```bash
chmod +x download.sh
./download.sh
```
* Add parameters as needed.

### Cloud Execution (DataflowRunner)

To run the pipeline at scale on GCP, you will build and run a **Dataflow Flex Template**. This process involves building a Docker image with your pipeline code, creating a template specification file, and then launching jobs from that template.

#### Step 1: Build and Push the Docker Image

First, build the Docker image defined in the `Dockerfile` and push it to your project's Artifact Registry.

```bash
# Set your environment variables
export PROJECT_ID="your-gcp-project-id"
export REGION="your-gcp-region" 
export AR_REPO="docker-registry" 
export IMAGE_NAME="your-image-name" 
export IMAGE_TAG="latest"
export IMAGE_URI="${REGION}-docker.pkg.dev/${PROJECT_ID}/${AR_REPO}/${IMAGE_NAME}:${IMAGE_TAG}"
export DATAFLOW_BUCKET="your-dataflow-bucket-[generated 4 numbers]"
# Build and push the image
docker build . -t $IMAGE_URI
docker push $IMAGE_URI
```

#### Step 2: Build the Flex Template

Next, create the Flex Template specification file. This command points to the Docker image you just pushed and creates a JSON template file in a GCS bucket. You will also need a `metadata.json` file to define the template's parameters.

**Example `metadata.json`:**
```json
{
    "name": "My Pipeline Template",
    "description": "A Dataflow Flex Template for my pipeline.",
    "parameters": [
    ]
}
```

**Build Command:**
```bash
# Set your template location variable
export TEMPLATE_GCS_LOCATION="gs://${DATAFLOW_BUCKET}/templates/template-name.json"

gcloud dataflow flex-template build $TEMPLATE_GCS_LOCATION \
    --image $IMAGE_URI \
    --sdk-language PYTHON \
    --metadata-file metadata.json
```

#### Step 3: Run the Flex Template Job

Finally, launch a Dataflow job using the template file you created in the previous step.

```bash

gcloud dataflow flex-template run "my-pipeline-job-$(date +%Y%m%d-%H%M)" \
    --project=$PROJECT_ID \
    --region=$REGION \
    --template-file-gcs-location=$TEMPLATE_GCS_LOCATION \
    --temp-location=$DATAFLOW_BUCKET/temp/ \
    --staging-location=$DATAFLOW_BUCKET/staging/ \
    --parameters "sdk_container_image=$IMAGE_URI"
```

* **`--parameters`**: You must provide the parameters defined in your `metadata.json` file here. The values should match the requirements of your pipeline.


## Project Structure

```
├── Dockerfile              # Defines the base Docker image for the devcontainer.
├── main.py                 # The main entry point to run the Beam pipeline.
├── requirements.txt        # Python package dependencies for the pipeline.
├── pyproject.toml          # Project metadata, used by modern Python tooling.
├── setup.py                # Makes the src/ code installable as a package for Dataflow.
├── src/
│   └── pipeline_package/   # Source code for the pipeline, structured as a package.
│       ├── transforms/     # Custom ParDo transforms.
│       └── utils/          # Helper functions and utility code.
├── terraform/              # Infrastructure as Code (IaC) for GCP resources.
│   ├── main.tf             # Main Terraform configuration file.
│   └── modules/            # Reusable Terraform modules.
└── .devcontainer/          # Configuration for the VS Code development container.
```
