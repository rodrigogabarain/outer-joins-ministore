# MiniStore — Auditoría de Inventario y Ventas con Outer JOINs

Este repositorio contiene la solución a la práctica de auditoría de calidad de datos para MiniStore, desarrollada para identificar inconsistencias entre el catálogo de productos y el historial transaccional de ventas utilizando uniones externas (LEFT JOIN, RIGHT JOIN y FULL OUTER JOIN).

---

## Estructura del Repositorio

outer-joins-ministore/
├── schema.sql
├── soluciones.sql
└── README.md

---

## Preguntas de Documentación Técnica

### 1. ¿Por qué usaste LEFT JOIN para la Consulta 1 y no INNER JOIN? ¿Qué se perdería si usaras INNER JOIN?
Se utilizó LEFT JOIN posicionando la tabla productos a la izquierda (FROM productos p LEFT JOIN ventas v) porque el requerimiento de negocio exigía evaluar la totalidad del catálogo de productos, independientemente de si registraban o no transacciones de venta.

Si hubiésemos utilizado un INNER JOIN, la consulta habría devuelto únicamente las filas con coincidencia exacta en ambas tablas. Esto habría provocado la pérdida de los productos que nunca tuvieron ventas:
* Producto 108: Hub USB-C 7p
* Producto 109: Parlante Bluetooth

Gracias a LEFT JOIN en combinación con el filtro WHERE v.venta_id IS NULL, logramos conservar la tabla de productos intacta e aislar con precisión los artículos inactivos o sin rotación de stock.

---

### 2. ¿Por qué usaste RIGHT JOIN para la Consulta 2? ¿Qué tabla está a la izquierda y cuál a la derecha en tu consulta?
En la Consulta 2 (FROM productos p RIGHT JOIN ventas v), la tabla a la izquierda es productos y la tabla a la derecha es ventas.

Se utilizó RIGHT JOIN porque el objetivo de auditoría era garantizar que ningún registro de la tabla transaccional (ventas) quedara excluido, permitiendo verificar la existencia de transacciones huérfanas o con errores de carga de datos. Al aplicar el filtro WHERE p.producto_id IS NULL, detectamos la venta venta_id = 10, la cual fue registrada el 2024-03-25 con un producto_id = 999 que no existe en la tabla de productos, evidenciando una falla de integridad referencial.

---

### 3. ¿Qué representan los valores NULL en cada resultado?
En el contexto de las uniones externas en SQL, los valores NULL no constituyen un error de ejecución, sino el indicador técnico explícito que confirma la falta de coincidencia entre dos entidades:

* Consulta 1 (v.venta_id IS NULL): Indica que el producto existe formalmente en el catálogo principal, pero no tiene ninguna transacción asociada en la tabla de ventas (ejemplo: Hub USB-C 7p con venta_id en NULL).
* Consulta 2 (p.producto_id IS NULL): Indica que se ha registrado una transacción de venta física en el sistema, pero su código de producto no corresponde a ningún artículo de la base de datos de productos (ejemplo: venta_id 10 con producto_id 999 donde las columnas de productos retornan NULL).

---

### 4. ¿Cuándo usarías FULL OUTER JOIN en un caso real de negocio?
Un FULL OUTER JOIN se utiliza en escenarios de auditoría integral, reconciliación contable y migración de sistemas, donde se requiere analizar la totalidad de dos fuentes de datos simultáneamente sin omitir registros no coincidentes de ninguna de las dos partes.

Caso real de negocio:
En un departamento de Recursos Humanos y Gestión de Proyectos, al cruzar la tabla de Empleados con la tabla de Proyectos:
* Un FULL OUTER JOIN permite obtener en un solo reporte de control:
  1. Los empleados asignados activamente a proyectos (coincidencia de ambas tablas).
  2. Los empleados en nómina que no tienen ningún proyecto asignado (id_proyecto IS NULL).
  3. Los proyectos registrados que carecen de empleados asignados (id_empleado IS NULL).
De este modo, la gerencia dispone de una visión global para optimizar la asignación del personal inactivo y cubrir vacantes en proyectos sin perder de vista ningún registro.
