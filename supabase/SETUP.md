# Preparar el directorio compartido de CercaCerca

CercaCerca y Rescate del Día usan el mismo proyecto Supabase. La tabla `providers` guarda servicios enviados para revisión; `catalog_products` es una tabla aparte y solo contiene productos de negocios designados expresamente como vendedores y autorizados individualmente. La integración del catálogo es un piloto: no procesa pedidos, apartados ni pagos.

## Preparación
1. En el proyecto Supabase compartido, ejecutar primero `schema.sql` si todavía no existe la tabla `providers`.
2. Ejecutar una sola vez `catalog-products.sql` en SQL Editor. Es una migración aditiva para la nueva tabla; no modifica `providers`, `rescate_state`, ni el inventario privado.
3. Verificar que la tabla `catalog_products` exista y que RLS esté habilitado antes de probar el catálogo. No usar la clave `service_role` en el navegador, chat ni repositorio.
4. Los permisos públicos solo permiten leer columnas del catálogo de filas aprobadas con existencias mayores que cero. El identificador de cuenta y el identificador privado del producto no se exponen a visitantes anónimos.

## Publicación y venta manual
- La designación de vendedor de productos es por negocio y está desactivada por defecto; los perfiles de servicio como Autolavado no son elegibles. Cada producto permanece privado hasta que su dueño activa la designación, pulsa «Publicar en CercaCerca» y acepta expresamente mostrar nombre del negocio, producto, categoría, zona, precio, existencias disponibles y WhatsApp.
- La solicitud se crea con estado `pending`. La cuenta del dueño no puede cambiar el estado; una persona administradora debe aprobarla manualmente desde Supabase.
- Al ajustar existencias en Rescate del Día, se sincronizan las existencias disponibles del catálogo descontando las cantidades comprometidas en ofertas activas. El catálogo público oculta productos con cero existencias.
- El cliente inicia una consulta por WhatsApp. El negocio confirma manualmente y registra la venta como «Salida / venta» en Rescate del Día. No hay checkout, pago ni reserva automática.
- El WhatsApp se configura por negocio y queda vacío por defecto. Solo se publica para los productos que el dueño autoriza.
