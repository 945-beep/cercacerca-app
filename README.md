# CercaCerca — prototipo público

Prototipo local para descubrir productos, servicios y ofertas en Atlacomulco, con una vista inicial para clientes y otra para negocios. Pensado como PWA instalable en Android.

## Funciona en la demo actual
- Búsqueda que ignora acentos, filtros por tipo (productos, servicios y ofertas), por categoría y estado sin resultados.
- Ejemplos ficticios de productos y ofertas claramente marcados; no incluyen negocios reales ni teléfonos.
- Alta y eliminación de fichas locales; cada ficha puede incluir precio aproximado y horario.
- Las fichas de servicios aprobadas pueden contactar por WhatsApp al pulsar el botón; se agrega la lada 52 a números mexicanos de 10 dígitos.
- Iconos PWA y cache básico para uso sin conexión.

## Preparación para el directorio compartido
Hay un esquema inicial de Supabase en `schema.sql`. Cuando se conecte un proyecto, las propuestas de servicio quedarán privadas como `pending` y solo las fichas revisadas manualmente podrán aparecer en público. La integración requiere URL del proyecto y clave pública anon/publishable. Nunca poner una `service_role` key en la web. Guía: `SETUP.md`.

El sitio todavía no tiene un proyecto Supabase conectado; hasta entonces, las fichas creadas por visitantes solo se guardan en su navegador y los ejemplos ficticios permanecen visibles. La vista «Para negocios» es una maqueta inicial: catálogo de productos, ventas, pedidos compartidos y ofertas reales aún no están conectados.

## Límites
No hay verificación automática de proveedores, moderación integrada, reseñas, sincronización activa de inventario, registro de ventas, pedidos reales ni pagos. No se agregan negocios ni teléfonos reales sin permiso expreso. Confirma precio, disponibilidad y referencias antes de contratar.
