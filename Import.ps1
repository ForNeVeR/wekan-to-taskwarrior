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

$labels = @{}
$document.labels | % { $labels[$_._id] = $_ }

function tags($listId, $labelIds) {
    $list = $lists[$listId]
    if ($list) {
        '+' + $list.title.Replace(' ', '-').ToLower()
    }

    if ($labelIds) {
        $labelIds | % {
            $label = $labels[$_]
            if ($label) {
                '+' + $label.name.Replace(' ', '-').ToLower()
            }
        }
    }
}

$document.cards | Sort-Object -Property dateLastActivity | % {
    $card = $_
    $action = if ($card.archived) { 'log' } else { 'add' }
    $title = enquote $card.title
    $tags = (tags $card.listId $card.labelIds) -join ' '
    "$task $action $BoardTag $tags $title"
}
