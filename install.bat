@echo off
:: ============================================================
:: install.bat – Instala dependências do RelAcessoNew
:: Execute como Administrador uma vez antes de publicar no IIS
:: ============================================================
echo.
echo  ====================================================
echo   RelAcessoNew - ReportsWeb  -  Instalação de Dependências
echo  ====================================================
echo.

:: Cria pastas necessárias
if not exist "instance" mkdir instance
if not exist "logs"     mkdir logs

:: Instala pacotes Python
echo [1/2] Instalando dependências Python...
python -m pip install --upgrade pip
python -m pip install -r requirements.txt

echo.
echo [2/2] Inicializando banco de dados local (SQLite)...
python -c "from database import init_db; init_db(); print('Banco inicializado com sucesso!')"

echo.
echo  ====================================================
echo   Instalação concluída!
echo   
echo   Usuário padrão: admin  /  Senha: admin123
echo   (Altere a senha após o primeiro login!)
echo  ====================================================
echo.
pause
