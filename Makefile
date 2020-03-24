.PHONY: run elixir k

run: elixir k
	@echo "ALL GOOD"


elixir:
	for f in *.exs; do elixir $$f; done

k:
	for f in *.k; do k $$f; done
