; SETUP MDPLC CATALOG

#include "VersionFile.txt"

[Setup]
AppName=GF_eXpress {#DriveVerAppVer}
AppVerName=Gefran {#DriveVerAppVer}
AppPublisher=Gefran spa
AppPublisherURL=http://www.gefran.com
AppSupportURL=http://www.gefran.com
AppUpdatesURL=http://www.gefran.com
DefaultDirName={pf}\Gefran
DefaultGroupName=Gefran
OutputBaseFilename=Setup
Compression=lzma
SolidCompression=yes
UninstallDisplayIcon={app}\GF_eXpress\GF_eXpress.exe
;da versione Inno Setup Compiler 5.5.9 non viene proposto il percorso di installazione, se già installato -> il flag va settato a "no"
DisableDirPage=no
DisableWelcomePage=no
DirExistsWarning=yes

[Languages]
Name: english; MessagesFile: compiler:Default.isl

[Tasks]

[Files]
; tutti i files sotto "Gefran"
Source: Catalog\Drives\Inverter\ADV200\{#DriveVer}\*; Excludes: "*.osc"; DestDir: {app}\Catalog\Drives\Inverter\ADV200\{#DriveVer}; Flags: ignoreversion recursesubdirs createallsubdirs overwritereadonly
Source: Catalog\Custom\Gft\*;                                            DestDir: {app}\Catalog\Custom\Gft; Flags: ignoreversion recursesubdirs createallsubdirs overwritereadonly

[InstallDelete]
; rimozione cache catalogo
Name: {app}\Catalog\GFCatalog.xml; Type: files
Name: {code:GetVirtualPath|{app}\Catalog\GFCatalog.xml}; Type: files

[UninstallDelete]
; rimozione cache catalogo
Name: {app}\Catalog\GFCatalog.xml; Type: files
Name: {code:GetVirtualPath|{app}\Catalog\GFCatalog.xml}; Type: files

[Code]
function GetVirtualPath(path: String): String;
begin
	Delete(path, 1, 2);
	Result := ExpandConstant('{userappdata}') + '\..\Local\VirtualStore' + path;
end;
