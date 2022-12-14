#!/bin/bash

terraform -chdir=$1 init
terraform -chdir=$1 apply --auto-approve
