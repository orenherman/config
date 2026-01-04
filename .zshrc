# z init 
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# powerlevel10k setup
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
zinit ice depth "1"
zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # Fuzzy search install
autoload -Uz compinit; compinit
# add plugins
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-syntax-highlighting
zinit load agkozak/zsh-z
zinit wait lucid light-mode for lukechilds/zsh-nvm
zinit load 'zsh-users/zsh-history-substring-search'
zinit ice wait atload'_history_substring_search_config'

# completion style
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' fzf-bindings 'ctrl-y:accept'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

bindkey '^p' history-substring-search-up # or ^[OA
bindkey '^n' history-substring-search-down # or ^[OB
bindkey -e
# bindkey '^p' history-search-backward
# bindkey '^n' history-search-forward
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
export PATH="$PATH:/opt/homebrew/bin/bin:/Users/orenherman/go/bin:/Users/orenherman/.npm-global/bin:/Users/orenherman/.local/bin"
export PATH="/opt/homebrew/opt/python@3.12/bin:$PATH"
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
export ANTHROPIC_API_KEY=
export OPENAI_API_KEY=

# aliases
alias python=python3
alias vim=nvim
alias nvims='nvim -c "lua MiniSessions.read(\"Session.vim\")"'
alias cloud_sql_proxy=cloud-sql-proxy
alias sf='fzf -m --preview="bat --color=always {}" --bind "ctrl-w:execute(nvim {+})+abort,ctrl-y:execute-silent(echo {} | pbcopy)+abort"'
alias -g W='pbpaste | nvim -c "setlocal buftype=nofile bufhidden=wipe" -c "nnoremap <buffer> q :q!<CR>" -'
alias lsa='eza -1 -l --icons -a'
# alias ls='eza'
alias ls="eza --color=always --git --no-user --no-permissions --icons=always --group-directories-first"
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
alias gp='git push'
alias gmo='gcm && nvims .'
alias pgtnlp="~/dev/cloud_sql_proxy -instances=stackpulse-production:us-central1:torqdb=tcp:5432"
alias pgtnls="~/dev/cloud_sql_proxy -instances=stackpulse-staging:europe-west1:torqdb=tcp:5431"
alias pgtnld="~/dev/cloud_sql_proxy -instances=stackpulse-development:europe-west1:stackpulsedb=tcp:5430"
tq-whois () {
	grep $1 $HOME/dev/accounts.csv
}
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
bq-dump-all-accounts () {
	project=${1:-"stackpulse-production"}
	accounts_file="$HOME/dev/accounts.csv"
	accounts_file_backup="$HOME/dev/accounts.csv.bk"
	cp $accounts_file $accounts_file_backup
	query=$(cat << EOF
	SELECT
  o.name AS organization_name,
  a.short_name AS account_short_name,
  a.name AS account_name,
  a.id AS account_id,
  o.id AS organization_id,
  o.region as org_region 
FROM
  $project.bi.dim_accounts a
LEFT JOIN
  $project.bi.dim_orgs o
ON
  o.id = a.organization_id
ORDER BY
  o.id DESC

EOF
)
	tmp_accounts_file="/tmp/accounts.tmp.json"
	bq query --format=prettyjson --use_legacy_sql=false --max_rows 100000 $query 2> /dev/null > $tmp_accounts_file
	cat $tmp_accounts_file | jq -r '.[] | [.organization_name, .account_short_name, .account_name, .account_id, .org_region, .organization_id ] | @csv' | sort | tr -d '"' > $accounts_file
}
ynv () {
        yq $1 -o=json | jnv
}
function gcob() { 
	branch_name=$(echo $1 | awk 'match($0, /SP-[0-9]+/) { print substr( $0, RSTART, RLENGTH )}')
	git fetch
        git checkout -b $branch_name origin/master
 }
function kgr() {
    local deployment_name=$1
    local context=$2

    if [ -z "$context" ]; then
        kubectl argo rollouts get rollout "$deployment_name" -w
    else
        kubectl argo rollouts get rollout "$deployment_name" -w --context "$context"
    fi
}
preexec() {
  local cmd=$1
  if [[ $cmd == nvim* ]] || [[ $cmd == vim* ]]; then
    # Set tab title to: nvim - directory_name
    echo -ne "\033]0;nvim - $(basename "$PWD")\007"
  fi
}
rnt() {
    local name=$1
    echo -ne "\033]0;$1\007"
}

source "/Users/orenherman/dev/app/local_env/app_dotfile.sh"

# pnpm
export PNPM_HOME="/Users/orenherman/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
