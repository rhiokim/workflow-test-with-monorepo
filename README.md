# workflow-test-with-monorepo

## monorepo structure

```sh
packages
  - aaa
  - bbb
```

## release

```
git switch -c release/dev/bbb/v0.0.0
git push -u origin release/dev/bbb/v0.0.1
merge

will generated

// -> docker
// - ghcr.io/rhiokim/workflow-test-with-monorepo/bbb-dev:latest
// - ghcr.io/rhiokim/workflow-test-with-monorepo/bbb-dev:sha-8e7f2f3
```
