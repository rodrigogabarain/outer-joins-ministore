-- ══════════════════════════════════════════
-- MiniStore — Soluciones con Outer JOINs
-- Autor: Rodrigo Gabarain
-- Fecha: 06/10/2026
-- ══════════════════════════════════════════

-- ── CONSULTA 1: LEFT JOIN ─────────────────
-- Pregunta de negocio: ¿Qué productos del catálogo nunca fueron vendidos?
-- Mostramos los productos que no registran ninguna venta asociada (v.venta_id es NULL).

SELECT 
    p.producto_id,
    p.nombre,
    p.categoria,
    p.precio,
    v.venta_id
FROM productos p
LEFT JOIN ventas v ON p.producto_id = v.producto_id
WHERE v.venta_id IS NULL;


-- ── CONSULTA 2: RIGHT JOIN ────────────────
-- Pregunta de negocio: ¿Existen ventas registradas con productos que no figuran en nuestro catálogo?
-- Identificamos ventas huérfanas con producto_id inexistente en la tabla productos (p.producto_id es NULL).

SELECT 
    v.venta_id,
    v.producto_id AS producto_id_venta,
    v.cliente_id,
    v.cantidad,
    v.fecha_venta,
    p.nombre AS nombre_producto_catalogo
FROM productos p
RIGHT JOIN ventas v ON p.producto_id = v.producto_id
WHERE p.producto_id IS NULL;


-- ── CONSULTA 3: FULL OUTER JOIN ───────────
-- Pregunta de negocio: Vista completa de auditoría que muestre todos los productos y todas las ventas
-- sin perder ninguna fila, identificando productos sin ventas y ventas sin producto.

-- Estándar SQL (Funciona en PostgreSQL, SQL Server, Oracle, etc.):
SELECT 
    p.producto_id AS id_producto_catalogo,
    p.nombre,
    p.categoria,
    v.venta_id,
    v.producto_id AS id_producto_venta,
    v.cantidad,
    v.fecha_venta
FROM productos p
FULL OUTER JOIN ventas v ON p.producto_id = v.producto_id
ORDER BY p.producto_id, v.venta_id;


-- ── VARIANTE ALTERNATIVA PARA MYSQL ────────
-- Dado que MySQL no soporta nativamente la sintaxis FULL OUTER JOIN,
-- se simula combinando un LEFT JOIN con un RIGHT JOIN mediante UNION:
/*
SELECT p.producto_id AS id_producto_catalogo, p.nombre, p.categoria, v.venta_id, v.producto_id AS id_producto_venta, v.cantidad, v.fecha_venta
FROM productos p
LEFT JOIN ventas v ON p.producto_id = v.producto_id
UNION
SELECT p.producto_id AS id_producto_catalogo, p.nombre, p.categoria, v.venta_id, v.producto_id AS id_producto_venta, v.cantidad, v.fecha_venta
FROM productos p
RIGHT JOIN ventas v ON p.producto_id = v.producto_id;
*/
