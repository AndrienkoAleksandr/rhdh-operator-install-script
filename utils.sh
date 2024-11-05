#!/bin/bash

install_rhdh_operator() {
    oc new-project rhdh-operator || true

    DISPLAY_NAME="Red Hat Developer Hub Operator"
    if oc get csv -n "openshift-operators" | grep -q "${DISPLAY_NAME}"; then
    echo "Red Hat OpenShift Pipelines operator is already installed."
    else
    echo "Red Hat OpenShift Pipelines operator is not installed. Installing..."
    oc apply -f "./rhdh-operator-group.yaml"
    oc apply -f "./rhdh-operator-subscription.yaml"
    fi

    until oc get csv -n openshift-operators | grep -q "${DISPLAY_NAME}.*Succeeded"; do
        echo "Waiting for the CSV to reach the 'Succeeded' phase..."
        sleep 10
    done
}
