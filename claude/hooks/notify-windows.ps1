# Claude Code notification hook — Windows toast notification.
# Reads JSON with "title" and "message" fields from stdin.
# Uses WinRT toast notifications via PowerShell 5.1.

$ErrorActionPreference = 'Stop'

try {
    $json = [Console]::In.ReadToEnd()

    # Minimal JSON parsing without external dependencies
    $data = $json | ConvertFrom-Json
    $title   = if ($data.title)   { $data.title }   else { 'Claude Code' }
    $message = if ($data.message) { $data.message } else { '' }

    # XML-escape to prevent injection via notification content
    $title   = [System.Security.SecurityElement]::Escape($title)
    $message = [System.Security.SecurityElement]::Escape($message)

    # Load WinRT toast notification types
    [void][Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
    [void][Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom, ContentType = WindowsRuntime]

    $template = @"
<toast>
  <visual>
    <binding template="ToastGeneric">
      <text>$title</text>
      <text>$message</text>
    </binding>
  </visual>
</toast>
"@

    $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $xml.LoadXml($template)

    # Use PowerShell's AppId so notifications appear as "Windows PowerShell"
    $appId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
    $notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($appId)
    $toast = New-Object Windows.UI.Notifications.ToastNotification($xml)
    $notifier.Show($toast)
}
catch {
    # Silently ignore errors — notification failure must never block Claude
    exit 0
}
