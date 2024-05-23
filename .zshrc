# z init 
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# powerlevel10k setup
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
zinit ice depth"1"
zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # Fuzzy search install

# add plugins
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-syntax-highlighting
zinit light Aloxaf/fzf-tab
zinit load agkozak/zsh-z

# completion style
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' fzf-bindings 'ctrl-y:accept'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

bindkey '\eOA' history-substring-search-up # or ^[OA
bindkey '\eOB' history-substring-search-down # or ^[OB
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

autoload -U select-word-style
select-word-style bash

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# envs
export GOPATH=/Users/orenherman/go
export PATH="$PATH:/opt/homebrew/bin/bin:/Users/orenherman/go/bin"
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export NVM_LAZY_LOAD=true
export GO111MODULE=on
export GOROOT="$(brew --prefix golang)/libexec"
export GOPRIVATE="github.com/stackpulse,stackpulse.dev,github.com/torqio"
export GOARCH=arm64
export GOOS=darwin
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=fg=red,bold,underline

# aliases
alias ls='ls --color'
alias jqre="jq '.message | fromjson'"
alias jqr="jq '.message | fromjson | {severity, timestamp, message, caller, \"logging.googleapis.com/trace\"}'"
alias log='git log --pretty=format:"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cgreen\\ [%cn]" --decorate --date=short'
alias status='git status -s'
alias diff='git diff --name-only --relative --diff-filter=d | xargs bat --diff'
alias gcm='git fetch && git checkout origin/master'
alias gcd='git fetch && git checkout origin/develop'
alias gmd='git fetch && git merge origin/develop'
alias gmm='git fetch && git merge origin/master'
alias gcb='git checkout -b '
alias gpu='git push -u origin $(git branch --show)'
alias pgtnlp="~/dev/cloud_sql_proxy -instances=stackpulse-production:us-central1:torqdb=tcp:5432"
alias pgtnls="~/dev/cloud_sql_proxy -instances=stackpulse-staging:europe-west1:torqdb=tcp:5431"
alias pgtnld="~/dev/cloud_sql_proxy -instances=stackpulse-development:europe-west1:stackpulsedb=tcp:5430"

prd-bq-fetch-workflow () {
	workflow_id=$1
	bq-fetch-workflow stackpulse-production $workflow_id
}
bq-fetch-workflow () {
	project=$1
	workflow_id=$2
	fetch_wf_output_path=/tmp/fetch-wf-${workflow_id}.output
	query="SELECT data FROM $project.bi.dim_workflow_revisions  WHERE workflow_id = '${workflow_id}' ORDER BY created_at DESC LIMIT 1"
	echo "fetching workflow into: $fetch_wf_output_path"
	bq query --format=prettyjson --use_legacy_sql=false $query 2> /dev/null | jq '.[0].data' -r > $fetch_wf_output_path
	# cat $fetch_wf_output_path | yq -r -P - | code -
        ynv $fetch_wf_output_path
}
ynv () {
        yq $1 -o=json | jnv
}
function gcob() { 
	branch_name=$(echo $1 | awk 'match($0, /SP-[0-9]+/) { print substr( $0, RSTART, RLENGTH )}')
	git fetch
        git checkout -b $branch_name origin/master
 }

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/orenherman/dev/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/orenherman/dev/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/orenherman/dev/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/orenherman/dev/google-cloud-sdk/completion.zsh.inc'; fi

