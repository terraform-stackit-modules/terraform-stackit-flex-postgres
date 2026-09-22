package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestExamplesComplete(t *testing.T) {

	// Provisioning a PostgreSQL Flex instance is slow (many minutes to create and
	// destroy). CI runs only the "basic" example; the long-running examples are skipped
	// unless TERRATEST_RUN_ALL is set. Run the full set locally with:
	//   TERRATEST_RUN_ALL=1 go test -v -timeout 90m ./...
	if os.Getenv("TERRATEST_RUN_ALL") == "" {
		t.Skip("skipping long-running example in CI; set TERRATEST_RUN_ALL=1 to run")
	}

	terraformOptions := &terraform.Options{
		TerraformDir: "../examples/complete",
		Vars: map[string]interface{}{
			"project_id": os.Getenv("STACKIT_PROJECT_ID"),
		},
	}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)
}
