# Build Stage
FROM ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang

## Add source code to the build stage.
ADD . /cista
WORKDIR /cista

## TODO: ADD YOUR BUILD INSTRUCTIONS HERE.
RUN rm -rf build
RUN mkdir build/
RUN cd build/ && rm -rf *
RUN cd build/ && CC=clang CXX=clang++ cmake ..
#Make fuzz targets
RUN cd build/ && make cista-fuzz-hash_map_verification
RUN cd build/ && make cista-fuzz-graph

# Package Stage
FROM ubuntu:20.04

## TODO: Change <Path in Builder Stage>
COPY --from=builder /cista/build/cista-fuzz-hash_map_verification /
COPY --from=builder /cista/build/cista-fuzz-graph /
#COPY fuzz targets

#CMD ['/cista-fuzz-graph']
