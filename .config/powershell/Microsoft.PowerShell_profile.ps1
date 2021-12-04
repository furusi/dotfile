# Set-ExecutionPolicy -ExecutionPolicy RemoteSigned

if ($host.Name -eq 'ConsoleHost')
{
    Import-Module PSReadLine

    # キーバインドをEmacs風に変更
    Set-PSReadlineOption -EditMode Emacs

    # ### (以下追加)
    # Ctrl+i をTab と同じ "Complete" に割当
    Set-PSReadLineKeyHandler -Key Ctrl+i -Function Complete
    # Ctrl+j をEnter と同じ "AcceptLine" に割当
    Set-PSReadLineKeyHandler -Key Ctrl+j -Function AcceptLine

    # Ctrl+y を "Paste" に変更
    Set-PSReadLineKeyHandler -Key Ctrl+y -Function Paste
    # Ctrl+d を "DeleteChar" に変更
    Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteChar
    
}
