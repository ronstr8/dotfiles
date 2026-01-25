#!/bin/bash

# Pull pgpass from Bitnami chart and connect to the wordwank db.

function kpsql() {
	POD_SELECTOR='app.kubernetes.io/name=postgresql'

	PG_USER='wordwank_backend'
	PG_DBNAME='wordwank'

	# Change below if not `kubectl config set-context --current --namespace=$MY_NAMESPACE`
	IRREGULAR_NAMESPACE='--namespace=wordwank'

	export IRREGULAR_NAMESPACE POD_SELECTOR
	POD_NAME="$( kubectl "${IRREGULAR_NAMESPACE}" get pod -l "${POD_SELECTOR}" -o jsonpath='{.items[0].metadata.name}' )"

	SECRET_LOCATOR='secrets/postgresql'
	PASSWORD_JSONPATH="$( [[ 'postgres' == "${PG_USER}" ]] && echo '{.data.password-postgresql}' || echo '{.data.password}' )"

	export POD_NAME SECRET_LOCATOR PASSWORD_JSONPATH
	PG_PASS=$( kubectl "${IRREGULAR_NAMESPACE}" get "${SECRET_LOCATOR}" -o jsonpath="${PASSWORD_JSONPATH}" | base64 --decode )

	export PG_PASS PG_USER PG_DBNAME
	kubectl "${IRREGULAR_NAMESPACE}" exec -it "pods/${POD_NAME}" -- env PSQL_HISTORY='/dev/null' PGPASSWORD="${PG_PASS}" psql -U "${PG_USER}" -d "${PG_DBNAME}"
}
