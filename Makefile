.PHONY: verify

verify:
	./scripts/verify-token-budget.sh .
	./scripts/verify-platform-names.sh .
	./scripts/verify-behavior-fixtures.sh .
	./scripts/verify-secrets-safe.sh .
	./scripts/test-verify-scripts.sh
