package test

import (
	"fmt"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"strings"
	"testing"
)

func TestModuleCreatesAthena(t *testing.T) {
	const region string = "eu-west-1"

	var bucketName = fmt.Sprintf("test-athena-%s", strings.ToLower(random.UniqueId()))

	terraformOptions := &terraform.Options{
		TerraformDir: "fixtures/default",

		Vars: map[string]interface{}{
			"region":      region,
			"bucket_name": bucketName,
		},

		NoColor: true,
	}

	keys := []string{"query_ids", "output_bucket", "database_bucket"}

	defer terraform.Destroy(t, terraformOptions)
	terraform.InitAndApply(t, terraformOptions)

	out := terraform.OutputForKeys(t, terraformOptions, keys)

	queryIds, ok := out["query_ids"].(map[string]interface{})
	require.True(t, ok, fmt.Sprintf("Wrong data type for 'query_ids', expected map[string], got %T", out["query_ids"]))

	queryid := queryIds["adaptavist-terraform-integration-athena-test-"+bucketName+"_search_all"].(string)
	fmt.Print("query id: ")
	fmt.Println(queryid)
	assert.NotEmpty(t, queryid)

}
