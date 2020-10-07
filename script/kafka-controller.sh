#!/usr/bin/env bash

# Copyright (c) 2016-2017 Bitnami
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

if [ -z "$1" ]; then
#    TODO: Skip windows at this moment
    OS_PLATFORM_ARG=(-os="linux")
else
    OS_PLATFORM_ARG=($1)
fi

if [ -z "$2" ]; then
    OS_ARCH_ARG=(-arch="amd64")
else
    OS_ARCH_ARG=($2)
fi


GIT_COMMIT=$(git describe --tags --dirty --always)
BUILD_DATE=$(date)
BUILD_FLAGS=(-ldflags="-w -X github.com/kubeless/kafka-trigger/pkg/version.Version=${GIT_COMMIT}")

# Get rid of existing binaries
rm -rf bundles/kubeless*

# Build kafka-controller
gox "${OS_PLATFORM_ARG[@]}" "${OS_ARCH_ARG[@]}" \
    -output="bundles/kubeless_{{.OS}}-{{.Arch}}/kafka-controller" \
    "${BUILD_FLAGS[@]}" \
    ./cmd/kafka-trigger-controller
