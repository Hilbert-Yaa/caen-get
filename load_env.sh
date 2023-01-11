#!/usr/bin/env zsh

envFile="${1?@@Usage: $0 [PATH_TO_DOTENV]}"
SHELL=$(readlink /proc/$$/exe)
# NOTE: remove commented and blank lines
if [[ $SHELL == *bash ]]
then
    mapfile envAsArray < <(
        grep --invert-match '^#' "${envFile}" \
        | grep --invert-match '^\s*$'
    )
elif [[ $SHELL == *zsh ]]
then
    # NOTE: since zsh doesn't support mapfile
    # envAsArray=("${(f)$(< ${envFile})}")
    envAsArray=("${(f)$(
        grep --invert-match '^#' "${envFile}" \
        | grep --invert-match '^\s*$'
    )}")
else
    echo "@@Error: Unsupported shell"; 
fi

for varDecl in "${envAsArray[@]}"; do
    # NOTE: remove the line breaks when exporting
    export "${varDecl//[$'\r\n']}"
done