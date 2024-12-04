@echo off
echo.
echo ===========================================================================
echo Compiling graphics
echo ===========================================================================
php -f convert_spr.php
php -f convert_font.php
if %ERRORLEVEL% NEQ 0 ( exit /b )

echo.
echo ===========================================================================
echo Compiling PPU.MAC
echo ===========================================================================
php -f ../scripts/preprocess.php ppu.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\macro11 -ysl 32 -yus -m ..\scripts\sysmac.sml -l _ppu.lst _ppu.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )

echo.
echo ===========================================================================
echo Creating PPU data block
echo ===========================================================================
php -f ../scripts/lst2bin.php _ppu.lst inc_cpu_ppu.mac mac
if %ERRORLEVEL% NEQ 0 ( exit /b )

echo.
echo ===========================================================================
echo Compiling CPU.MAC
echo ===========================================================================
php -f ../scripts/preprocess.php cpu.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )
..\scripts\macro11 -ysl 32 -yus -m ..\scripts\sysmac.sml -l _cpu.lst _cpu.mac
if %ERRORLEVEL% NEQ 0 ( exit /b )

echo.
echo ===========================================================================
echo Linking and cleanup
echo ===========================================================================
php -f ../scripts/lst2bin.php _cpu.lst ./release/bolde2.sav sav
if %ERRORLEVEL% NEQ 0 ( exit /b )

..\scripts\rt11dsk d .\release\bolde2.dsk bolde2.sav >NUL
..\scripts\rt11dsk a .\release\bolde2.dsk .\release\bolde2.sav >NUL

..\scripts\rt11dsk d ..\..\03_dsk\hdd.dsk bolde2.sav >NUL
..\scripts\rt11dsk a ..\..\03_dsk\hdd.dsk .\release\bolde2.sav >NUL

del _cpu.lst
del _cpu.mac
del _ppu.lst
del _ppu.mac

@2_run_ukncbtl.bat

echo.