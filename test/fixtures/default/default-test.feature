Feature: Athena queries

  Scenario: Athena named query is created
    Given I have aws_athena_named_query defined
    Then it must contain query

  Scenario: Athena named query has a correct name
    Given I have aws_athena_named_query defined
    Then it must contain name
    And its value must match the ".*_search_all" regex

  Scenario: Athena database is created
    Given I have aws_athena_database defined
    Then it must contain name
    And its value must match the ".*_athena_test_.*" regex

  Scenario: Athena workgroup is created with s3 bucket output location
    Given I have aws_athena_workgroup defined
    Then it must contain configuration
    And it must contain result_configuration
    And it must contain output_location
    And its value must match the "s3:.*" regex

  Scenario: Athena workgroup is created with encryption configuration
    Given I have aws_athena_workgroup defined
    Then it must contain configuration
    And it must contain result_configuration
    And it must contain encryption_configuration
