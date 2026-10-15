# CercaCerca — prototipo público

Directorio local de servicios de Atlacomulco, pensado como PWA instalable en Android.

## Funciona en la demo actual
- Búsqueda que ignora acentos, filtros por categoría y estado sin resultados.
- Fichas de muestra marcadas como ficticias; no incluyen negocios ni teléfonos reales.
- Alta y eliminación de fichas locales; cada ficha puede incluir precio aproximado y horario.
- El botón de WhatsApp se abre únicamente al pulsarlo; se agrega la lada 52 a números mexicanos de 10 dígitos.
- Iconos PWA y cache básico para uso sin conexión.

## Preparación para el directorio compartido
Hay un esquema inicial de Supabase en `schema.sql`. Cuando se conecte un proyecto, las propuestas de servicio quedarán privadas como `pending` y solo las fichas revisadas manualmente podrán aparecer en público. La integración requiere URL del proyecto y clave pública anon/publishable. Nunca poner una `service_role` key en la web. Guía: `SETUP.md`.

El sitio todavía no tiene un proyecto Supabase conectado; hasta entonces, las fichas creadas por visitantes solo se guardan en su propio navegador y los ejemplos ficticios permanecen visibles.

## Límites
No hay verificación automática de proveedores, moderación integrada, reseñas, sincronización activa ni pagos. No se agregan negocios ni teléfonos reales sin permiso expreso. Confirma precio, disponibilidad y referencias antes de contratar.
