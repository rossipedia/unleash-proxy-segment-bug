### Reproduction steps:

1. Ensure you have `docker` available
2. Run `docker compose up` to start `unleash`, `postgres`, and `unleash-proxy`
    - If you see an error about not being able to create initial admin api tokens, then run:
      `docker compose down && docker compose up`. Not sure why it has trouble on the first try
3. Run `./bootstrap.sh` to add a new Segment and Feature with that Segment assigned to it
4. Run `npm install` to install dependencies for running the test
5. Run `npm test` to see the bug
