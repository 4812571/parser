# Build Stage
FROM ghcr.io/evanrichter/cargo-fuzz:latest AS BUILDER

# Add source code to the build stage.
ADD . /src
WORKDIR /src

# Compile the fuzzers
RUN cargo +nightly fuzz build

# Package stage
FROM ubuntu:latest AS PACKAGE

# Copy the corpora to the final image
COPY --from=BUILDER /src/tests/fixtures/0001/code.php /corpus/programs/code_1.php
COPY --from=BUILDER /src/tests/fixtures/0002/code.php /corpus/programs/code_2.php
COPY --from=BUILDER /src/tests/fixtures/0003/code.php /corpus/programs/code_3.php
COPY --from=BUILDER /src/tests/fixtures/0004/code.php /corpus/programs/code_4.php
COPY --from=BUILDER /src/tests/fixtures/0005/code.php /corpus/programs/code_5.php
COPY --from=BUILDER /src/tests/fixtures/0006/code.php /corpus/programs/code_6.php
COPY --from=BUILDER /src/tests/fixtures/0007/code.php /corpus/programs/code_7.php
COPY --from=BUILDER /src/tests/fixtures/0008/code.php /corpus/programs/code_8.php

# Copy the fuzzers to the final image
COPY --from=BUILDER /src/./fuzz/target/x86_64-unknown-linux-gnu/release/fuzz_* /fuzzers/