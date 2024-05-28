import pyodbc

# Get a list of all available drivers
drivers = [driver for driver in pyodbc.drivers()]

# Print all drivers
for driver in drivers:
    print(driver)

cnxn = pyodbc.connect("Driver={ODBC Driver 17 for SQL Server};Server=tcp:vsksqlserver5.database.windows.net,1433;Database=vskSqlDatabase5;Uid=8c38f2ec-aa86-49f0-94df-2fb5c9e81d66;Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;Authentication=ActiveDirectoryIntegrated")
# cnxn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};'
#                       'SERVER=your_server;'
#                       'DATABASE=your_database;'
#                       'Trusted_Connection=yes')
cursor = cnxn.cursor()