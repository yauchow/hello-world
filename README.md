To make changes to the Gitops repo.

# Branching strategy

So we can maintain Production, QA, Dev and Feature branches.

We follow a similar branching strategy as Git Flow, except we have additional QA branch.

- main
  - qa
    - dev
      - feature/DFN-XXXX-TX-feature_description

## To begin work on a new Feature

1. First checkout a new branch from the current `dev` branch, using the name in the format:

DFN-XXXX-TX-feature_description

Where DFN-XXXX is the Jira ticket number of the epic your team is currently working on.

TX is your Team's initial, eg. T1, T2, T3 or T4.

2. Make changes to the infrastruction as required to support the new feature being developed. For most simple changes, where there are no new infrastructure changes, then update locals.tf with updated tag references to container images that should be deployed.
