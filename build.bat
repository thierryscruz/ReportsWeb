@echo off
echo ==============================================
echo Compilando RelAcessoNew com PyInstaller
echo ==============================================

if not exist venv (
    echo [Erro] Ambiente virtual 'venv' nao encontrado. Rode install.bat primeiro.
    
    exit /b
)

call venv\Scripts\activate
echo Instalando PyInstaller...
pip install pyinstaller

echo Compilando o executavel...
pyinstaller --name="RelAcessoApp" --noconfirm --clean --add-data "templates;templates" --add-data "static;static" run_waitress.py

echo.
echo ==============================================
echo Criando pastas logs e instance no dist...
if not exist dist\RelAcessoApp\logs mkdir dist\RelAcessoApp\logs
if not exist dist\RelAcessoApp\instance mkdir dist\RelAcessoApp\instance
echo. > dist\RelAcessoApp\logs\.gitkeep
echo. > dist\RelAcessoApp\instance\.gitkeep

echo Compilacao Concluida!
echo O executavel esta na pasta 'dist\RelAcessoApp'
echo ==============================================
