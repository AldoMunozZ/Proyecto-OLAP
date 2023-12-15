/*Consulta 1*/


Select t.anio_id as anio, v.nombre_v as nombre_vendedor , v.app_v as Apellido_Paterno, apm_v as Apellido_Materno,SUM(h.costo) as Ventas_Totales
From hechos_ventas as h
Join tiempo as t ON h.tiempo_id=t.tiempo_id
Join vendedor as v ON h.vendedor_id=v.vendedor_id
Where t.anio_id=2023
Group by anio, nombre_vendedor, Apellido_Paterno, Apellido_Materno
Having Sum(h.costo)=( Select Max(subq2.Ventas_Totales)
                      From (Select v.vendedor_id, t.anio_id , SUM(h.costo) as Ventas_Totales
                            From hechos_ventas as h
                            Join tiempo as t ON h.tiempo_id=t.tiempo_id
                            Join vendedor as v ON h.vendedor_id=v.vendedor_id
                            Where t.anio_id=2023
                            Group by v.vendedor_id, t.anio_id
                            )subq2
);

/*Consulta 1.1*/

Select t.anio_id as Anio, t.mes_id as mes, v.nombre_v as nombre_vendedor, v.app_v as Apellido_Paterno, v.apm_v as Apellido_Materno, SUM(h.costo) as Venta_Por_Mes

From hechos_ventas as h

Join tiempo as t ON h.tiempo_id=t.tiempo_id
Join vendedor as v ON h.vendedor_id=v.vendedor_id

Where t.anio_id =2023

AND v.vendedor_id=(Select sub3.vendedor_id
From( Select v.vendedor_id, t.anio_id, SUM(h.costo) as Ventas_Totales

From hechos_ventas as h
Join tiempo as t ON h.tiempo_id=t.tiempo_id
Join vendedor as v ON h.vendedor_id=v.vendedor_id
Where t.anio_id=2023
Group by v.vendedor_id, t.anio_id
Having Sum(h.costo)=( Select Max(subq2.Ventas_Totales)
                      From (Select v.vendedor_id, t.anio_id ,SUM(h.costo) as Ventas_Totales
                            From hechos_ventas as h
                            Join tiempo as t ON h.tiempo_id=t.tiempo_id
                            Join vendedor as v ON h.vendedor_id=v.vendedor_id
                            Where t.anio_id=2023
                            Group by v.vendedor_id, t.anio_id
                            )subq2
))sub3
)
Group by anio, mes, nombre_vendedor, Apellido_Paterno, Apellido_Materno;

/*Consulta 2*/

Select t.anio_id as anio, t.mes_id as mes, Sum(h.cantidad) as unidades_vendidas
From hechos_ventas as h
Join tiempo as t ON h.tiempo_id=t.tiempo_id
Group by  anio, mes
Having Sum(h.cantidad) = ( Select MIN(subq1.unidades_vendidas)
                          From (Select t.anio_id, t.mes_id, Sum(h.cantidad) as unidades_vendidas
                                From hechos_ventas as h
                                Join tiempo as t ON h.tiempo_id=t.tiempo_id
                                Group by  t.anio_id, t.mes_id
                          )subq1
                          WHERE subq1.anio_id = t.anio_id
);

/*Consulta 3*/

Select t.anio_id, SUM((hd.precio_compra*h.cantidad)-h.costo) as ganancia_total
From hechos_ventas as h
Join HECHOS_DOLAR as hd ON h.tiempo_id=hd.tiempo_id
Join tiempo as t ON h.tiempo_id=t.tiempo_id
Where t.anio_id=2022
Group by t.anio_id;

/*Consulta 4*/

Select cli.nombre_c as nombre_cliente, cli.app_c as Apellido_Paterno, cli.apm_c as Apellido_Materno, SUM((hd.precio_compra*h.cantidad)-h.costo) as ganancia
From hechos_ventas as h
Join cliente as cli ON h.cliente_id =cli.cliente_id
Join HECHOS_DOLAR as hd ON h.tiempo_id=hd.tiempo_id
Group by nombre_cliente, Apellido_Paterno, Apellido_Materno
Having SUM((hd.precio_compra*h.cantidad)-h.costo) = (Select MAX (subq1.ganancia)
                                                      From(Select cli.cliente_id, SUM((hd.precio_compra*h.cantidad)-h.costo) as ganancia
                                                           From hechos_ventas as h
                                                           Join cliente as cli ON h.cliente_id =cli.cliente_id
                                                           Join HECHOS_DOLAR as hd ON h.tiempo_id=hd.tiempo_id
                                                           Group by cli.cliente_id
                                                      )subq1
);


/*Consulta 5*/

Select cli.nombre_c as nombre_cliente, cli.app_c as Apellido_Paterno, cli.apm_c as Apellido_Materno, SUM(h.cantidad) as Unidades_Compradas
From hechos_ventas as h
Join cliente as cli ON h.cliente_id =cli.cliente_id
Group by nombre_cliente, Apellido_Paterno, Apellido_Materno 
Having SUM(h.cantidad)=( Select MAX(subq1.Unidades_Compradas)
                         From ( Select cli.cliente_id, SUM(h.cantidad) as Unidades_Compradas
                                From hechos_ventas as h
                                Join cliente as cli ON h.cliente_id =cli.cliente_id
                                 Group by cli.cliente_id 
                         )subq1
);



/*Consulta 6*/

Select t.anio_id as anio , t.mes_id as mes , SUM(((h.cantidad* hd.precio_compra)-h.costo)) as ganancia
From hechos_ventas as h
Join tiempo as t ON h.tiempo_id=t.tiempo_id
Join HECHOS_DOLAR as hd ON h.tiempo_id=hd.tiempo_id
Where t.anio_id=2022
Group by anio, mes
Having SUM(((h.cantidad* hd.precio_compra)-h.costo)) =( Select MAX (subq1.ganancia)
                    From (Select t.anio_id, t.mes_id, SUM(((h.cantidad* hd.precio_compra)-h.costo)) as ganancia
                          From hechos_ventas as h
                          Join tiempo as t ON h.tiempo_id=t.tiempo_id
                          Join HECHOS_DOLAR as hd ON h.tiempo_id=hd.tiempo_id
                          Where t.anio_id=2022
                          Group by t.anio_id, t.mes_id
                        )subq1
);

/*Consulta 7*/

Select pr.promocion_id, pr.promocion_desc, SUM(h.cantidad) as cantidad_vendida
From hechos_ventas as h
Join promocion as pr ON h.promocion_id= pr.promocion_id
Group by pr.promocion_id, pr.promocion_desc
Having SUM(h.cantidad) = ( Select MAX (subq1.cantidad_vendida)
                           From(Select pr.promocion_desc, SUM(h.cantidad) as cantidad_vendida
                                From hechos_ventas as h
                                Join promocion as pr ON h.promocion_id= pr.promocion_id
                                 Group by pr.promocion_desc
                           )subq1
);


