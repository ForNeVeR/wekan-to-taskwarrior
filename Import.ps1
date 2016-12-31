param (
    [Parameter(Mandatory = $true)] [string] $WekanFile,
    [string] $BoardTag,

    [string] $task = 'task'
)

$ErrorActionPreference = 'Stop'

function enquote($string) {
    '"' + $string.Replace('"', '\"').Replace("`n", '\n').Replace("`r", '\r').Replace('`', '\`') + '"'
}

$document = Get-Content $WekanFile -Encoding UTF8 | ConvertFrom-Json
$lists = @{}
$document.lists | % { $lists[$_._id] = $_ }

function tag($listId) {
    $list = $lists[$listId]
    if ($list) {
        "+" + $list.title.Replace(' ', '-').ToLower()
    } else {
        $null
    }
}

$document.cards | Sort-Object -Property dateLastActivity | % {
    $card = $_
    $action = if ($card.archived) { 'log' } else { 'add' }
    $title = enquote $card.title
    $tag = tag $card.listId
    "$task $action $BoardTag $tag $title"
}
