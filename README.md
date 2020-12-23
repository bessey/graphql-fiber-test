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

However nested fields don't batch as well as I had hoped. In the following example the 3 nested post replies are all
independently fetched, not sure why yet.

```graphql
query {
  a: postFiber(id: "3") {
    id
    title
    reply {
      id
      title
      reply {
        id
      }
    }
  }

  b: postFiber(id: "4") {
    id
    title
    reply {
      id
      title
    }
  }
}
```

The common case works nicely though

```graphql
query {
  blog(id: "1") {
    id
    posts {
      id
      title
      # This would be an N+1 but isn't
      reply {
        id
        title
      }
    }
  }
}
```
