library(DBI)
library(RPostgres)

conn <- dbConnect(
  RPostgres::Postgres(),
  host = "staging",
  port = 5432,
  dbname = "datawarehouse",
  user = "root",
  password = "root"
)

compras <- dbGetQuery(conn, 
  "
  SELECT fecha_compra, costo_unitario
  FROM staging.excel_compras
  WHERE nombre_insumo = 'Lomo de Res Premium'
  "
)

head(compras)

compras$fecha_compra = as.Date(compras$fecha_compra)

plot(
  compras$fecha_compra,
  compras$costo_unitario
)

compras$tiempo = as.numeric( compras$fecha_compra - min( compras$fecha_compra ))

head(compras)

orden <- order(compras$tiempo)

regresion <- lm(
  costo_unitario ~ tiempo,
  data = compras
)

lines(
  compras$fecha_compra[orden],
  predict(regresion)[orden]
)

summary(compras)
summary(regresion)

dbDisconnect(conn)