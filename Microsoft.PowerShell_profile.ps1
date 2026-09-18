$dotfilesDirectory = Join-Path $HOME '.dotfiles'

function Add-PathEntry {
  param([string]$PathEntry)

  if ((Test-Path $PathEntry) -and (($env:Path -split [IO.Path]::PathSeparator) -notcontains $PathEntry)) {
    $env:Path = "$PathEntry$([IO.Path]::PathSeparator)$env:Path"
  }
}

if (-not $env:GOPATH) {
  $env:GOPATH = Join-Path $HOME 'go'
}

Add-PathEntry (Join-Path $HOME '.dotnet/tools')
Add-PathEntry (Join-Path $HOME '.cargo/bin')
Add-PathEntry (Join-Path $HOME 'bin')
Add-PathEntry (Join-Path $env:GOPATH 'bin')
Add-PathEntry (Join-Path $HOME '.local/bin')

function dotfiles { & git --git-dir=(Join-Path $dotfilesDirectory '.git') --work-tree=$HOME @args }
function gs { git status @args }
function gb { git branch @args }
function gc { git checkout @args }
function gl { git log --oneline --decorate --color @args }
function amend { git add .; git commit --amend --no-edit }
function commit { git add .; git commit -m $args }
function diff { git diff @args }
function force { git push --force-with-lease @args }
function pop { git stash pop @args }
function prune { git fetch --prune @args }
function pull { git pull @args }
function push { git push @args }
function resolve { git add .; git commit --no-edit }
function stash { git stash -u @args }
function unstage { git restore --staged . }
function wip { commit wip }

function compose { docker compose @args }
function ll { Get-ChildItem -Force @args }

if (Get-Command kubectl -ErrorAction SilentlyContinue) {
  Set-Alias -Name k -Value kubectl
  kubectl completion powershell | Out-String | Invoke-Expression
}

if (Get-Command uv -ErrorAction SilentlyContinue) {
  uv generate-shell-completion powershell | Out-String | Invoke-Expression
}
