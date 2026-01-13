@echo off
setlocal

if "%~1"=="" (
    echo Kaytto: timer.bat "komento tähän"
    exit /b 1
)

:: Tallennetaan aloitusaika
set "start_time=%time: =0%"

:: Suoritetaan varsinainen komento
echo [TIMER] Suoritetaan: %*
echo ---------------------------------------
call %* > nul
echo ---------------------------------------

:: Tallennetaan lopetusaika
set "end_time=%time: =0%"

:: Puretaan ajat osiin (HH:MM:SS,CC)
set "start_h=%start_time:~0,2%"
set "start_m=%start_time:~3,2%"
set "start_s=%start_time:~6,2%"
set "start_c=%start_time:~9,2%"

set "end_h=%end_time:~0,2%"
set "end_m=%end_time:~3,2%"
set "end_s=%end_time:~6,2%"
set "end_c=%end_time:~9,2%"

:: Muunnetaan kaikki sadasosasekunneiksi laskentaa varten
set /a "start_total=(10000%start_h% %% 100 * 360000) + (10000%start_m% %% 100 * 6000) + (10000%start_s% %% 100 * 100) + (10000%start_c% %% 100)"
set /a "end_total=(10000%end_h% %% 100 * 360000) + (10000%end_m% %% 100 * 6000) + (10000%end_s% %% 100 * 100) + (10000%end_c% %% 100)"

:: Lasketaan erotus
set /a "diff=end_total - start_total"

:: Jos vuorokausi vaihtui välissä
if %diff% lss 0 set /a "diff+=8640000"

:: Muotoillaan tulos takaisin luettavaan muotoon
set /a "final_s=diff / 100"
set /a "final_c=diff %% 100"

echo [TIMER] Valmis!
echo [TIMER] Suoritusaika: %final_s%,%final_c% sekuntia.
endlocal
