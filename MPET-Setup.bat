@echo off
title Installation de Menu Pratique — Édition Tranchent
color 1F

echo ==================================================
echo  Menu Pratique — Edition Tranchent - INSTALLATEUR
echo ==================================================
echo.
echo Ce programme va :
echo - Vérifier si Python est installé
echo - Télécharger le projet depuis GitHub
echo - Installer les dépendances
echo - Créer le dossier screenshots
echo - Lancer Menu Pratique
echo --------------------------------------------------
echo.

REM === Variables ===
set "ZIP_URL=https://github.com/tranchentoff/MPET/archive/refs/heads/main.zip"
set "INSTALL_DIR=%cd%\Menu-Pratique"
set "ZIP_FILE=%TEMP%\MPET-main.zip"

REM === Crée le dossier d'installation ===
mkdir "%INSTALL_DIR%"

REM === Vérifie si Python est installé ===
echo [1/5] Vérification de Python...
python --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Python n'est pas installé. Téléchargement de Python...
    powershell -Command "Start-Process 'https://www.python.org/ftp/python/3.10.0/python-3.10.0-amd64.exe' -Wait"
    echo Veuillez relancer ce script une fois Python installé.
    pause
    exit /b
) else (
    echo Python est déjà installé.
)

REM === Télécharge le ZIP ===
echo [2/5] Téléchargement du projet...
powershell -Command "Invoke-WebRequest -Uri '%ZIP_URL%' -OutFile '%ZIP_FILE%'"

REM === Extrait le ZIP ===
echo [3/5] Extraction du projet...
powershell -Command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%INSTALL_DIR%' -Force"

REM === Copie le contenu du dossier extrait ===
echo [4/5] Copie des fichiers du projet...
xcopy "%INSTALL_DIR%\MPET-main\*" "%INSTALL_DIR%\" /E /H /C /I
rmdir /S /Q "%INSTALL_DIR%\MPET-main"
del "%ZIP_FILE%"

REM === Crée le dossier screenshots (s'il n'existe pas) ===
if not exist "%INSTALL_DIR%\screenshots" mkdir "%INSTALL_DIR%\screenshots"

REM === Installe les dépendances ===
echo [5/5] Installation des dépendances Python...
cd /d "%INSTALL_DIR%"
python -m pip install --upgrade pip
python -m pip install -r requirements.txt

echo --------------------------------------------------
echo Installation terminée ✅
echo Le programme va maintenant démarrer...
echo.

REM === Lance le programme ===
python Menu.py

echo.
echo Vous pouvez relancer Menu Pratique depuis :
echo %INSTALL_DIR%\Menu.py
pause
