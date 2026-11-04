#!/bin/bash

# Get the current default kubectl namespace.

KUBECTL=$( which kubectl || echo ':' )

function kns() {
	declare toNamespace="${1}" ; shift

	if [ ! -n "${toNamespace}" ] ; then
		$KUBECTL config view --minify --output 'jsonpath={..namespace}'
		return
	fi

	if ( ! $KUBECTL get namespaces | grep --quiet $toNamespace ) ; then
		echo "No such namespace in current cluster" > /dev/stderr
		return 1
	fi

	$KUBECTL config set-context --current --namespace="${toNamespace}"
}

function k() {
	$KUBECTL "$@"
}

# Pull pgpass from Bitnami chart and connect to the wordwonk db.
# Should make this more generic.

function kpsql() {
	POD_SELECTOR='app.kubernetes.io/name=postgresql'

	PG_USER='wordwonk_backend'
	PG_DBNAME='postgres'

	# Change below if not `$KUBECTL config set-context --current --namespace=$MY_NAMESPACE`
	IRREGULAR_NAMESPACE='--namespace=wordwonk'

	export IRREGULAR_NAMESPACE POD_SELECTOR
	POD_NAME="$( $KUBECTL "${IRREGULAR_NAMESPACE}" get pod -l "${POD_SELECTOR}" -o jsonpath='{.items[0].metadata.name}' )"

	SECRET_LOCATOR='secrets/postgresql'
	PASSWORD_JSONPATH="$( [[ 'postgres' == "${PG_USER}" ]] && echo '{.data.password-postgresql}' || echo '{.data.password}' )"

	export POD_NAME SECRET_LOCATOR PASSWORD_JSONPATH
	PG_PASS=$( $KUBECTL "${IRREGULAR_NAMESPACE}" get "${SECRET_LOCATOR}" -o jsonpath="${PASSWORD_JSONPATH}" | base64 --decode )

	export PG_PASS PG_USER PG_DBNAME
	$KUBECTL "${IRREGULAR_NAMESPACE}" exec -it "pods/${POD_NAME}" -- env PSQL_HISTORY='/dev/null' PGPASSWORD="${PG_PASS}" psql -U "${PG_USER}" -d "${PG_DBNAME}"
}

complete -F __start_kubectl k

