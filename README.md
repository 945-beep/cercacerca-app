# CercaCerca — prototipo público

Directorio local de servicios, pensado como web app instalable (PWA) en Android.

## Funciona en esta demo
- Búsqueda sin distinguir mayúsculas ni acentos, filtros por categoría y mensaje de "sin resultados".
- Alta y eliminación de perfiles de prueba en el almacenamiento local del dispositivo.
- Botón de WhatsApp para perfiles agregados. Los números de 10 dígitos mexicanos reciben prefijo 52 automáticamente; otros países deben incluir su lada internacional.
- Los datos del perfil solo viven en ese navegador. El enlace abre WhatsApp únicamente cuando alguien lo pulsa.
- Cache PWA con iconos PNG; la función sin conexión necesita una primera carga con conexión.

## Monetización planteada (no implementada)
Etapa inicial gratuita para captar oferta y demanda. Después se podría cobrar a proveedores por contactos válidos o por destacar el perfil, con precio y reglas transparentes.

## Límites y seguridad
No hay servidor, cuentas, moderación, reseñas verificadas, sincronización entre dispositivos ni pagos. Los perfiles iniciales son ficticios y se muestran como demos. La app no verifica a proveedores; confirma precio y referencias antes de contratar. No usar datos sensibles.

## Validación
Probada en el navegador con el catálogo de ejemplo y con operaciones de búsqueda, filtros, guardado, contacto y eliminación de un perfil de prueba. GitHub Pages sirve la demo pública sobre HTTPS.
