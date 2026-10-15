# Preparar la base compartida de CercaCerca

La app publicada aún no está conectada a esta base. Este esquema deja los datos privados hasta que una ficha se apruebe; requiere un proyecto Supabase del propietario de CercaCerca.

## Configuración
1. Crear un proyecto de Supabase (el plan gratuito sirve para una prueba pequeña).
2. En el SQL Editor, ejecutar `schema.sql`.
3. Copiar la URL del proyecto y su clave pública **publishable/anon** a una configuración pública de la app.
4. No copiar nunca la `service_role` key al sitio, al chat ni al repositorio.
5. Antes de abrir el registro al público, añadir protección contra spam y un procedimiento de baja/corrección de fichas.

## Cómo se publican los datos
- Una ficha solo aparece en el directorio después de que el dueño la revise y cambie `status` a `approved`.
- La persona que la registra debe aceptar expresamente que se muestren su nombre comercial, servicio, zona, WhatsApp, precio y horario.
- El contacto queda visible al público si se aprueba; no se debe registrar el número de otra persona sin su consentimiento.
- Los ejemplos de la demo no se importan como negocios reales.

El esquema permite que visitantes vean únicamente fichas aprobadas y envíen propuestas pendientes. La moderación se realiza desde el panel de Supabase; nunca se incluye una clave administrativa en el navegador.
