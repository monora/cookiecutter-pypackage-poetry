
###################
[CmdletBinding()]
Param(
    [Parameter(Mandatory = $True, Position = 1)]
    [string]$bumpKind
)

$Script:BUMPFILES = ["__init__.py", "pyproject.toml"]

function getVersion() {
    $tag = Invoke-Expression "git describe --tags --always 2>&1"

    $tag = $tag.Split('-')[0]
    $tag = $tag -replace 'v', ''

    if ($tag -notmatch "\d+\.\d+\.\d+") {
        $tag = '1.0.0'
    }

    Write-Verbose "Version found: $tag"
    return $tag
}

function bumpVersion($kind, $version) {
    $major, $minor, $patch = $version.split('.')

    switch ($kind) {
        "major" {
            $major = [int]$major + 1
            $minor = "0"
            $patch = "0"
        }
        "minor" {
            $minor = [int]$minor + 1
            $patch = "0"
        }
        "patch" {
            $patch = [int]$patch + 1
        }
    }

    return [string]::Format("{0}.{1}.{2}", $major, $minor, $patch)
}

function commitVersion($kind, $version) {
    Write-Output "committing to Git..."
    # Invoke-Expression "git add **/*/AssemblyInfo.cs 2>&1 | Write-Output"
    Invoke-Expression "git commit -am 'Bumped $kind number. Version now $version' 2>&1 | Write-Output"
    Invoke-Expression "git tag v$version 2>&1 | Write-Output"
}

# Some functionality from https://gist.github.com/jokecamp/a2a314d62490fca1517a9a031c5606e9
function SetVersion ($file, $version) {
    Write-Output "Changing version in $file to $version"
    $fileObject = get-item $file

    $sr = new-object System.IO.StreamReader( $file, [System.Text.Encoding]::GetEncoding("utf-8") )
    $content = $sr.ReadToEnd()
    $sr.Close()

    $content = [Regex]::Replace( $content, "(\d+)\.(\d+)\.(\d+)[\.(\d+)]*", $version );

    $sw = new-object System.IO.StreamWriter( $file, $false, [System.Text.Encoding]::GetEncoding("utf-8") )
    $sw.Write( $content )
    $sw.Close()
}

function makeCopy($file) {
    Write-Output "Backing up $file"
    $parent = Split-Path -parent $file
    $filename = Split-Path -Path $file -Leaf -Resolve
    $front = $filename.split(".")[0]
    $back = $filename.split(".")[1]
    copy-item -path $file -destination ($parent + "\" + $front + "backup." + $back)
}

function setVersionInDir($dir, $version) {
    if ($version -eq "") {
        Write-Output "version not found"
        exit 1
    }

    # Set the Assembly version
    $info_files = Get-ChildItem $dir -Recurse -Include $Script:BUMPFILES

    foreach ($file in $info_files) {
        makeCopy $file
        Setversion $file $version
    }
}

$validCommands = @("major", "minor", "patch")

if ($bumpKind -eq '') {
    Write-Output "Missing which number to bump up!"
    exit 1
}

if (-not $validCommands.Contains($bumpKind)) {
    Write-Output "Invalid command!"
    exit 1
}

# Get current version with Git
$oldVersion = getVersion

# Bump version in all files
$newVersion = bumpVersion $bumpKind $oldVersion

$dir = "./"

# Set new version and new guids in files
setVersionInDir $dir $newVersion

# Dump the updated version number to Stdout so we can pick it up in CI when needed!
Write-Output $newVersion