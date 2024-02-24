oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\paradox.omp.json" | Invoke-Expression
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfCompletion }
Set-PSReadlineOption -EditMode vi
# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm2"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

function OnViModeChange {
    if ($args[0] -eq 'Command') {
        # Set the cursor to a blinking block.
        Write-Host -NoNewLine "`e[1 q"
    } else {
        # Set the cursor to a blinking line.
        Write-Host -NoNewLine "`e[5 q"
    }
}
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange
Set-PSReadLineOption -PredictionSource History

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PSReadLineKeyHandler -chord = -function Complete -vimode Command
Set-PSReadLineKeyHandler -chord "ctrl+e" -function AcceptSuggestion
Set-PSReadLineKeyHandler -chord Tab -function ForwardWord
Set-PSReadLineOption -PredictionViewStyle ListView


Import-Module Az.Tools.Predictor
Set-PSReadLineOption -PredictionSource HistoryAndPlugin

# enable direnv for powershell
Invoke-Expression "$(direnv hook pwsh)"

# powershell terminal integration
$Global:__LastHistoryId = -1

function Global:__Terminal-Get-LastExitCode {
  if ($? -eq $True) {
    return 0
  }
  $LastHistoryEntry = $(Get-History -Count 1)
  $IsPowerShellError = $Error[0].InvocationInfo.HistoryId -eq $LastHistoryEntry.Id
  if ($IsPowerShellError) {
    return -1
  }
  return $LastExitCode
}

function prompt {

  # First, emit a mark for the _end_ of the previous command.

  $gle = $(__Terminal-Get-LastExitCode);
  $LastHistoryEntry = $(Get-History -Count 1)
  # Skip finishing the command if the first command has not yet started
  if ($Global:__LastHistoryId -ne -1) {
    if ($LastHistoryEntry.Id -eq $Global:__LastHistoryId) {
      # Don't provide a command line or exit code if there was no history entry (eg. ctrl+c, enter on no command)
      $out += "`e]133;D`a"
    } else {
      $out += "`e]133;D;$gle`a"
    }
  }


  $loc = $($executionContext.SessionState.Path.CurrentLocation);

  # Prompt started
  $out += "`e]133;A$([char]07)";

  # CWD
  $out += "`e]9;9;`"$loc`"$([char]07)";

  # (your prompt here)
  $out += "PWSH $loc$('>' * ($nestedPromptLevel + 1)) ";

  # Prompt ended, Command started
  $out += "`e]133;B$([char]07)";

  $Global:__LastHistoryId = $LastHistoryEntry.Id

  return $out
}
