@echo off
echo.
echo ===========================================================================
echo Compiling graphics
echo ===========================================================================
..\..\php5\php.exe -c ..\..\php5\ -f convert_spr.php
..\..\php5\php.exe -c ..\..\php5\ -f convert_font.php
if %ERRORLEVEL% NEQ 0 ( exit /b )

echo.
echo ===========================================================================
echo Compiling PPU.MAC
echo ===========================================================================
..\..\php5\php.exe -c ..\..\php5\ -f preprocess.php ppu.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\..\macro11\macro11.exe -ysl 32 -yus -m ..\..\macro11\sysmac.sml -l _ppu.lst _ppu.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )

echo.
echo ===========================================================================
echo Creating PPU data block
echo ===========================================================================
..\..\php5\php.exe -c ..\..\php5\ -f lst2bin.php _ppu.lst inc_cpu_ppu.mac mac
if %ERRORLEVEL% NEQ 0 ( exit /b )

echo.
echo ===========================================================================
echo Compiling CPU.MAC
echo ===========================================================================
..\..\php5\php.exe -c ..\..\php5\ -f preprocess.php cpu.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\..\macro11\macro11.exe -ysl 32 -yus -m ..\..\macro11\sysmac.sml -l _cpu.lst _cpu.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )

echo.
echo ===========================================================================
echo Linking and cleanup
echo ===========================================================================
..\..\php5\php.exe -c ..\..\php5\ -f lst2bin.php _cpu.lst ./release/bolde2.sav sav
..\..\macro11\rt11dsk.exe d bolder.dsk .\release\bolde2.sav >NUL
..\..\macro11\rt11dsk.exe a bolder.dsk .\release\bolde2.sav >NUL

echo.