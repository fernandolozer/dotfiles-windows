# # Configure Visual Studio
# if ((Test-Path "hklm:\SOFTWARE\Microsoft\VisualStudio\SxS\VS7") -or (Test-Path "hklm:\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VS7")) {
#     # Add a folder to $env:Path
#     function Append-EnvPath([String]$path) { $env:PATH = $env:PATH + ";$path" }
#     function Append-EnvPathIfExists([String]$path) { if (Test-Path $path) { Append-EnvPath $path } }

#     $vsRegistry = Get-Item "hklm:\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VS7" -ErrorAction SilentlyContinue
#     if ($vsRegistry -eq $null) { $vsRegistry = Get-Item "hklm:\SOFTWARE\Microsoft\VisualStudio\SxS\VS7" }
#     $vsVersion  = $vsRegistry.property | Sort-Object {[int]$_} -Descending | Select-Object -first 1
#     $vsinstall  = ForEach-Object -process {$vsRegistry.GetValue($vsVersion)}
#     Remove-Variable vsRegistry

#     if ((Test-Path $vsinstall) -eq 0) {Write-Error "Unable to find Visual Studio installation"}

#     $env:VisualStudioVersion = $vsVersion
#     $env:Framework40Version  = "v4.0"
#     $env:VSINSTALLDIR = $vsinstall
#     $env:DevEnvDir    =  Join-Path $vsinstall "Common7\IDE\"
#     if (!($env:Path).Split(";").Contains($vsinstall)) { Append-EnvPath $vsinstall }
#     $vsCommonToolsVersion = $vsVersion.replace(".","")
#     Invoke-Expression "`$env:VS${vsCommonToolsVersion}COMN = Join-Path `"$vsinstall`" `"Common7\Tools`""
#     Invoke-Expression "`$env:VS${vsCommonToolsVersion}COMNTOOLS = Join-Path `"$vsinstall`" `"Common7\Tools`""
#     Remove-Variable vsCommonToolsVersion
#     Remove-Variable vsinstall

#     $env:GYP_MSVS_VERSION = @{
#                               "9.0"="2008";
#                               "10.0"="2010";
#                               "11.0"="2012";
#                               "12.0"="2013";
#                               "14.0"="2015";
#                               "15.0"="2017";
#                              }.Get_Item($vsVersion)

#     Append-EnvPathIfExists (Join-Path $env:VSINSTALLDIR "Common7\Tools")
#     Append-EnvPathIfExists (Join-Path $env:VSINSTALLDIR "Team Tools\Performance Tools")
#     Append-EnvPathIfExists (Join-Path $env:VSINSTALLDIR "VSTSDB\Deploy")
#     Append-EnvPathIfExists (Join-Path $env:VSINSTALLDIR "CommonExtensions\Microsoft\TestWindow")
#     Append-EnvPathIfExists (Join-Path $env:ProgramFiles "MSBuild\$vsVersion\bin")
#     Append-EnvPathIfExists (Join-Path ${env:ProgramFiles(x86)} "MSBuild\$vsVersion\bin")
#     Append-EnvPathIfExists (Join-Path $env:ProgramFiles "Microsoft SDKs\TypeScript")
#     Append-EnvPathIfExists (Join-Path ${env:ProgramFiles(x86)} "Microsoft SDKs\TypeScript")
#     Append-EnvPathIfExists (Join-Path $env:ProgramFiles "HTML Help Workshop")
#     Append-EnvPathIfExists (Join-Path ${env:ProgramFiles(x86)} "HTML Help Workshop")

#     Remove-Variable vsVersion

#     if ((Test-Path "hklm:\SOFTWARE\Microsoft\VisualStudio\SxS\VC7") -or (Test-Path "hklm:\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VC7")) {
#         $vcRegistry = Get-Item "hklm:\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VC7" -ErrorAction SilentlyContinue
#         if ($vcRegistry -eq $null) { $vcRegistry = Get-Item "hklm:\SOFTWARE\Microsoft\VisualStudio\SxS\VC7" }
#         $env:VCINSTALLDIR   = $vcRegistry.GetValue($env:VisualStudioVersion)
#         $env:FrameworkDir32 = $vcRegistry.GetValue("FrameworkDir32")
#         $env:FrameworkDir64 = $vcRegistry.GetValue("FrameworkDir64")
#         $env:FrameworkDir   = $env:FrameworkDir32
#         $env:FrameworkVersion32 = $vcRegistry.GetValue("FrameworkVer32")
#         $env:FrameworkVersion64 = $vcRegistry.GetValue("FrameworkVer64")
#         $env:FrameworkVersion   = $env:FrameworkVersion32
#         Remove-Variable vcRegistry

#         Append-EnvPathIfExists (Join-Path $env:FrameworkDir $env:Framework40Version)
#         Append-EnvPathIfExists (Join-Path $env:FrameworkDir $env:FrameworkVersion)
#         Append-EnvPathIfExists (Join-Path $env:VCINSTALLDIR "VCPackages")
#         Append-EnvPathIfExists (Join-Path $env:VCINSTALLDIR "bin")

#         if (Test-Path (Join-Path $env:VCINSTALLDIR "ATLMFC\INCLUDE")) { $env:INCLUDE = $env:INCLUDE + ";" + $(Join-Path $env:VCINSTALLDIR "ATLMFC\LIB") }
#         if (Test-Path (Join-Path $env:VCINSTALLDIR "INCLUDE")) { $env:INCLUDE = $env:INCLUDE + ";" + $(Join-Path $env:VCINSTALLDIR "LIB") }

#         if (Test-Path (Join-Path $env:VCINSTALLDIR "ATLMFC\LIB")) {
#             $env:LIB = $env:LIB + ";" + $(Join-Path $env:VCINSTALLDIR "ATLMFC\LIB")
#             $env:LIBPATH = $env:LIBPATH + ";" + $(Join-Path $env:VCINSTALLDIR "ATLMFC\LIB")
#         }
#         if (Test-Path (Join-Path $env:VCINSTALLDIR "LIB")) {
#             $env:LIB = $env:LIB + ";" + $(Join-Path $env:VCINSTALLDIR "LIB")
#             $env:LIBPATH = $env:LIBPATH + ";" + $(Join-Path $env:VCINSTALLDIR "LIB")
#         }

#         if (Test-Path (Join-Path $env:FrameworkDir $env:Framework40Version)) { $env:LIBPATH = $env:LIBPATH + ";" + $(Join-Path $env:FrameworkDir $env:Framework40Version) }
#         if (Test-Path (Join-Path $env:FrameworkDir $env:FrameworkVersion)) { $env:LIBPATH = $env:LIBPATH + ";" + $(Join-Path $env:FrameworkDir $env:FrameworkVersion) }
#     }

#     if ((Test-Path "hklm:\SOFTWARE\Microsoft\VisualStudio\SxS\VC7") -or (Test-Path "hklm:\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\SxS\VC7")) {
#         $msBuildToolsRegistryPath = "hklm:\SOFTWARE\Wow6432Node\Microsoft\MSBuild\ToolsVersions"
#         if (${Test-Path $msBuildToolsRegistertPath} -eq $false) { $msBuildToolsRegistryPath = "hklm:\SOFTWARE\Microsoft\MSBuild\ToolsVersions" }

#         $msBuildVersion = Get-ChildItem $msBuildToolsRegistryPath | Sort-Object {[float] (Split-Path -Leaf $_.Name)} -Descending | Select-Object @{N='Name';e={Split-Path -Leaf $_.Name}} -First 1 | Select -ExpandProperty "Name"
#         $msBuildRegistry = Get-Item (Join-Path $msBuildToolsRegistryPath $msBuildVersion)
#         $msBuildToolsRoot = $msBuildRegistry.GetValue("MSBuildToolsRoot")

#         $msBuildRegistry.property | where {$_ -like "VCTargetsPath*"} | ForEach-Object {
#             $vcTargetsPathValue = $msBuildRegistry.GetValue($_)
#             $vcTargetsPath = $vcTargetsPathValue.Substring($vcTargetsPathValue.IndexOf("`$(MSBuildExtensionsPath32)")+26).TrimEnd("')")
#             Invoke-Expression "`$env:${_} = Join-Path `"$msBuildToolsRoot`" `"$vcTargetsPath`""
#             Remove-Variable vcTargetsPath
#             Remove-Variable vcTargetsPathValue
#         }

#         Remove-Variable msBuildVersion
#         Remove-Variable msBuildToolsRoot
#         Remove-Variable msBuildRegistry
#         Remove-Variable msBuildToolsRegistryPath
#     }

#     if ((Test-Path "hklm:\SOFTWARE\Microsoft\VisualStudio\$vsVersion\Setup\F#") -or (Test-Path "hklm:\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\$vsVersion\Setup\F#")) {
#         $fsRegistry = Get-Item "hklm:\SOFTWARE\Wow6432Node\Microsoft\VisualStudio\$vsVersion\Setup\F#" -ErrorAction SilentlyContinue
#         if ($fsRegistry -eq $null) { $fsRegistry = Get-Item "hklm:\SOFTWARE\Microsoft\VisualStudio\$vsVersion\Setup\F#" }
#         $env:FSHARPINSTALLDIR = $fsRegistry.GetValue("ProductDir")
#         Append-EnvPathIfExists $env:FSHARPINSTALLDIR
#         Remove-Variable fsRegistry
#     }


#     # Configure Visual Studio functions
#     function Start-VisualStudio ([string] $solutionFile) {
#         $devenv = Join-Path $env:DevEnvDir "devenv.exe"
#         if (($solutionFile -eq $null) -or ($solutionFile -eq "")) {
#             $solutionFile = (Get-ChildItem -Filter "*.sln" | Select-Object -First 1).Name
#         }
#         if (($solutionFile -ne $null) -and ($solutionFile -ne "") -and (Test-Path $solutionFile)) {
#             Start-Process $devenv -ArgumentList $solutionFile
#         } else {
#             Start-Process $devenv
#         }
#     }
#     Set-Alias -name vs -Value Start-VisualStudio

#     function Start-VisualStudioAsAdmin ([string] $solutionFile) {
#         $devenv = Join-Path $env:DevEnvDir "devenv.exe"
#         if (($solutionFile -eq $null) -or ($solutionFile -eq "")) {
#             $solutionFile = (Get-ChildItem -Filter "*.sln" | Select-Object -First 1).Name
#         }
#         if (($solutionFile -ne $null) -and ($solutionFile -ne "") -and (Test-Path $solutionFile)) {
#             Start-Process $devenv -ArgumentList $solutionFile -Verb "runAs"
#         } else {
#             Start-Process $devenv -Verb "runAs"
#         }
#     }
#     Set-Alias -name vsadmin -Value Start-VisualStudioAsAdmin

#     function Install-VSExtension($url) {
#         $vsixInstaller = Join-Path $env:DevEnvDir "VSIXInstaller.exe"
#         Write-Output "Downloading ${url}"
#         $extensionFile = (curlex $url)
#         Write-Output "Installing $($extensionFile.Name)"
#         $result = Start-Process -FilePath `"$vsixInstaller`" -ArgumentList "/q $($extensionFile.FullName)" -Wait -PassThru;
#     }
# }

# # SIG # Begin signature block
# # MIIbrAYJKoZIhvcNAQcCoIIbnTCCG5kCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# # gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# # AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUsQ/C6IAz5cKVkGaDdN5CnylI
# # UySgghYbMIIDFDCCAfygAwIBAgIQYZYKU6RDEqJEqEI4Z2ZUMzANBgkqhkiG9w0B
# # AQsFADAiMSAwHgYDVQQDDBdQb3dlclNoZWxsIENvZGUgU2lnbmluZzAeFw0yNTAy
# # MDQxNDA0MTJaFw0yNjAyMDQxNDI0MTJaMCIxIDAeBgNVBAMMF1Bvd2VyU2hlbGwg
# # Q29kZSBTaWduaW5nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA00M6
# # QKAQ9sXjSztBFZpQ0kApJt39Q+OTfRG+chiNsdnaD+8cN782BxD9g0UN7I6d5rIk
# # qokKvYOtz+65+OxU0zDRnIkZqVfVx+NTnc48/nxQdAWcSf8lGbahFmkad0ZTeCfH
# # D+GGbxcQUXdOZWjUxTaGaFavTOkrl8yVdqrm+jHZfQLJFA+x2OG+W6GHqJZeaURd
# # U0dn2iXju5lyFsAq3nbZMrlWsbSEc/dwEGqGhOCTGSuo5GKczUMFqSTTFpJND92x
# # WXknRfE7ha8VVvqXe/QPqbtBheuj1wtQqRDp2gOipDoWw4MaqtQLmvN9/gn1Emx/
# # x6XEt+omJiS1eBkIsQIDAQABo0YwRDAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAww
# # CgYIKwYBBQUHAwMwHQYDVR0OBBYEFNMppiohpRGqatQ9gaxclAn8L/g8MA0GCSqG
# # SIb3DQEBCwUAA4IBAQBNHtqLeIY352sWu29qWIU6KvyFkoi+5NgvzD0/OvbnYJSR
# # 3yZN8KZCTnZ4DFEmK+QHlNg7PNlbGzw9x0+3bJ//Jo8I2ZjaCfVcoBpKAtERpKPO
# # PoL2RxGW+pbS7csm+vxB46ppFv/BfuRH8oxjWsuyMAkfRCnWa7cCXSUKRKKj0lue
# # pvZU8L2rz8CJmQ2JAz7hJ++mQTarEPDBtUVNe8PjtR72jqC1Mg0FeIBCxP3lAyHy
# # EEIm0glV7fawJ2vtm25YjU0JcgsBpYVfhaRfoSIQ4aD/NB4OGb5Kib+0B9TkPC8g
# # b26Rl/j3Y7kRbzAnUy5LL/zJjFjovsxPP7fhMbHUMIIFjTCCBHWgAwIBAgIQDpsY
# # jvnQLefv21DiCEAYWjANBgkqhkiG9w0BAQwFADBlMQswCQYDVQQGEwJVUzEVMBMG
# # A1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSQw
# # IgYDVQQDExtEaWdpQ2VydCBBc3N1cmVkIElEIFJvb3QgQ0EwHhcNMjIwODAxMDAw
# # MDAwWhcNMzExMTA5MjM1OTU5WjBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGln
# # aUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhE
# # aWdpQ2VydCBUcnVzdGVkIFJvb3QgRzQwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAw
# # ggIKAoICAQC/5pBzaN675F1KPDAiMGkz7MKnJS7JIT3yithZwuEppz1Yq3aaza57
# # G4QNxDAf8xukOBbrVsaXbR2rsnnyyhHS5F/WBTxSD1Ifxp4VpX6+n6lXFllVcq9o
# # k3DCsrp1mWpzMpTREEQQLt+C8weE5nQ7bXHiLQwb7iDVySAdYyktzuxeTsiT+CFh
# # mzTrBcZe7FsavOvJz82sNEBfsXpm7nfISKhmV1efVFiODCu3T6cw2Vbuyntd463J
# # T17lNecxy9qTXtyOj4DatpGYQJB5w3jHtrHEtWoYOAMQjdjUN6QuBX2I9YI+EJFw
# # q1WCQTLX2wRzKm6RAXwhTNS8rhsDdV14Ztk6MUSaM0C/CNdaSaTC5qmgZ92kJ7yh
# # Tzm1EVgX9yRcRo9k98FpiHaYdj1ZXUJ2h4mXaXpI8OCiEhtmmnTK3kse5w5jrubU
# # 75KSOp493ADkRSWJtppEGSt+wJS00mFt6zPZxd9LBADMfRyVw4/3IbKyEbe7f/LV
# # jHAsQWCqsWMYRJUadmJ+9oCw++hkpjPRiQfhvbfmQ6QYuKZ3AeEPlAwhHbJUKSWJ
# # bOUOUlFHdL4mrLZBdd56rF+NP8m800ERElvlEFDrMcXKchYiCd98THU/Y+whX8Qg
# # UWtvsauGi0/C1kVfnSD8oR7FwI+isX4KJpn15GkvmB0t9dmpsh3lGwIDAQABo4IB
# # OjCCATYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQU7NfjgtJxXWRM3y5nP+e6
# # mK4cD08wHwYDVR0jBBgwFoAUReuir/SSy4IxLVGLp6chnfNtyA8wDgYDVR0PAQH/
# # BAQDAgGGMHkGCCsGAQUFBwEBBG0wazAkBggrBgEFBQcwAYYYaHR0cDovL29jc3Au
# # ZGlnaWNlcnQuY29tMEMGCCsGAQUFBzAChjdodHRwOi8vY2FjZXJ0cy5kaWdpY2Vy
# # dC5jb20vRGlnaUNlcnRBc3N1cmVkSURSb290Q0EuY3J0MEUGA1UdHwQ+MDwwOqA4
# # oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJv
# # b3RDQS5jcmwwEQYDVR0gBAowCDAGBgRVHSAAMA0GCSqGSIb3DQEBDAUAA4IBAQBw
# # oL9DXFXnOF+go3QbPbYW1/e/Vwe9mqyhhyzshV6pGrsi+IcaaVQi7aSId229GhT0
# # E0p6Ly23OO/0/4C5+KH38nLeJLxSA8hO0Cre+i1Wz/n096wwepqLsl7Uz9FDRJtD
# # IeuWcqFItJnLnU+nBgMTdydE1Od/6Fmo8L8vC6bp8jQ87PcDx4eo0kxAGTVGamlU
# # sLihVo7spNU96LHc/RzY9HdaXFSMb++hUD38dglohJ9vytsgjTVgHAIDyyCwrFig
# # DkBjxZgiwbJZ9VVrzyerbHbObyMt9H5xaiNrIv8SuFQtJ37YOtnwtoeW/VvRXKwY
# # w02fc7cBqZ9Xql4o4rmUMIIGrjCCBJagAwIBAgIQBzY3tyRUfNhHrP0oZipeWzAN
# # BgkqhkiG9w0BAQsFADBiMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQg
# # SW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2Vy
# # dCBUcnVzdGVkIFJvb3QgRzQwHhcNMjIwMzIzMDAwMDAwWhcNMzcwMzIyMjM1OTU5
# # WjBjMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQsIEluYy4xOzA5BgNV
# # BAMTMkRpZ2lDZXJ0IFRydXN0ZWQgRzQgUlNBNDA5NiBTSEEyNTYgVGltZVN0YW1w
# # aW5nIENBMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAxoY1BkmzwT1y
# # SVFVxyUDxPKRN6mXUaHW0oPRnkyibaCwzIP5WvYRoUQVQl+kiPNo+n3znIkLf50f
# # ng8zH1ATCyZzlm34V6gCff1DtITaEfFzsbPuK4CEiiIY3+vaPcQXf6sZKz5C3GeO
# # 6lE98NZW1OcoLevTsbV15x8GZY2UKdPZ7Gnf2ZCHRgB720RBidx8ald68Dd5n12s
# # y+iEZLRS8nZH92GDGd1ftFQLIWhuNyG7QKxfst5Kfc71ORJn7w6lY2zkpsUdzTYN
# # XNXmG6jBZHRAp8ByxbpOH7G1WE15/tePc5OsLDnipUjW8LAxE6lXKZYnLvWHpo9O
# # dhVVJnCYJn+gGkcgQ+NDY4B7dW4nJZCYOjgRs/b2nuY7W+yB3iIU2YIqx5K/oN7j
# # PqJz+ucfWmyU8lKVEStYdEAoq3NDzt9KoRxrOMUp88qqlnNCaJ+2RrOdOqPVA+C/
# # 8KI8ykLcGEh/FDTP0kyr75s9/g64ZCr6dSgkQe1CvwWcZklSUPRR8zZJTYsg0ixX
# # NXkrqPNFYLwjjVj33GHek/45wPmyMKVM1+mYSlg+0wOI/rOP015LdhJRk8mMDDtb
# # iiKowSYI+RQQEgN9XyO7ZONj4KbhPvbCdLI/Hgl27KtdRnXiYKNYCQEoAA6EVO7O
# # 6V3IXjASvUaetdN2udIOa5kM0jO0zbECAwEAAaOCAV0wggFZMBIGA1UdEwEB/wQI
# # MAYBAf8CAQAwHQYDVR0OBBYEFLoW2W1NhS9zKXaaL3WMaiCPnshvMB8GA1UdIwQY
# # MBaAFOzX44LScV1kTN8uZz/nupiuHA9PMA4GA1UdDwEB/wQEAwIBhjATBgNVHSUE
# # DDAKBggrBgEFBQcDCDB3BggrBgEFBQcBAQRrMGkwJAYIKwYBBQUHMAGGGGh0dHA6
# # Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBBBggrBgEFBQcwAoY1aHR0cDovL2NhY2VydHMu
# # ZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZFJvb3RHNC5jcnQwQwYDVR0fBDww
# # OjA4oDagNIYyaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3Rl
# # ZFJvb3RHNC5jcmwwIAYDVR0gBBkwFzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMA0G
# # CSqGSIb3DQEBCwUAA4ICAQB9WY7Ak7ZvmKlEIgF+ZtbYIULhsBguEE0TzzBTzr8Y
# # +8dQXeJLKftwig2qKWn8acHPHQfpPmDI2AvlXFvXbYf6hCAlNDFnzbYSlm/EUExi
# # HQwIgqgWvalWzxVzjQEiJc6VaT9Hd/tydBTX/6tPiix6q4XNQ1/tYLaqT5Fmniye
# # 4Iqs5f2MvGQmh2ySvZ180HAKfO+ovHVPulr3qRCyXen/KFSJ8NWKcXZl2szwcqMj
# # +sAngkSumScbqyQeJsG33irr9p6xeZmBo1aGqwpFyd/EjaDnmPv7pp1yr8THwcFq
# # cdnGE4AJxLafzYeHJLtPo0m5d2aR8XKc6UsCUqc3fpNTrDsdCEkPlM05et3/JWOZ
# # Jyw9P2un8WbDQc1PtkCbISFA0LcTJM3cHXg65J6t5TRxktcma+Q4c6umAU+9Pzt4
# # rUyt+8SVe+0KXzM5h0F4ejjpnOHdI/0dKNPH+ejxmF/7K9h+8kaddSweJywm228V
# # ex4Ziza4k9Tm8heZWcpw8De/mADfIBZPJ/tgZxahZrrdVcA6KYawmKAr7ZVBtzrV
# # FZgxtGIJDwq9gdkT/r+k0fNX2bwE+oLeMt8EifAAzV3C+dAjfwAL5HYCJtnwZXZC
# # pimHCUcr5n8apIUP/JiW9lVUKx+A+sDyDivl1vupL0QVSucTDh3bNzgaoSv27dZ8
# # /DCCBrwwggSkoAMCAQICEAuuZrxaun+Vh8b56QTjMwQwDQYJKoZIhvcNAQELBQAw
# # YzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQD
# # EzJEaWdpQ2VydCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFtcGlu
# # ZyBDQTAeFw0yNDA5MjYwMDAwMDBaFw0zNTExMjUyMzU5NTlaMEIxCzAJBgNVBAYT
# # AlVTMREwDwYDVQQKEwhEaWdpQ2VydDEgMB4GA1UEAxMXRGlnaUNlcnQgVGltZXN0
# # YW1wIDIwMjQwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC+anOf9pUh
# # q5Ywultt5lmjtej9kR8YxIg7apnjpcH9CjAgQxK+CMR0Rne/i+utMeV5bUlYYSuu
# # M4vQngvQepVHVzNLO9RDnEXvPghCaft0djvKKO+hDu6ObS7rJcXa/UKvNminKQPT
# # v/1+kBPgHGlP28mgmoCw/xi6FG9+Un1h4eN6zh926SxMe6We2r1Z6VFZj75MU/HN
# # mtsgtFjKfITLutLWUdAoWle+jYZ49+wxGE1/UXjWfISDmHuI5e/6+NfQrxGFSKx+
# # rDdNMsePW6FLrphfYtk/FLihp/feun0eV+pIF496OVh4R1TvjQYpAztJpVIfdNsE
# # vxHofBf1BWkadc+Up0Th8EifkEEWdX4rA/FE1Q0rqViTbLVZIqi6viEk3RIySho1
# # XyHLIAOJfXG5PEppc3XYeBH7xa6VTZ3rOHNeiYnY+V4j1XbJ+Z9dI8ZhqcaDHOoj
# # 5KGg4YuiYx3eYm33aebsyF6eD9MF5IDbPgjvwmnAalNEeJPvIeoGJXaeBQjIK13S
# # lnzODdLtuThALhGtyconcVuPI8AaiCaiJnfdzUcb3dWnqUnjXkRFwLtsVAxFvGqs
# # xUA2Jq/WTjbnNjIUzIs3ITVC6VBKAOlb2u29Vwgfta8b2ypi6n2PzP0nVepsFk8n
# # lcuWfyZLzBaZ0MucEdeBiXL+nUOGhCjl+QIDAQABo4IBizCCAYcwDgYDVR0PAQH/
# # BAQDAgeAMAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwIAYD
# # VR0gBBkwFzAIBgZngQwBBAIwCwYJYIZIAYb9bAcBMB8GA1UdIwQYMBaAFLoW2W1N
# # hS9zKXaaL3WMaiCPnshvMB0GA1UdDgQWBBSfVywDdw4oFZBmpWNe7k+SH3agWzBa
# # BgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vRGlnaUNl
# # cnRUcnVzdGVkRzRSU0E0MDk2U0hBMjU2VGltZVN0YW1waW5nQ0EuY3JsMIGQBggr
# # BgEFBQcBAQSBgzCBgDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQu
# # Y29tMFgGCCsGAQUFBzAChkxodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGln
# # aUNlcnRUcnVzdGVkRzRSU0E0MDk2U0hBMjU2VGltZVN0YW1waW5nQ0EuY3J0MA0G
# # CSqGSIb3DQEBCwUAA4ICAQA9rR4fdplb4ziEEkfZQ5H2EdubTggd0ShPz9Pce4FL
# # Jl6reNKLkZd5Y/vEIqFWKt4oKcKz7wZmXa5VgW9B76k9NJxUl4JlKwyjUkKhk3aY
# # x7D8vi2mpU1tKlY71AYXB8wTLrQeh83pXnWwwsxc1Mt+FWqz57yFq6laICtKjPIC
# # YYf/qgxACHTvypGHrC8k1TqCeHk6u4I/VBQC9VK7iSpU5wlWjNlHlFFv/M93748Y
# # TeoXU/fFa9hWJQkuzG2+B7+bMDvmgF8VlJt1qQcl7YFUMYgZU1WM6nyw23vT6QSg
# # wX5Pq2m0xQ2V6FJHu8z4LXe/371k5QrN9FQBhLLISZi2yemW0P8ZZfx4zvSWzVXp
# # Ab9k4Hpvpi6bUe8iK6WonUSV6yPlMwerwJZP/Gtbu3CKldMnn+LmmRTkTXpFIEB0
# # 6nXZrDwhCGED+8RsWQSIXZpuG4WLFQOhtloDRWGoCwwc6ZpPddOFkM2LlTbMcqFS
# # zm4cd0boGhBq7vkqI1uHRz6Fq1IX7TaRQuR+0BGOzISkcqwXu7nMpFu3mgrlgbAW
# # +BzikRVQ3K2YHcGkiKjA4gi4OA/kz1YCsdhIBHXqBzR0/Zd2QwQ/l4Gxftt/8wY3
# # grcc/nS//TVkej9nmUYu83BDtccHHXKibMs/yXHhDXNkoPIdynhVAku7aRZOwqw6
# # pDGCBPswggT3AgEBMDYwIjEgMB4GA1UEAwwXUG93ZXJTaGVsbCBDb2RlIFNpZ25p
# # bmcCEGGWClOkQxKiRKhCOGdmVDMwCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwx
# # CjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGC
# # NwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFLRiJjojMjrkHkxY
# # 7tWsqHpppIe6MA0GCSqGSIb3DQEBAQUABIIBAJffiFsNtJqKKOSYGDXetBtWmGmQ
# # w8lNGq8/g6e3kGDY7t9NOT7fY16tlIX3Tt54gmV4CWkmK4iboxpMJILMgwxEI0O9
# # Os2KuZgdmXogfzgqrAGPnLNIuHeTVrHb5XJCqlGUqeWkK3VLzWImC4R5O3Nh+Fx2
# # ScknFOv3uafVL7hBk3bkK3+3hAtPf+1lZjfet/lwFS0A44Nl4IwnY+DhF//ZliEx
# # lzix+p79M6S8XSUcaBGPTT6jmt4kcyuTa6CisAzb61prUaKd97N604+Ko+sp2fzw
# # KpoywhNjK5rw9u5qML8eTLu7h8JLdk4GRyvJXWMZQTgBQogvtED8Y8ywufmhggMg
# # MIIDHAYJKoZIhvcNAQkGMYIDDTCCAwkCAQEwdzBjMQswCQYDVQQGEwJVUzEXMBUG
# # A1UEChMORGlnaUNlcnQsIEluYy4xOzA5BgNVBAMTMkRpZ2lDZXJ0IFRydXN0ZWQg
# # RzQgUlNBNDA5NiBTSEEyNTYgVGltZVN0YW1waW5nIENBAhALrma8Wrp/lYfG+ekE
# # 4zMEMA0GCWCGSAFlAwQCAQUAoGkwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAc
# # BgkqhkiG9w0BCQUxDxcNMjUwMjA0MTQxNDE3WjAvBgkqhkiG9w0BCQQxIgQgRIlE
# # emDjBgORuAeacVMbv40FC6vtiypHlYiJabUTeIswDQYJKoZIhvcNAQEBBQAEggIA
# # kdhaTrbINWUH2kub0w2vfkPFckAaPdqKOIEWHtYEByA7Ytqe9ouDcYKno2B4HdP4
# # ZRW5rqzn4+frlBnveMTzsmEVj5uubqIMMriLMvBHnKkh0oAmbbl6i4MLYVVCLPeE
# # RWdGwI2+AC3kSj27+iGjk0Dql2peit23Nqg3Uw/WCJAOZReHnwGuwLTQSQlAhEAi
# # TczJiypx7C3CvMMb4dG7rrnIF5Z8kG6DaDh+uazPOYOUkn1W4rVAvcs88IDpRHd6
# # xA/doa3d1WyrkZRd7N/O/z6OqmOZ+2G4lWZzAcntC18OpgErXcFbYasY58j0Vpsr
# # Q8Grslo9wC/sAiU8bwNeTQTyeNPHzZzwYY+JjwoWNJKIv8Mb210ohknBYDhAr7kj
# # 2DA5BmwcnjV+1/clP2Ah/faX7TP5M7HjWcqxQEQRWuWu1F56W/K8TJHjwP6rT4x6
# # dTUCm1J8JlMY5n9Fc/7pg9LyFG178Bzgdia/kqhnoOgMnhsz86QN2U5kV+MGYT7p
# # R4/nVVBmi5DCRmc/OCSxcbBSESjBr6yI2sMcvuPj0mtOsRYs2kuRC0aN8NLHJEtK
# # AyawVlsAfr14PJyg5A6DbyLQ6kRGH+vAeJtfJ5q9+hg1OHU3MvXfbC6JUwpX9uPn
# # ZbZJBEe30xVmDUQpUUWsyx7ampX0amZRKgwZmK7vVdg=
# # SIG # End signature block
