$User = $Env:USERNAME
$NetUserCapture = net user /domain $User

switch -Regex ($NetUserCapture) {
    '^(Konto aktiv)\s{2,}(\S.+)$' { $KontoAktiv = $Matches[2] }
    '^(Benutzername)\s{2,}(\S.+)$' { $Benutzername = $Matches[2] }
    '^(Beschreibung)\s{2,}(\S.+)$' { $Beschreibung = $Matches[2] }
    '^(Konto abgelaufen)\s{2,}(\S.+)$' { $KontoAbgelaufen = $Matches[2] }
    '^(Letzte Anmeldung)\s{2,}(\S.+)$' { $LastLogon = $Matches[2] }
    '^(Kennwort l.uft ab)\s{2,}(\S.+)$' { $PasswordTimeOut = $Matches[2] }
    '^(Kennwort .nderbar)\s{2,}(\S.+)$' { $PasswordChangeable = $Matches[2] }
    '^(Vollst.ndiger Name)\s{2,}(\S.+)$' { $VollstName = $Matches[2] }
    '^(Kennwort erforderlich)\s{2,}(\S.+)$' { $PasswordNeeded = $Matches[2] }
    '^(Letztes Setzen des Kennworts)\s{2,}(\S.+)$' { $PasswordLastSet = $Matches[2] }
    '^(Benutzer kann Kennwort .ndern)\s{2,}(\S.+)$' { $PasswordUserChangeable = $Matches[2] }
}

[PSCustomObject]@{
    Benutzername                    = $Benutzername
    VollständigerName               = $VollstName
    Beschreibung                    = $Beschreibung
    'Konto aktiv'                   = $KontoAktiv
    'Konto abgelaufen'              = $KontoAbgelaufen
    'Letztes Setzen des Kennworts'  = $PasswordLastSet
    'Kennwort läuft ab'             = $PasswordTimeOut
    'Kennwort änderbar'             = $PasswordChangeable
    'Kennwort erforderlich'         = $PasswordNeeded
    'Benutzer kann Kennwort ändern' = $PasswordUserChangeable
    'Letzte Anmeldung'              = $LastLogon
}