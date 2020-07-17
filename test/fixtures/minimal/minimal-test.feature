Feature: Athena queries

  Scenario: Athena named query is created
    Given I have aws_athena_named_query defined
    Then it must contain query

  Scenario: Athena named query has a correct name
    Given I have aws_athena_named_query defined
    Then it must contain name
    And its value must match the ".*_search_all" regex

  Scenario: Athena named query uses primary workgroup
    Given I have aws_athena_named_query defined
    Then it must contain workgroup
    And its value must be primary