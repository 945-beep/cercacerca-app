# CercaCerca — catálogo público piloto

Prototipo local para descubrir productos y servicios de negocios de Atlacomulco, con una vista inicial para clientes y otra para negocios. PWA instalable en Android.

## Funciona
- Búsqueda y filtros por tipo y categoría; ejemplos ficticios identificados.
- Perfiles de servicios aprobados y lectura pública de productos del catálogo aprobados con existencias positivas.
- Las fichas de producto muestran negocio, producto, categoría, precio, unidad, existencias y contacto por WhatsApp.
- Flujo piloto manual: el cliente pregunta por WhatsApp; el vendedor confirma disponibilidad y registra la venta en Rescate del Día. No hay checkout, pagos ni apartados automáticos.
- La tabla `catalog_products` mantiene ocultos los identificadores privados y los productos no aprobados. Si la tabla no está disponible, el directorio de servicios y ejemplos sigue funcionando y presenta un aviso.
- Guía de configuración y revisión: `supabase/SETUP.md`.

## Seguridad y consentimiento
Los servicios y productos reales no se publican automáticamente. Cada negocio debe activar expresamente su designación como vendedor de productos; cada producto además necesita consentimiento explícito y aprobación administrativa manual. Los perfiles de servicio (incluido el Autolavado) no son elegibles para el catálogo de productos. El navegador no puede aprobar fichas. No introducir claves `service_role` en el frontend. Los ejemplos demo son ficticios.
