#####################################################################################
# "encrypted" example — requires only `project_id`.
#
# Creates the full KMS encryption chain for a PostgreSQL Flex instance, using the
# published `terraform-stackit-kms` and `terraform-stackit-service-account`
# modules end-to-end:
#   1. a keyring and a symmetric key-encryption-key (KEK) via the kms module,
#   2. a service account that the database service uses to access the key,
#   3. a PostgreSQL Flex instance whose storage is encrypted against that KEK.
#####################################################################################

# Keyring + key-encryption-key via the published kms module.
# A freshly created key is at version 1.
module "kms" {
  source  = "terraform-stackit-modules/kms/stackit"
  version = ">= 1.0.0"

  project_id          = var.project_id
  keyring_name        = "example-encrypted-postgres"
  keyring_description = "Keyring for the encrypted PostgreSQL Flex example"

  keys = {
    postgres_kek = {
      display_name = "example-postgres-kek"
      algorithm    = "aes_256_gcm"
      purpose      = "symmetric_encrypt_decrypt"
      protection   = "software"
    }
  }
}

# The service account linked to the key, via the published service-account
# module. The PostgreSQL service uses it to access the key-encryption-key
# inside STACKIT-KMS.
module "service_account" {
  source  = "terraform-stackit-modules/service-account/stackit"
  version = ">= 1.0.0"

  project_id = var.project_id
  name       = "encrypted-pg-sa" # max 20 characters
}

# The linked service account MUST hold the kms.admin role on the project:
# the PostgreSQL service impersonates it to unwrap the data key
# (permission kms.key.version.decrypt, which kms.reader does NOT contain).
# Without this assignment the instance creation fails with
# "STACKIT_KMS_PLUGIN: KMS Error: Access Forbidden".
# NOTE (Terratest/prerequisite): creating this role assignment requires the
# CALLER (the CI service account) to hold the "IAM Member Admin" role on the
# project (permission iam.member.add). Grant it out-of-band via the STACKIT
# Portal (IAM & management > Access) or the stackit CLI.
module "authorization" {
  source  = "terraform-stackit-modules/authorization/stackit"
  version = ">= 1.0.0"

  project_role_assignments = {
    kms = {
      resource_id = var.project_id
      role        = "kms.admin"
      subject     = module.service_account.service_account_email
    }
  }
}

module "encrypted_postgres" {
  source = "../.."

  project_id       = var.project_id
  name             = "example-encrypted-postgres"
  postgres_version = "17"
  flavor_id        = "4.8-replica"
  backup_schedule  = "0 0 * * *"
  retention_days   = 32

  storage = {
    class = "premium-perf2-stackit"
    size  = 5
  }

  network = {
    acl = ["0.0.0.0/0"]
  }

  # Storage encryption against the KEK. NOTE: `kek_key_version` is a STRING here
  # (unlike the volume module where it is a number). The service account must
  # hold the kms.admin role on the project (see the role assignment above);
  # no Act-As assignment is needed for the database services.
  encryption = {
    kek_key_id      = module.kms.key_ids["postgres_kek"]
    kek_key_version = "1"
    kek_keyring_id  = module.kms.keyring_id
    service_account = module.service_account.service_account_email
  }

  users = {
    app = {
      username = "app_user"
      roles    = ["login"]
    }
  }

  databases = {
    app = {
      name  = "app_db"
      owner = "app_user"
    }
  }

  # The instance must not be created before the service account can actually
  # use the key.
  depends_on = [module.authorization]
}
