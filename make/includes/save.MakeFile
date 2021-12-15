save: save_to_branch git_add git_stash git_checkout git_pull git_stash_pop git_add_n_commit git_push

save_to_branch:
	@echo "Saving to: '$(or $(WORKING_BRANCH),dev)'"

git_add:
	git add -A

git_stash_pop:
	git stash pop

git_stash:
	git stash

git_add_n_commit:
	git add .
	git commit -m "WP"

git_push:
	git push

git_checkout:
	git checkout $(or $(WORKING_BRANCH),dev)

git_pull:
	git pull

