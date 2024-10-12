import pandas as pd
from sqlalchemy import create_engine

df = pd.read_excel('music.xlsx')

username = 'postgres'
password = '132456gfd'
host = 'localhost'
port = '5432'
database = 'postgres'
engine = create_engine(f'postgresql://{username}:{password}@{host}:{port}/{database}')

# Импорт данных в таблицу
df.to_sql('table1', engine, if_exists='replace', index=False)

print("Данные успешно загружены!")
