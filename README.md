# terraform-random-monorepo

A terraform module to generate... random terraform modules. Each module contains a minimal configuration,
but vary in their terraform configuration. This is an early proof-of-concept. Here are the supported variations:

- [ ] Backends
  - [x] local
  - [x] s3
  - [x] gcs
  - [ ] azurerm
- [ ] Workspaces
- [ ] Submodules
- [ ] Outputs

---

## Quickstart

Use the `size` variable to vary the number of terraform root modules that are created. Each is initialized and applied with the system version of terraform.

`terraform apply -var size=4`

The following directory layout is generated:

```
  _generated/
  └── components
      ├── curious-wombat
      │   ├── main.tf
      │   └── terraform.tfstate
      ├── resolved-pangolin
      │   ├── main.tf
      │   └── terraform.tfstate
      ├── sure-basilisk
      │   ├── main.tf
      │   └── terraform.tfstate
      └── tidy-cat
          ├── main.tf
          └── terraform.tfstate
```

## Usage

Import this module with relevant provider configuration.

```hcl
provider "aws" {
  region = "us-west-2"
}

provider "google" {
  project = "terraform-random-monorepo"
  region  = "us-west1"
}

module "random-monorepo" {
  source       = "github.com/brandonc/terraform-random-monorepo"

  s3_enabled     = true
  gcs_enabled    = true
  size           = 4
  backend_config = {
    bucket     = "my-bucket"
    key_prefix = "state"
    s3         = {
      provider_region = "us-west-2" # Must match your provider config region!
    }
    gcs        = {
      provider-region = "us-west1" # Must match your provider config region!
    }
  }
}
```

### Backend Variations

For each enabled backend, working credentials should be configured in your environment (AWS_PROFILE, GOOGLE_CREDENTIALS, etc). The necessary backing storage will be created and managed by terraform before the initial state files are saved.

Backend configurations presets can be applied using the tfvars files in the config directory (See usage below)

#### Local

By default, only the local backend variation is enabled because it is the only one that does not require configuration.

#### S3

Configure your CLI environment with the AWS credentials to use (ex: AWS_PROFILE)

#### GCS

Configure your CLI environment with the Google credentials to use (ex: GOOGLE_CREDENTIALS)
