# workflow-test-with-monorepo

## Monorepo Structure

```sh
packages
  - aaa (nextjs)
  - bbb (nextjs)
```

## Concepts

```sh
# Release [PACKAGE] package with feature branch to development environment
git switch -c feature/[PACKAGE]/issue-1234
# merge into develop
# will trigger .github/workflows/release-dev.yaml
# will generate docker images
#  - owner/repo/[PACKAGE]-dev:short-sha
#  - owner/repo/[PACKAGE]-dev:latest

# Release version v1.0.0-rc0 [PACKAGE] package to staging environment when merge into main branch
git switch -c release/[PACKAGE]/v1.0.0-rc0
# merge into main
# will trigger .github/workflows/release-staging.yaml
# will generate docker images
#  - owner/repo/[PACKAGE]-staging:short-sha
#  - owner/repo/[PACKAGE]-staging:latest

# Release version v1.0.0 aaa package to production when create new tag in main
git tag -am 'aaa/v1.0.0'
# will trigger .github/workflows/release-prod.yaml
# will generate docker images
#  - owner/repo/aaa:short-sha
#  - owner/repo/aaa:latest
#  - owner/repo/aaa:v1.0.0

# Release version v1.1.2 bbb package to production when create new tag in main
git tag -am 'bbb/v1.1.2'
# will trigger .github/workflows/release-prod.yaml
# will generate docker images
#  - owner/repo/bbb:short-sha
#  - owner/repo/bbb:latest
#  - owner/repo/bbb:v1.1.2

# Build
git checkout feature/aaa/issue-1234
gh pr comment -b '/build'
gh pr comment -b '/build dev aaa'

git checkout fix/aaa/issue-1235
gh pr comment -b '/build'
gh pr comment -b '/build dev aaa'

# Deploy
git checkout feature/bbb/issue-1236
gh pr comment -b '/deploy'
gh pr comment -b '/deploy dev bbb'
```

## Actions

| Environment | Status
|-------------|--------
| dev         | [![dev](https://github.com/rhiokim/workflow-test-with-monorepo/actions/workflows/release-dev.yaml/badge.svg)](https://github.com/rhiokim/workflow-test-with-monorepo/actions/workflows/release-dev.yaml)
| staging     | [![staging](https://github.com/rhiokim/workflow-test-with-monorepo/actions/workflows/release-staging.yaml/badge.svg)](https://github.com/rhiokim/workflow-test-with-monorepo/actions/workflows/release-staging.yaml)
| prod        | [![prod](https://github.com/rhiokim/workflow-test-with-monorepo/actions/workflows/release-prod.yaml/badge.svg)](https://github.com/rhiokim/workflow-test-with-monorepo/actions/workflows/release-prod.yaml)

## References

* https://github.community/t/how-to-trigger-on-a-release-only-if-tag-name-matches-pattern/18514/2
