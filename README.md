# Fiber batch loader proof of concept

When running the following query you will observe that a + b are independently searched for, but c + d are batched.

```graphql
query {
  a: post(id: "1") {
    id
    title
  }

  b: post(id: "2") {
    id
    title
  }

  c: postFiber(id: "3") {
    id
    title
  }

  d: postFiber(id: "4") {
    id
    title
  }
}
```
