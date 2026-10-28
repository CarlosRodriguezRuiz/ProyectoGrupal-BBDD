# Carga de los CSV con pandas + SQLAlchemy (investigación del equipo de Data Science).
# Transcrito del notebook original (ver docs/capturas/pandas_*.jpg), con rutas relativas al repo.
# Prueba de concepto: carga solo la tabla alumnos en un SQLite local (bootcamp.db).
# Para cargarlo en Supabase bastaría cambiar la URL de create_engine por la de PostgreSQL.
# %%
from pathlib import Path

import pandas as pd
from sqlalchemy import Column, Integer, MetaData, String, Table, Text, create_engine, inspect, text

DATA = Path(__file__).resolve().parent.parent / "data"

# %%
# VISUALIZACIÓN Y SELECCIÓN DE DATOS (nombre, email) DE LOS 4 FICHEROS DE CLASE
alumnos_por_clase = []
for i in range(1, 5):
    clase = pd.read_csv(DATA / f"clase_{i}.csv", sep=";")
    print(clase.head())
    alumnos_por_clase.append(clase.iloc[:, 0:2])
    print("---------- \n")

# %%
# UNIFICACIÓN DE LOS 4 DF DE ALUMNO (nombre y email)
alumnos_total = pd.concat(alumnos_por_clase, ignore_index=True)
alumnos_total.columns = ["nombre", "email"]
print(alumnos_total.shape)
print(alumnos_total.duplicated().sum())

# %%
# CONEXIÓN ENTRE PANDAS Y SQL
engine = create_engine("sqlite:///bootcamp.db")
with engine.connect() as conexion:
    print("Conexión establecida correctamente")

# %%
# CREAR LA TABLA alumnos (misma estructura que en el modelo lógico)
metadata = MetaData()
alumnos = Table("alumnos", metadata,
                Column("id", Integer, primary_key=True),
                Column("nombre", String(20)), Column("email", Text))
metadata.create_all(engine)
inspector = inspect(engine)
print(inspector.get_table_names())
print(inspector.get_columns("alumnos"))

# %%
# INSERTAR LOS DATOS EN LA TABLA alumnos
alumnos_total.to_sql(name="alumnos", con=engine, if_exists="append", index=False)

# %%
# COMPROBAR QUE FUNCIONA
def query(consulta):
    with engine.connect() as conexion:
        return conexion.execute(text(consulta)).fetchall()

print(query("SELECT COUNT(*) FROM alumnos"))
print(query("SELECT * FROM alumnos LIMIT 5"))
