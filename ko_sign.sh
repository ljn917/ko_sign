#!/bin/bash

# Usage: sudo ./ko_sign.sh [-i | kernel_version]
# Without arguments, it signs the current kernel.
# -i is the interactive mode. It is convenient for signing a newly installed kernel.

source ./env.sh

KERNEL_BASE_DIR="/lib/modules"
KERNEL_VERSION=$(uname -r)
if [ $# -ge 1 ]; then
    KERNEL_VERSION=$1
fi
echo "kernel version: ${KERNEL_VERSION}"

function sign() {
    echo "signing: $1"
    /usr/src/kernels/${KERNEL_VERSION}/scripts/sign-file sha256 "${KEY}" "${CERT}" "$1"
}

if [[ $1 == "-i" ]]; then
    ALL_KERNEL_VERSIONS=(`ls ${KERNEL_BASE_DIR}`)
    for i in "${!ALL_KERNEL_VERSIONS[@]}"; do
        echo "${i}: ${ALL_KERNEL_VERSIONS[i]}"
    done
    read -p "Enter option (default ${ALL_KERNEL_VERSIONS[-1]}): " option
    if [ -z "$option" ]; then
        option="-1"
    fi
    KERNEL_VERSION=${ALL_KERNEL_VERSIONS[option]}
    echo "Selected kernel version: ${KERNEL_VERSION}"
    if [ -z "$KERNEL_VERSION" ]; then
        echo "ERROR: Option (${option}) is not valid."
        exit -1
    fi
fi

for module_name in ${MODULES[@]}; do
    module_dir_or_file=${KERNEL_BASE_DIR}/${KERNEL_VERSION}/${module_name}
    if [[ -d ${module_dir_or_file} ]]; then
        # is dir
        # sign all modules in this directory, but ignore subdirs
        for module_filename in $(ls ${module_dir_or_file}); do
            sign "${module_dir_or_file}/${module_filename}"
        done
    else
        # is file
        # single module
        sign "${module_dir_or_file}"
    fi
done
