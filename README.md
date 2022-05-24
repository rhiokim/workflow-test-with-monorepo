# workflow-test-with-monorepo

## Monorepo Structure

```sh
packages
  - aaa
  - bbb
```

## Concepts

## Development

## Staging

```sh
# in main branch
git switch -c release/bbb/v0.0.0
git push -u origin release/bbb/v0.0.1
merge into main

will generated

// -> docker
// - ghcr.io/rhiokim/workflow-test-with-monorepo/bbb-dev:latest
// - ghcr.io/rhiokim/workflow-test-with-monorepo/bbb-dev:sha-8e7f2f3
```
