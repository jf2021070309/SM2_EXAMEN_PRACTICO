# SM2_EXAMEN_PRACTICO

- Curso: SOLUCIONES MÓVILES II - SECCIÓN A
- Alumno: Jaime Elias Flores Quispe
- Fecha de entrega: 2025-10-21
- Repositorio público: https://github.com/jf2021070309/SM2_EXAMEN_PRACTICO

## Descripción del proyecto
Aplicación móvil desarrollada como entregable del Examen Práctico de la Unidad II del curso Soluciones Móviles II. La aplicación implementa la historia de usuario solicitada en el enunciado del examen, registrando y mostrando el historial de inicios de sesión de usuarios para permitirles ver cuándo y desde qué dispositivo o IP accedieron a su cuenta.

## Historia de usuario
Historia de Usuario para el Examen de la Unidad II de Móviles II

Historia de Usuario:
Como usuario autenticado,
quiero ver un historial de mis inicios de sesión,
para saber cuándo y desde qué dispositivo accedí a mi cuenta.

Criterios de Aceptación

• Al iniciar sesión exitosamente, se registra el usuario, la fecha y hora del inicio, así como la dirección IP desde donde inició sesión.

• En la sección "Historial de inicios de sesión", el usuario puede ver una lista con:

  o Usuario, la Fecha y hora de inicio de sesión
  
• Los registros se deben mostrar ordenados del más reciente al más antiguo.

## Funcionalidades implementadas 
- Registro de inicio de sesión (al iniciar sesión exitosamente):
- la aplicación registra automáticamente un evento de auditoría con los siguientes campos:
- Usuario: identificador y nombre de usuario del usuario autenticado.
- Fecha y hora: marca de tiempo del inicio de sesión guardada en Firestore.
- Dirección IP: IP pública desde donde se realizó el inicio de sesión .
    
    <img width="396" height="851" alt="image" src="https://github.com/user-attachments/assets/13bf3fbb-10a5-47aa-8c91-81f8abe1dc0a" />
    
- Implementacion de un botón en la seccion de Perfil "Historial de inicios de sesion"
- Se añadió un botón en la pantalla de Perfil del usuario con la etiqueta “Historial de inicios de sesión”. Al pulsarlo, el usuario accede a la pantalla donde se listan sus inicios de sesión recientes.
- Captura: botón en Perfil
  
    <img width="400" height="848" alt="image" src="https://github.com/user-attachments/assets/84a1a4d3-1875-45b5-a329-76cbb8915fa9" />

- Pantalla "Historial de inicios de sesión":

- La pantalla muestra una lista de eventos de inicio de sesión con diseño agradable (tarjetas, avatar, iconos) y la siguiente información por registro:

- Usuario (username)
- Fecha y hora (formateada en español, ajustada a la zona horaria local configurada: America/Lima)
- Dirección IP 
    
    <img width="411" height="847" alt="image" src="https://github.com/user-attachments/assets/bd2cdc52-8107-48aa-b1cc-5ace834f4454" />


## Evidencia registro en bd Firebase
- Se empleó los documentos "usuarios" y "login_audits"
<img width="1408" height="810" alt="image" src="https://github.com/user-attachments/assets/73db0ab4-4fde-48ff-86d8-9b755cbcff33" />


